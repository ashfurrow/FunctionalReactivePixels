//
//  FRPPhotoDetailViewController.h
//  FRP
//
//  Created by Ash Furrow on 10/15/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRPPhotoDetailViewModel;

@interface FRPPhotoDetailViewController : UIViewController

-(instancetype)initWithViewModel:(FRPPhotoDetailViewModel *)viewModel;

@property (nonatomic, readonly) FRPPhotoDetailViewModel *viewModel;

@end
