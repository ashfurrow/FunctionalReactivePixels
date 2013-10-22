//
//  FRPGalleryViewModel.m
//  FRP
//
//  Created by Ash Furrow on 10/21/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "FRPGalleryViewModel.h"

// Utilities
#import "FRPPhotoImporter.h"

@implementation FRPGalleryViewModel

-(instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    @weakify(self);
    self.collectionViewReloadCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
    RAC(self, photosArray) = [[[[FRPPhotoImporter importPhotos] doCompleted:^{
        @strongify(self)
        [self.collectionViewReloadCommand execute:nil];
    }] logError] catchTo:[RACSignal empty]];
    
    return self;
}

@end
