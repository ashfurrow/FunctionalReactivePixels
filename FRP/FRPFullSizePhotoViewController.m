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

// Models
#import "FRPPhotoModel.h"

@interface FRPFullSizePhotoViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

// Private assignment
@property (nonatomic, strong) NSArray *photoModelArray;

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
    
    // Configure self
    self.title = [self.photoModelArray[photoIndex] photoName];
    
    // View controllers
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey: @(30)}];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
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

#pragma mark - UIPageViewControllerDelegate Methods 

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    self.title = [[self.pageViewController.viewControllers.firstObject photoModel] photoName];
    [self.delegate userDidScroll:self toPhotoAtIndex:[self.pageViewController.viewControllers.firstObject photoIndex]];
}

#pragma mark - UIPageViewControllerDataSource Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(FRPPhotoViewController *)viewController {
    return [self photoViewControllerForIndex:viewController.photoIndex - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(FRPPhotoViewController *)viewController {
    return [self photoViewControllerForIndex:viewController.photoIndex + 1];
}

@end
