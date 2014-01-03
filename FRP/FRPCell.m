//
//  FRPCell.m
//  FRP
//
//  Created by Ash Furrow on 10/13/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "FRPCell.h"
#import "FRPPhotoModel.m"
#import "NSData+AFDecompression.h"

@interface FRPCell ()

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation FRPCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    // Configure self
    self.backgroundColor = [UIColor darkGrayColor];
    
    // Configure subivews
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;

    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			[[RACScheduler scheduler] schedule:^{
				[input af_decompressedImageFromJPEGDataWithCallback:
				 ^(UIImage *decompressedImage) {
					[subscriber sendNext:decompressedImage];
					[subscriber sendCompleted];
				}];
			}];
			return nil;
		}];
	}];
	command.allowsConcurrentExecution = YES;

	RAC(self.imageView, image) = [[[RACObserve(self, photoModel.thumbnailData) ignore:nil] map:^id(id value) {
		return [command execute:value];
	}] switchToLatest];
	
    return self;
}

@end
