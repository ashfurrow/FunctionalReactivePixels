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

@interface FRPGalleryViewModel ()

@end

@implementation FRPGalleryViewModel

-(instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    RAC(self, model) = [self importPhotosSignal];
    
    return self;
}

-(RACSignal *)importPhotosSignal {
    return [[[FRPPhotoImporter importPhotos] logError] catchTo:[RACSignal empty]];
}

@end
