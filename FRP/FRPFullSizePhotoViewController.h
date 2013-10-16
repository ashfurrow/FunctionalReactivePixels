//
//  FRPFullSizePhotoViewController.h
//  FRP
//
//  Created by Ash Furrow on 10/15/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRPFullSizePhotoViewController : UIViewController

-(instancetype)initWithPhotoModels:(NSArray *)photoModelArray currentPhotoIndex:(NSInteger)photoIndex;

@property (nonatomic, readonly) NSArray *photoModelArray;

@end
