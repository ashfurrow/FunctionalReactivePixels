//
//  FRPPhotoImporterTests.m
//  FRP
//
//  Created by Phat, Le Tan on 2/24/14.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "FRPPhotoImporter.h"

SpecBegin(FRPPhotoImporter)

describe(@"FRPPhotoImporter", ^{
    __block id mock;
    beforeEach(^{
        mock = [OCMockObject mockForClass:[PXRequest class]];
    });

    it(@"logins successfully", ^{
        __block id success = @0;
        void (^theBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
            void (^passedBlock)( BOOL );
            [invocation getArgument:&passedBlock atIndex:4];
            passedBlock(YES);
        };
        [[[mock stub] andDo:theBlock] authenticateWithUserName:[OCMArg any] password:[OCMArg any] completion:[OCMArg any]];

        [[FRPPhotoImporter logInWithUsername:@"username" password:@"password"] subscribeCompleted:^{
            success = @1;
        }];
        expect(success).to.equal(@1);
    });

    it(@"returns error when login unsuccessfully", ^{
        __block id expected_error;
        void (^theBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
            void (^passedBlock)( BOOL );
            [invocation getArgument:&passedBlock atIndex:4];
            passedBlock(NO);
        };
        [[[mock stub] andDo:theBlock] authenticateWithUserName:[OCMArg any] password:[OCMArg any] completion:[OCMArg any]];

        [[FRPPhotoImporter logInWithUsername:@"username" password:@"password"] subscribeError:^(NSError *error) {
            expected_error = error;
        }];
        expect([expected_error domain]).to.equal(@"500px API");
    });

    afterEach(^{
        mock = nil;
    });
});

SpecEnd