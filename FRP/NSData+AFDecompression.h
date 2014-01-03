//
//  NSData+AFDecompression.h
//  Performance Problems Example
//
//  Created by Ash Furrow on 2012-12-28.
//  Copyright (c) 2012 Ash Furrow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ReactiveCocoa/ReactiveCocoa.h"

typedef void (^AFJPEGWasDecompressedCallback)(UIImage *decompressedImage);

@interface NSData (AFDecompression)

// The callback block is executed on the main thread.
-(void)af_decompressedImageFromJPEGDataWithCallback:(AFJPEGWasDecompressedCallback)callback;

@end
