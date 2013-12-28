//
//  FRPPhotoViewModel.h
//  FRP
//
//  Created by Ash Furrow on 10/22/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FRPPhotoModel;

@interface FRPPhotoViewModel : RVMViewModel

@property (nonatomic, readonly) FRPPhotoModel *model;

@property (nonatomic, readonly) UIImage *photoImage;
@property (nonatomic, readonly, getter = isLoading) BOOL loading;

-(NSString *)photoName;

@end
