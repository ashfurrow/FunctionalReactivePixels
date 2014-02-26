//
//  FRPPhotoImporter.m
//  FRP
//
//  Created by Ash Furrow on 10/13/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "FRPPhotoImporter.h"
#import "FRPPhotoModel.h"

@implementation FRPPhotoImporter

+(NSURLRequest *)popularURLRequest {
    return [[PXRequest apiHelper] urlRequestForPhotoFeature:PXAPIHelperPhotoFeaturePopular resultsPerPage:100 page:0 photoSizes:PXPhotoModelSizeThumbnail sortOrder:PXAPIHelperSortOrderRating except:PXPhotoModelCategoryNude];
}

+(NSURLRequest *)photoURLRequest:(FRPPhotoModel *)photoModel {
    return [[PXRequest apiHelper] urlRequestForPhotoID:photoModel.identifier.integerValue];
}

+(RACSignal *)requestPhotoData
{
    NSURLRequest *request = [self popularURLRequest];
    
    return [[NSURLConnection rac_sendAsynchronousRequest:request] reduceEach:^id(NSURLResponse *response, NSData *data){
        return data;
    }];
}

+(RACSignal *)importPhotos {
    return [[[[[self requestPhotoData] deliverOn:[RACScheduler mainThreadScheduler]] map:^id(NSData *data) {
        id results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        return [[[results[@"photos"] rac_sequence] map:^id(NSDictionary *photoDictionary) {
            FRPPhotoModel *model = [FRPPhotoModel new];
            
            [self configurePhotoModel:model withDictionary:photoDictionary];
            [self downloadThumbnailForPhotoModel:model];
            
            return model;
        }] array];
    }] publish] autoconnect];
}

+(RACSignal *)fetchPhotoDetails:(FRPPhotoModel *)photoModel {
    NSURLRequest *request = [self photoURLRequest:photoModel];
    return [[[[[[NSURLConnection rac_sendAsynchronousRequest:request] reduceEach:^id(NSURLResponse *response, NSData *data){
        return data;
    }] deliverOn:[RACScheduler mainThreadScheduler]] map:^id(NSData *data) {
        id results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil][@"photo"];
        
        [self configurePhotoModel:photoModel withDictionary:results];
        [self downloadFullsizedImageForPhotoModel:photoModel];
        
        return photoModel;
    }] publish] autoconnect];
}

+(RACSignal *)logInWithUsername:(NSString *)username password:(NSString *)password {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [PXRequest authenticateWithUserName:username password:password completion:^(BOOL success) {
            if (success) {
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:[NSError errorWithDomain:@"500px API" code:0 userInfo:@{NSLocalizedDescriptionKey: @"Could not log in."}]];
            }
        }];
        
        // Cannot cancel request
        return nil;
    }];
}

+(RACSignal *)voteForPhoto:(FRPPhotoModel *)photoModel {
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        PXRequest *voteRequest = [PXRequest requestToVoteForPhoto:[photoModel.identifier integerValue] completion:^(NSDictionary *results, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            } else {
                photoModel.votedFor = YES;
                [subscriber sendCompleted];
            }
        }];
        
        return [RACDisposable disposableWithBlock:^{
            if (voteRequest.requestStatus == PXRequestStatusStarted) {
                [voteRequest cancel];
            }
        }];
    }] publish] autoconnect];
}

#pragma mark - Private Methods

+(void)configurePhotoModel:(FRPPhotoModel *)photoModel withDictionary:(NSDictionary *)dictionary {
    // Basics details fetched with the first, basic request
    photoModel.photoName = dictionary[@"name"];
    photoModel.identifier = dictionary[@"id"];
    photoModel.photographerName = dictionary[@"user"][@"username"];
    photoModel.rating = dictionary[@"rating"];

    photoModel.thumbnailURL = [self urlForImageSize:3 inDictionary:dictionary[@"images"]];
    
    if (dictionary[@"voted"]) {
        photoModel.votedFor = [dictionary[@"voted"] boolValue];
    }
    
    // Extended attributes fetched with subsequent request
    if (dictionary[@"comments_count"]) {
        photoModel.fullsizedURL = [self urlForImageSize:4 inDictionary:dictionary[@"images"]];
    }
}

+(NSString *)urlForImageSize:(NSInteger)size inDictionary:(NSArray *)array {
    /*
    (
        {
            size = 3;
            url = "http://ppcdn.500px.org/49204370/b125a49d0863e0ba05d8196072b055876159f33e/3.jpg";
        }
     );
     */
    
    return [[[[[array rac_sequence] filter:^BOOL(NSDictionary *value) {
        return [value[@"size"] integerValue] == size;
    }] map:^id(id value) {
        return value[@"url"];
    }] array] firstObject];
}

+(void)downloadThumbnailForPhotoModel:(FRPPhotoModel *)photoModel {
    RAC(photoModel, thumbnailData) = [self download:photoModel.thumbnailURL];
}

+(void)downloadFullsizedImageForPhotoModel:(FRPPhotoModel *)photoModel {
    RAC(photoModel, fullsizedData) = [self download:photoModel.fullsizedURL];
}

+(RACSignal *)download:(NSString *)urlString {
    NSAssert(urlString, @"URL must not be nil");
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    return [[[NSURLConnection rac_sendAsynchronousRequest:request] reduceEach:^id(NSURLResponse *response, NSData *data){
        return data;
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}

@end
