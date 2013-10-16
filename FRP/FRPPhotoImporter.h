//
//  FRPPhotoImporter.h
//  FRP
//
//  Created by Ash Furrow on 10/13/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FRPPhotoModel;

@interface FRPPhotoImporter : NSObject

+(RACSubject *)importPhotos;

+(RACSubject *)fetchPhotoDetails:(FRPPhotoModel *)photoModel;

@end
