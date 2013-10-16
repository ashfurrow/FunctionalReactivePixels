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

@interface FRPFullSizePhotoViewController : UIViewController

-(instancetype)initWithPhotoModels:(NSArray *)photoModelArray currentPhotoIndex:(NSInteger)photoIndex;

@property (nonatomic, readonly) NSArray *photoModelArray;
@property (nonatomic, weak) id<FRPFullSizePhotoViewControllerDelegate> delegate;

@end
