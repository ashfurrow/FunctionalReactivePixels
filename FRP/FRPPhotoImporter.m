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

+(NSURLRequest *)urlRequest {
    return [AppDelegate.apiHelper urlRequestForPhotoFeature:PXAPIHelperPhotoFeaturePopular resultsPerPage:100 page:1 photoSizes:PXPhotoModelSizeThumbnail sortOrder:PXAPIHelperSortOrderRating except:PXPhotoModelCategoryNude];
}

+(RACSubject *)importPhotos {
    RACSubject *subject = [RACSubject subject];
    
    
    NSURLRequest *request = [self urlRequest];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            id results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            [subject sendNext:[[results[@"photos"] rac_sequence] map:^id(NSDictionary *photoDictionary) {
                FRPPhotoModel *model = [FRPPhotoModel new];
                
                //TODO: Set properties
                
                return model;
            }]];
            [subject sendCompleted];
        }
        else {
            [subject sendError:connectionError];
        }
    }];
    
    return subject;
}

@end
