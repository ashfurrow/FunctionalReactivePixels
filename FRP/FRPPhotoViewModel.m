//
//  FRPPhotoViewModel.m
//  FRP
//
//  Created by Ash Furrow on 10/22/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "FRPPhotoViewModel.h"

//Utilities
#import "FRPPhotoImporter.h"
#import "FRPPhotoModel.h"

@interface FRPPhotoViewModel ()

@property (nonatomic, strong) UIImage *photoImage;

@end

@implementation FRPPhotoViewModel

-(instancetype)initWithModel:(FRPPhotoModel *)photoModel {
    self = [super initWithModel:photoModel];
    if (!self) return nil;
    
    @weakify(self);
    [self.didBecomeActiveSignal subscribeNext:^(id x) {
        @strongify(self);
        [[FRPPhotoImporter fetchPhotoDetails:self.model] subscribeError:^(NSError *error) {
            NSLog(@"Could not fetch photo details: %@", error);
        } completed:^{
            NSLog(@"Fetched photo details.");
        }];
    }];
    
    RAC(self, photoImage) = [RACObserve(self.model, fullsizedData) map:^id(id value) {
        return [UIImage imageWithData:value];
    }];

    return self;
}

-(NSString *)photoName {
    return self.model.photoName;
}

@end
