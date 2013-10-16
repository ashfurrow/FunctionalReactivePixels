//
//  FRPPhotoViewController.m
//  FRP
//
//  Created by Ash Furrow on 10/15/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "FRPPhotoViewController.h"

// Model
#import "FRPPhotoModel.h"

@interface FRPPhotoViewController ()

// Private assignment
@property (nonatomic, assign) NSInteger photoIndex;
@property (nonatomic, strong) FRPPhotoModel *photoModel;

// Private properties
@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation FRPPhotoViewController

-(instancetype)initWithPhotoModel:(FRPPhotoModel *)photoModel index:(NSInteger)photoIndex
{
    self = [self init];
    if (!self) return nil;
    
    self.photoModel = photoModel;
    self.photoIndex = photoIndex;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure self's view
    self.view.backgroundColor = [UIColor blackColor];
    
    // Configure subviews
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    RAC(imageView, image) = [RACObserve(self.photoModel, fullsizedData) map:^id(id value) {
        return [UIImage imageWithData:value];
    }];
    [self.view addSubview:imageView];
    self.imageView = imageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
