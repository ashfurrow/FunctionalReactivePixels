//
//  NSData+AFDecompression.m
//  Performance Problems Example
//
//  Created by Ash Furrow on 2012-12-28.
//  Copyright (c) 2012 Ash Furrow. All rights reserved.
//

#import "NSData+AFDecompression.h"

// Rounds numbers up to the specified multiple
NSInteger roundUp(NSInteger numToRound, NSInteger multiple)
{
	if(multiple == 0)
	{
		return numToRound;
	}
	
	NSInteger remainder = numToRound % multiple;
	if (remainder == 0)
    {
		return numToRound;
    }
    
	return numToRound + multiple - remainder;
}

@implementation NSData (AFDecompression)

-(void)af_decompressedImageFromJPEGDataWithCallback:(AFJPEGWasDecompressedCallback)callback
{
    uint8_t character = '\0';
    if (self.length > 0) {
        [self getBytes:&character length:1];
    }
    
    if (character != 0xFF)
    {
        // This is not a valid JPEG.
        callback(nil);
        
        return;
    }
    
    // Creates a data provider, referencing ourself as the data.
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)self);
    
    // Use the data provider to get a CGImage and release the data provider.
    CGImageRef image = CGImageCreateWithJPEGDataProvider(dataProvider, NULL, NO, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    
    // Create a bitmap context of a suitable size to draw to, forcing decode
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
	size_t bytesPerRow = roundUp(width * 4, 16);
	size_t byteCount = roundUp(height * bytesPerRow, 16);
	
    if (width == 0 || height == 0)
    {
        CGImageRelease(image);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(nil);
        });
        
        return;
    }
    
    // Create the colour space and an image buffer
	void *imageBuffer = malloc(byteCount);
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create the image context and release the colour space.
    CGContextRef imageContext = CGBitmapContextCreate(imageBuffer, width, height, 8, bytesPerRow, colourSpace, kCGImageAlphaNone | kCGImageAlphaNoneSkipLast);
    CGColorSpaceRelease(colourSpace);
    
    // Draw the image to the context and release it.
    CGContextDrawImage(imageContext, CGRectMake(0, 0, width, height), image);
    CGImageRelease(image);
    
    // Now get an image ref from the context.
    CGImageRef outputImage = CGBitmapContextCreateImage(imageContext);
    
    // Clean up memory allocated by the colour space and image buffer.
    CGContextRelease(imageContext);
    free(imageBuffer);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *image = [UIImage imageWithCGImage:outputImage];
        callback(image);
        // Release the output image after the callback has been completed.
        CGImageRelease(outputImage);
    });
}

@end
