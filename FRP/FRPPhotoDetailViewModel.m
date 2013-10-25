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

@property (nonatomic, strong) NSString *photoName;
@property (nonatomic, strong) NSString *photoRating;
@property (nonatomic, strong) NSString *photographerName;
@property (nonatomic, strong) NSString *votePromptText;

@property (nonatomic, strong) RACCommand *voteCommand;

@end

@implementation FRPPhotoDetailViewModel

-(instancetype)initWithModel:(FRPPhotoModel *)photoModel {
    self = [super initWithModel:photoModel];
    if (!self) return nil;
    
    RAC(self, photoName) = RACObserve(self.model, photoName);
    RAC(self, photoRating) = [RACObserve(self.model, rating) map:^id(id value) {
        return [NSString stringWithFormat:@"%0.2f", [value floatValue]];
    }];
    RAC(self, photographerName) = RACObserve(self.model, photographerName);
    RAC(self, votePromptText) = [RACObserve(self.model, votedFor) map:^id(id value) {
        if ([value boolValue]) {
            return @"Voted For!";
        } else {
            return @"Vote";
        }
    }];
    
    @weakify(self);
    self.voteCommand = [[RACCommand alloc] initWithEnabled:[RACObserve(self.model, votedFor) not] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [FRPPhotoImporter voteForPhoto:self.model];
    }];
    
    return self;
}

-(BOOL)loggedIn {
    return [[PXRequest apiHelper] authMode] == PXAPIHelperModeOAuth;
}

@end
