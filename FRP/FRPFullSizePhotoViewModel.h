//
//  FRPFullSizePhotoViewModel.h
//  FRP
//
//  Created by Ash Furrow on 10/21/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FRPPhotoModel;

@interface FRPFullSizePhotoViewModel : NSObject

-(instancetype)initWithPhotoModelArray:(NSArray *)photoModelArray initialPhotoIndex:(NSInteger)initialPhotoIndex;

@property (nonatomic, readonly) NSArray *photoArray;
@property (nonatomic, readonly) NSInteger initialPhotoIndex;

-(FRPPhotoModel *)initialPhotoModel;

@end
