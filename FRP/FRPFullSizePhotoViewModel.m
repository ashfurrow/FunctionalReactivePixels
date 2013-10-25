//
//  FRPFullSizePhotoViewModel.m
//  FRP
//
//  Created by Ash Furrow on 10/21/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "FRPFullSizePhotoViewModel.h"

// Model
#import "FRPPhotoModel.h"


@interface FRPFullSizePhotoViewModel ()

// Private access
@property (nonatomic, strong) NSArray *photoArray;
@property (nonatomic, assign) NSInteger initialPhotoIndex;

@end

@implementation FRPFullSizePhotoViewModel

-(instancetype)initWithPhotoModelArray:(NSArray *)photoModelArray initialPhotoIndex:(NSInteger)initialPhotoIndex {
    self = [self init];
    if (!self) return nil;
    
    self.photoArray = photoModelArray;
    self.initialPhotoIndex = initialPhotoIndex;
    
    return self;
}

-(NSString *)initialPhotoName {
    return [self.photoArray[self.initialPhotoIndex] photoName];
}

-(FRPPhotoModel *)photoModelAtIndex:(NSInteger)index {
    if (index < 0 || index > self.photoArray.count - 1) {
        // Index was out of bounds, return nil
        return nil;
    } else {
        return self.photoArray[index];
    }
}

@end
