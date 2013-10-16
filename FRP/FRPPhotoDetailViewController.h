//
//  FRPPhotoDetailViewController.h
//  FRP
//
//  Created by Ash Furrow on 10/15/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRPPhotoModel;

@interface FRPPhotoDetailViewController : UIViewController

-(instancetype)initWithPhotoModel:(FRPPhotoModel *)photoModel;

@property (nonatomic, readonly) FRPPhotoModel *photoModel;

@end
