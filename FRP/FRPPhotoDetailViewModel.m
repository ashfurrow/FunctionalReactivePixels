//
//  FRPPhotoDetailViewModel.m
//  FRP
//
//  Created by Ash Furrow on 10/22/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "FRPPhotoDetailViewModel.h"

// Model
#import "FRPPhotoModel.h"

// Utilities
#import "FRPPhotoImporter.h"

@interface FRPPhotoDetailViewModel ()

@property (nonatomic, strong) FRPPhotoModel *photoModel;

@property (nonatomic, strong) NSString *photoName;
@property (nonatomic, strong) NSString *photoRating;
@property (nonatomic, strong) NSString *photographerName;
@property (nonatomic, strong) NSString *voteButtonText;

@property (nonatomic, strong) RACCommand *voteCommand;

@end

@implementation FRPPhotoDetailViewModel

-(instancetype)initWithPhotoModel:(FRPPhotoModel *)photoModel {
    self = [self init];
    if (!self) return nil;
    
    self.photoModel = photoModel;
    
    RAC(self, photoName) = RACObserve(self.photoModel, photoName);
    RAC(self, photoRating) = [RACObserve(self.photoModel, rating) map:^id(id value) {
        return [NSString stringWithFormat:@"%0.2f", [value floatValue]];
    }];
    RAC(self, photographerName) = RACObserve(self.photoModel, photographerName);
    RAC(self, voteButtonText) = [RACObserve(self.photoModel, votedFor) map:^id(id value) {
        if ([value boolValue]) {
            return @"Voted For!";
        } else {
            return @"Vote";
        }
    }];
    
    @weakify(self);
    self.voteCommand = [[RACCommand alloc] initWithEnabled:[RACObserve(self.photoModel, votedFor) not] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [FRPPhotoImporter voteForPhoto:self.photoModel];
    }];
    
    return self;
}

-(BOOL)loggedIn {
    return [[PXRequest apiHelper] authMode] == PXAPIHelperModeOAuth;
}

@end
