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
@property (nonatomic, assign) NSInteger initialPhotoIndex;

@end

@implementation FRPFullSizePhotoViewModel

-(instancetype)initWithPhotoArray:(NSArray *)photoArray initialPhotoIndex:(NSInteger)initialPhotoIndex {
    self = [self initWithModel:photoArray];
    if (!self) return nil;
    
    self.initialPhotoIndex = initialPhotoIndex;
    
    return self;
}

-(NSString *)initialPhotoName {
    FRPPhotoModel *photoModel = [self initialPhotoModel];
    return [photoModel photoName];
}

//-(NSString *)initialPhotoName {
//    return [self.model[self.initialPhotoIndex] photoName];
//}

-(FRPPhotoModel *)photoModelAtIndex:(NSInteger)index {
    if (index < 0 || index > self.model.count - 1) {
        // Index was out of bounds, return nil
        return nil;
    } else {
        return self.model[index];
    }
}

#pragma mark - Private Methods

-(FRPPhotoModel *)initialPhotoModel {
    return [self photoModelAtIndex:self.initialPhotoIndex];
}

@end
