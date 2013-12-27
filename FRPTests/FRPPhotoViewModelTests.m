//
//  FRPPhotoViewModelTests.m
//  FRP
//
//  Created by Ash Furrow on 12/26/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "FRPPhotoViewModel.h"
#import "FRPPhotoModel.h"

@interface FRPPhotoViewModel ()

-(void)downloadPhotoModelDetails;

@end

SpecBegin(FRPPhotoViewModel)

describe(@"FRPPhotoViewModel", ^{
    it (@"should return the photo's name property when photoName is invoked", ^{
        NSString *name = @"Ash";
        
        id mockPhotoModel = [OCMockObject mockForClass:[FRPPhotoModel class]];
        [[[mockPhotoModel stub] andReturn:name] photoName];
        
        FRPPhotoViewModel *viewModel = [[FRPPhotoViewModel alloc] initWithModel:nil];
        id mockViewModel = [OCMockObject partialMockForObject:viewModel];
        [[[mockViewModel stub] andReturn:mockPhotoModel] model];
        
        id returnedName = [mockViewModel photoName];
        
        expect(returnedName).to.equal(name);
    });
    
    it (@"should download photo model details when it becomes active", ^{
        FRPPhotoViewModel *viewModel = [[FRPPhotoViewModel alloc] initWithModel:nil];
        
        id mockViewModel = [OCMockObject partialMockForObject:viewModel];
        [[mockViewModel expect] downloadPhotoModelDetails];
        
        [mockViewModel setActive:YES];
        
        [mockViewModel verify];
    });
    
    pending (@"should correctly map image data to UIImage", ^{
        id mockPhotoModel = [OCMockObject mockForClass:[FRPPhotoViewModel class]];
        [[[mockPhotoModel expect] andReturn:nil] fullsizedData];
    });
    
    it (@"should return the correct photo name", ^{
        NSString *name = @"Ash";
        
        FRPPhotoModel *photoModel = [[FRPPhotoModel alloc] init];
        photoModel.photoName = name;
        
        FRPPhotoViewModel *viewModel = [[FRPPhotoViewModel alloc] initWithModel:photoModel];
        
        NSString *returnedName = [viewModel photoName];
        
        expect(name).to.equal(returnedName);
    });
});

SpecEnd
