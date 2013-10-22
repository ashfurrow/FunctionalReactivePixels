//
//  FRPPhotoViewController.h
//  FRP
//
//  Created by Ash Furrow on 10/15/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRPPhotoViewModel;

@interface FRPPhotoViewController : UIViewController

-(instancetype)initWithViewModel:(FRPPhotoViewModel *)viewModel index:(NSInteger)photoIndex;

@property (nonatomic, readonly) NSInteger photoIndex;

@property (nonatomic, readonly) FRPPhotoViewModel *viewModel;

@end
