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

// Note: we're using RACSignal as the declared return type, even though it's a RACSubject
+(RACSignal *)importPhotos;

+(RACSignal *)fetchPhotoDetails:(FRPPhotoModel *)photoModel;

+(RACSignal *)logInWithUsername:(NSString *)username password:(NSString *)password;

+(RACSignal *)voteForPhoto:(FRPPhotoModel *)photoModel;

@end
