//
//  FRPGalleryViewController.m
//  FRP
//
//  Created by Ash Furrow on 10/13/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "FRPGalleryViewController.h"
#import "FRPCell.h"

static NSString *CellIdentifier = @"Cell";

@interface FRPGalleryViewController ()

@property (nonatomic, strong) NSArray *photosArray;

@end

@implementation FRPGalleryViewController

- (id)init
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    self = [super initWithCollectionViewLayout:flowLayout];
    if (!self) return nil;
    
    flowLayout.itemSize = CGSizeMake(145, 145);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
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
    
    [self loadPopularPhotos];
}

#pragma mark - Private Methods

-(void)loadPopularPhotos {
    NSURLRequest *request = [AppDelegate.apiHelper urlRequestForPhotoFeature:PXAPIHelperPhotoFeaturePopular resultsPerPage:100 page:1 photoSizes:PXPhotoModelSizeThumbnail sortOrder:PXAPIHelperSortOrderRating except:PXPhotoModelCategoryNude];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            id results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            self.photosArray = results[@"photos"];
        }
        else {
            NSLog(@"Couldn't fetch from 500px: %@", connectionError);
        }
    }];
}

#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FRPCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor purpleColor];
    
    return cell;
}

@end
