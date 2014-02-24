//
//  FRPLoginViewModelTests.m
//  FRP
//
//  Created by Phat, Le Tan on 2/24/14.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "FRPLoginViewModel.h"

@interface FRPLoginViewModel()

- (RACSignal *)validateLoginInputs;

@end

SpecBegin(FRPLoginViewModel)

__block FRPLoginViewModel *viewModel;

beforeEach(^{
    viewModel = [[FRPLoginViewModel alloc] initWithModel:nil];
});

describe(@"FRPLoginViewModel", ^{
    it(@"disable login command when username is empty", ^{
        viewModel.username = @"";
        viewModel.password = @"password";
        __block id result;
        [[viewModel validateLoginInputs] subscribeNext:^(id x) {
            result = x;
        }];
        expect(result).to.equal(@0);
    });

    it(@"disable login command when password is empty", ^{
        viewModel.username = @"username";
        viewModel.password = @"";
        __block id result;
        [[viewModel validateLoginInputs] subscribeNext:^(id x) {
            result = x;
        }];
        expect(result).to.equal(@0);
    });

    it(@"enable login command when username and password are available", ^{
        viewModel.username = @"username";
        viewModel.password = @"password";
        __block id result;
        [[viewModel validateLoginInputs] subscribeNext:^(id x) {
            result = x;
        }];
        expect(result).to.equal(@1);
    });
});

afterEach(^{
    viewModel = nil;
});

SpecEnd