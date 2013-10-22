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

@property (nonatomic, strong) RACCommand *viewDidAppearCommand;
@property (nonatomic, strong) FRPPhotoModel *photoModel;
@property (nonatomic, strong) RACSignal *photoImageSignal;

@end

@implementation FRPPhotoViewModel

-(instancetype)initWithPhotoModel:(FRPPhotoModel *)photoModel {
    self = [self init];
    if (!self) return nil;
    
    self.photoModel = photoModel;
    
    @weakify(self);
    self.viewDidAppearCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            // Fetch data
            [[FRPPhotoImporter fetchPhotoDetails:self.photoModel] subscribeError:^(NSError *error) {
                [subscriber sendError:nil];
            } completed:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }];

    self.photoImageSignal = [RACObserve(self.photoModel, fullsizedData) map:^id(id value) {
        return [UIImage imageWithData:value];
    }];

    return self;
}

-(NSString *)photoName {
    return self.photoModel.photoName;
}

@end
