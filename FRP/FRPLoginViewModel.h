//
//  FRPLoginViewModel.h
//  FRP
//
//  Created by Ash Furrow on 10/22/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRPLoginViewModel : RVMViewModel

@property (nonatomic, readonly) RACCommand *loginCommand;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@end
