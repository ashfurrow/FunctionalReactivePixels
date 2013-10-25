//
//  FRPPhotoDetailViewModel.h
//  FRP
//
//  Created by Ash Furrow on 10/22/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FRPPhotoModel;

@interface FRPPhotoDetailViewModel : RVMViewModel

@property (nonatomic, readonly) FRPPhotoModel *model;

@property (nonatomic, readonly) NSString *photoName;
@property (nonatomic, readonly) NSString *photoRating;
@property (nonatomic, readonly) NSString *photographerName;
@property (nonatomic, readonly) NSString *votePromptText;

@property (nonatomic, readonly) RACCommand *voteCommand;

@property (nonatomic, readonly) BOOL loggedIn;

@end
