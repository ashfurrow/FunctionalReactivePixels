//
//  FRPGalleryViewController.m
//  FRP
//
//  Created by Ash Furrow on 10/13/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

// View Controllers
#import "FRPGalleryViewController.h"
#import "FRPFullSizePhotoViewController.h"

// Views
#import "FRPCell.h"

// Utilities
#import "FRPGalleryFlowLayout.h"
#import "FRPPhotoImporter.h"
#import <ReactiveCocoa/RACDelegateProxy.h>

static NSString *CellIdentifier = @"Cell";

@interface FRPGalleryViewController ()

@property (nonatomic, strong) NSArray *photosArray;

@end

@implementation FRPGalleryViewController

- (id)init
{
    FRPGalleryFlowLayout *flowLayout = [[FRPGalleryFlowLayout alloc] init];
    
    self = [self initWithCollectionViewLayout:flowLayout];
    if (!self) return nil;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure self
    self.title = @"Popular on 500px";
    
    // Configure view
    [self.collectionView registerClass:[FRPCell class] forCellWithReuseIdentifier:CellIdentifier];
    
    // Reactive Stuff
    @weakify(self);
    [RACObserve(self, photosArray) subscribeNext:^(id x) {
        @strongify(self);
        
        [self.collectionView reloadData];
    }];
    
    RACDelegateProxy *viewControllerDelegate = [[RACDelegateProxy alloc] initWithProtocol:@protocol(FRPFullSizePhotoViewControllerDelegate)];
    
    [[viewControllerDelegate rac_signalForSelector:@selector(userDidScroll:toPhotoAtIndex:) fromProtocol:@protocol(FRPFullSizePhotoViewControllerDelegate)] subscribeNext:^(RACTuple *value) {
        @strongify(self);
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[value.second  integerValue] inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    }];
    
    RACDelegateProxy *collectionViewDelegate = [[RACDelegateProxy alloc] initWithProtocol:@protocol(UICollectionViewDelegate)];
    [[collectionViewDelegate rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:)] subscribeNext:^(RACTuple *arguments) {
        @strongify(self);
        FRPFullSizePhotoViewController *viewController = [[FRPFullSizePhotoViewController alloc] initWithPhotoModels:self.photosArray currentPhotoIndex:[(NSIndexPath *)arguments.second item]];
        viewController.delegate = (id<FRPFullSizePhotoViewControllerDelegate>)viewControllerDelegate;
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    self.collectionView.delegate = (id<UICollectionViewDelegate>)collectionViewDelegate;
    
    // Load data
    [self loadPopularPhotos];
}

#pragma mark - Private Methods

-(void)loadPopularPhotos {
    [[FRPPhotoImporter importPhotos] subscribeNext:^(id x) {
        self.photosArray = x;
    } error:^(NSError *error) {
        NSLog(@"Couldn't fetch photos from 500px: %@", error);
    }];
}

#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FRPCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell setPhotoModel:self.photosArray[indexPath.row]];
    
    return cell;
}


@end
