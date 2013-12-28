//
//  FRPGalleryViewModelTests.m
//  FRP
//
//  Created by Ash Furrow on 10/21/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "Specta.h"
#import <OCMock/OCMock.h>

#import "FRPGalleryViewModel.h"

@interface FRPGalleryViewModel ()

-(RACSignal *)importPhotosSignal;

@end

SpecBegin(FRPGalleryViewModel)

describe(@"FRPGalleryViewModel", ^{
    it(@"should be initialized and call importPhotos", ^{
        id mockObject = [OCMockObject mockForClass:[FRPGalleryViewModel class]];
        [[[mockObject expect] andReturn:[RACSignal empty]] importPhotosSignal];
        
        mockObject = [mockObject init];
        
        [mockObject verify];
        [mockObject stopMocking];
    });
});


SpecEnd