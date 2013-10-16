//
//  FRPPhotoViewController.h
//  FRP
//
//  Created by Ash Furrow on 10/15/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRPPhotoModel;

@interface FRPPhotoViewController : UIViewController

-(instancetype)initWithPhotoModel:(FRPPhotoModel *)photoModel index:(NSInteger)photoIndex;

@property (nonatomic, readonly) NSInteger photoIndex;
@property (nonatomic, readonly) FRPPhotoModel *photoModel;

@end
