//
//  FRPFullSizePhotoViewController.m
//  FRP
//
//  Created by Ash Furrow on 10/15/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

// View Controllers
#import "FRPFullSizePhotoViewController.h"
#import "FRPPhotoViewController.h"

@interface FRPFullSizePhotoViewController () <UIPageViewControllerDataSource>

// Private assignment
@property (nonatomic, strong) NSArray *photoModelArray;
@property (nonatomic, assign) NSInteger photoIndex;

// Private properties
@property (nonatomic, strong) UIPageViewController *pageViewController;

@end

@implementation FRPFullSizePhotoViewController

-(instancetype)initWithPhotoModels:(NSArray *)photoModelArray currentPhotoIndex:(NSInteger)photoIndex
{
    self = [self init];
    if (!self) return nil;
    
    // Initialized, read-only properties
    self.photoModelArray = photoModelArray;
    self.photoIndex = photoIndex;
    
    // View controllers
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey: @(30)}];
    self.pageViewController.dataSource = self;
    [self addChildViewController:self.pageViewController];
    
    [self.pageViewController setViewControllers:@[[self photoViewControllerForIndex:photoIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure self's view
    self.view.backgroundColor = [UIColor blackColor];
    
    // Configure subviews
    self.pageViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.pageViewController.view];
}

#pragma mark - Private Methods

-(FRPPhotoViewController *)photoViewControllerForIndex:(NSInteger)index {
    if (index >= 0 && index < self.photoModelArray.count) {
        FRPPhotoModel *photoModel = self.photoModelArray[index];
        
        FRPPhotoViewController *photoViewController = [[FRPPhotoViewController alloc] initWithPhotoModel:photoModel index:index];
        return photoViewController;
    }
    
    // Index was out of bounds, return nil
    return nil;
}

#pragma mark - UIPageViewControllerDataSource Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(FRPPhotoViewController *)viewController {
    return [self photoViewControllerForIndex:viewController.photoIndex - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(FRPPhotoViewController *)viewController {
    return [self photoViewControllerForIndex:viewController.photoIndex + 1];
}

@end
