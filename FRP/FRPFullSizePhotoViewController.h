//
//  FRPFullSizePhotoViewController.h
//  FRP
//
//  Created by Ash Furrow on 10/15/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRPFullSizePhotoViewController;

@protocol FRPFullSizePhotoViewControllerDelegate <NSObject>

-(void)userDidScroll:(FRPFullSizePhotoViewController *)viewController toPhotoAtIndex:(NSInteger)index;

@end


@class FRPFullSizePhotoViewModel;

@interface FRPFullSizePhotoViewController : UIViewController

@property (nonatomic, strong) FRPFullSizePhotoViewModel *viewModel;

@property (nonatomic, weak) id<FRPFullSizePhotoViewControllerDelegate> delegate;

@end
