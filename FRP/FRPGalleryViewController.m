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

@interface FRPGalleryViewController () <FRPFullSizePhotoViewControllerDelegate, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *photosArray;
@property (nonatomic, strong) id collectionViewDelegate;

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
    
    RACSignal *photoSignal = [FRPPhotoImporter importPhotos];
    RACSignal *photosLoaded = [photoSignal catch:^RACSignal *(NSError *error) {
        NSLog(@"Couldn't fetch photos from 500px: %@", error);
        return [RACSignal empty];
    }];
    RAC(self, photosArray) = photosLoaded;
    [photosLoaded subscribeCompleted:^{
        @strongify(self)
        [self.collectionView reloadData];
    }];
    
    [[self rac_signalForSelector:@selector(userDidScroll:toPhotoAtIndex:) fromProtocol:@protocol(FRPFullSizePhotoViewControllerDelegate)] subscribeNext:^(RACTuple *value) {
        @strongify(self);
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[value.second  integerValue] inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    }];
    
    [[self rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:) fromProtocol:@protocol(UICollectionViewDelegate)] subscribeNext:^(RACTuple *arguments) {
        @strongify(self);
        FRPFullSizePhotoViewController *viewController = [[FRPFullSizePhotoViewController alloc] initWithPhotoModels:self.photosArray currentPhotoIndex:[(NSIndexPath *)arguments.second item]];
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController animated:YES];
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
