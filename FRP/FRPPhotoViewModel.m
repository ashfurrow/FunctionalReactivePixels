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
@property (nonatomic, assign, getter = isLoading) BOOL loading;

@end

@implementation FRPPhotoViewModel

-(instancetype)initWithModel:(FRPPhotoModel *)photoModel {
    self = [super initWithModel:photoModel];
    if (!self) return nil;
    
    @weakify(self);
    [self.didBecomeActiveSignal subscribeNext:^(id x) {
        @strongify(self);
        [self downloadPhotoModelDetails];
    }];
    
    RAC(self, photoImage) = [RACObserve(self.model, fullsizedData) map:^id(id value) {
        return [UIImage imageWithData:value];
    }];

    return self;
}

#pragma mark - Public Methods

-(NSString *)photoName {
    return self.model.photoName;
}

#pragma mark - Private Methods

-(void)downloadPhotoModelDetails {
    self.loading = YES;
    
    @weakify(self);
    [[FRPPhotoImporter fetchPhotoDetails:self.model] subscribeError:^(NSError *error) {
        NSLog(@"Could not fetch photo details: %@", error);
    } completed:^{
        @strongify(self);
        self.loading = NO;
        NSLog(@"Fetched photo details.");
    }];
}

@end
