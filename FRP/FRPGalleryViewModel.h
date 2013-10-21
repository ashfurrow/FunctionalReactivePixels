//
//  FRPGalleryViewModel.h
//  FRP
//
//  Created by Ash Furrow on 10/21/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRPGalleryViewModel : NSObject

@property (nonatomic, strong) NSArray *photosArray;

@property (nonatomic, strong) RACCommand *collectionViewReloadCommand;

@end
