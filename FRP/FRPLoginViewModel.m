//
//  FRPLoginViewModel.m
//  FRP
//
//  Created by Ash Furrow on 10/22/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "FRPLoginViewModel.h"
#import "FRPPhotoImporter.h"

@interface FRPLoginViewModel ()

@property (nonatomic, strong) RACCommand *loginCommand;

@end

@implementation FRPLoginViewModel

-(instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    @weakify(self);
    self.loginCommand = [[RACCommand alloc] initWithEnabled:[self validateLoginInputs]
                                                signalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [FRPPhotoImporter logInWithUsername:self.username password:self.password];
    }];
    
    return self;
}

- (RACSignal *)validateLoginInputs
{
    return [RACSignal combineLatest:@[RACObserve(self, username), RACObserve(self, password)] reduce:^id(NSString *username, NSString *password){
        return @(username.length > 0 && password.length > 0);
    }];
}

@end
