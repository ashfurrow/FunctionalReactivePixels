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

@end

@implementation FRPFullSizePhotoViewModel

-(NSString *)initialPhotoName {
    return [self.photoArray[self.initialPhotoIndex] photoName];
}

-(NSInteger)initialPhotoIndex {
    return [self.model.second integerValue];
}

-(NSArray *)photoArray {
    return self.model.first;
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
