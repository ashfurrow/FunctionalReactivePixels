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
        
        [mockPhotoModel stopMocking];
    });
    
    it (@"should download photo model details when it becomes active", ^{
        FRPPhotoViewModel *viewModel = [[FRPPhotoViewModel alloc] initWithModel:nil];
        
        id mockViewModel = [OCMockObject partialMockForObject:viewModel];
        [[mockViewModel expect] downloadPhotoModelDetails];
        
        [mockViewModel setActive:YES];
        
        [mockViewModel verify];
    });
    
    it (@"should correctly map image data to UIImage", ^{
        UIImage *image = [[UIImage alloc] init];
        NSData *imageData = [NSData data];
        
        id mockImage = [OCMockObject mockForClass:[UIImage class]];
        [[[mockImage stub] andReturn:image] imageWithData:imageData];
        
        FRPPhotoModel *photoModel = [[FRPPhotoModel alloc] init];
        photoModel.fullsizedData = imageData;
        
        __unused FRPPhotoViewModel *viewModel = [[FRPPhotoViewModel alloc] initWithModel:photoModel];
        
        [mockImage verify];
        [mockImage stopMocking];
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
