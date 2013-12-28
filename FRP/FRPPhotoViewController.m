//
//  FRPPhotoViewController.m
//  FRP
//
//  Created by Ash Furrow on 10/15/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "FRPPhotoViewController.h"

// Model
#import "FRPPhotoViewModel.h"

// Utilities
#import <SVProgressHUD.h>

@interface FRPPhotoViewController ()

// Private assignment
@property (nonatomic, assign) NSInteger photoIndex;
@property (nonatomic, strong) FRPPhotoViewModel *viewModel;

// Private properties
@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation FRPPhotoViewController

-(instancetype)initWithViewModel:(FRPPhotoViewModel *)viewModel index:(NSInteger)photoIndex
{
    self = [self init];
    if (!self) return nil;
    
    self.viewModel = viewModel;
    self.photoIndex = photoIndex;
    
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure self's view
    self.view.backgroundColor = [UIColor blackColor];
    
    // Configure subviews
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    RAC(imageView, image) = RACObserve(self.viewModel, photoImage);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    self.imageView = imageView;

    [RACObserve(self.viewModel, loading) subscribeNext:^(NSNumber *loading){
        if (loading.boolValue) {
            [SVProgressHUD show];
        } else {
            [SVProgressHUD dismiss];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.viewModel.active = YES;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.viewModel.active = NO;
}

@end
