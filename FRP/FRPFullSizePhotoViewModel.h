//
//  FRPFullSizePhotoViewModel.h
//  FRP
//
//  Created by Ash Furrow on 10/21/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FRPPhotoModel;

@interface FRPFullSizePhotoViewModel : RVMViewModel

-(instancetype)initWithPhotoArray:(NSArray *)photoArray initialPhotoIndex:(NSInteger)initialPhotoIndex;
-(FRPPhotoModel *)photoModelAtIndex:(NSInteger)index;

@property (nonatomic, readonly, strong) NSArray *model;
@property (nonatomic, readonly) NSInteger initialPhotoIndex;

@property (nonatomic, readonly) NSString *initialPhotoName;

@end
