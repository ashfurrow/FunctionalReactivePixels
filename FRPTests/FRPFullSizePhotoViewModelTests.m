//
//  FRPFullSizePhotoViewModelTests.m
//  FRP
//
//  Created by Ash Furrow on 12/26/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "FRPFullSizePhotoViewModel.h"
#import "FRPPhotoModel.h"

@interface FRPFullSizePhotoViewModel ()

-(FRPPhotoModel *)initialPhotoModel;

@end

SpecBegin(FRPFullSizePhotoViewModel)

describe(@"FRPFullSizePhotomodel", ^{
    it (@"should assign correct attributes when initialized", ^{
        NSArray *model = @[];
        NSInteger initialPhotoIndex = 1337;
        
        FRPFullSizePhotoViewModel *viewModel = [[FRPFullSizePhotoViewModel alloc] initWithPhotoArray:model initialPhotoIndex:initialPhotoIndex];
        
        expect(model).to.equal(viewModel.model);
        expect(initialPhotoIndex).to.equal(viewModel.initialPhotoIndex);
    });
    
    it (@"should return nil for an out-of-bounds photo index", ^{
        NSArray *model = @[[NSObject new]];
        NSInteger initialPhotoIndex = 0;
        
        FRPFullSizePhotoViewModel *viewModel = [[FRPFullSizePhotoViewModel alloc] initWithPhotoArray:model initialPhotoIndex:initialPhotoIndex];
        
        id subzeroModel = [viewModel photoModelAtIndex:-1];
        expect(subzeroModel).to.beNil();
        
        id aboveBoundsModel = [viewModel photoModelAtIndex:model.count];
        expect(aboveBoundsModel).to.beNil();
    });
    
    it (@"should return the correct model for photoModelAtIndex:", ^{
        id photoModel = [NSObject new];
        NSArray *model = @[photoModel];
        NSInteger initialPhotoIndex = 0;
        
        FRPFullSizePhotoViewModel *viewModel = [[FRPFullSizePhotoViewModel alloc] initWithPhotoArray:model initialPhotoIndex:initialPhotoIndex];
        
        id returnedModel = [viewModel photoModelAtIndex:0];
        expect(returnedModel).to.equal(photoModel);
    });
    
    it (@"should return the correct initial photo model", ^{
        NSArray *model = @[[NSObject new]];
        NSInteger initialPhotoIndex = 0;
        
        FRPFullSizePhotoViewModel *viewModel = [[FRPFullSizePhotoViewModel alloc] initWithPhotoArray:model initialPhotoIndex:initialPhotoIndex];
        id mockViewModel = [OCMockObject partialMockForObject:viewModel];
        
        [[[mockViewModel expect] andReturn:model[0]] photoModelAtIndex:initialPhotoIndex];
        
        id returnedObject = [mockViewModel initialPhotoModel];
        
        expect(returnedObject).to.equal(model[0]);
        
        [mockViewModel verify];
    });
});

SpecEnd
