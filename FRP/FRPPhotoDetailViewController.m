//
//  FRPPhotoDetailViewController.m
//  FRP
//
//  Created by Ash Furrow on 10/15/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

// View Controllers
#import "FRPPhotoDetailViewController.h"
#import "FRPLoginViewController.h"

// Model
#import "FRPPhotoModel.h"

@interface FRPPhotoDetailViewController ()

// Private assignment
@property (nonatomic, strong) FRPPhotoModel *photoModel;

@end

@implementation FRPPhotoDetailViewController

-(instancetype)initWithPhotoModel:(FRPPhotoModel *)photoModel
{
    self = [self init];
    if (!self) return nil;
    
    self.photoModel = photoModel;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    @weakify(self);
    
    // Configure self
    self.title = self.photoModel.photoName;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
    self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }];
    
    // Configure self's view
    self.view.backgroundColor = [UIColor blackColor];
    
    // Configure subviews
    UILabel *ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), 100)];
    RAC(ratingLabel, text) = [RACObserve(self.photoModel, rating) map:^id(id value) {
        return [NSString stringWithFormat:@"%0.2f", [value floatValue]];
    }];
    ratingLabel.font = [UIFont boldSystemFontOfSize:80];
    ratingLabel.textColor = [UIColor whiteColor];
    ratingLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:ratingLabel];
    
    UILabel *photoNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(ratingLabel.frame), CGRectGetWidth(self.view.bounds), 20)];
    RAC(photoNameLabel, text) = RACObserve(self.photoModel, photoName);
    photoNameLabel.font = [UIFont systemFontOfSize:16];
    photoNameLabel.textColor = [UIColor whiteColor];
    photoNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:photoNameLabel];
    
    UILabel *photographerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(photoNameLabel.frame), CGRectGetWidth(self.view.bounds), 20)];
    RAC(photographerNameLabel, text) = RACObserve(self.photoModel, photographerName);
    photographerNameLabel.font = [UIFont systemFontOfSize:16];
    photographerNameLabel.textColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
    photographerNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:photographerNameLabel];
    
    UIButton *voteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    voteButton.frame = CGRectMake(20, CGRectGetHeight(self.view.bounds) - 44 - 20, CGRectGetWidth(self.view.bounds) - 40, 44);
    voteButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [RACObserve(self.photoModel, isVotedFor) subscribeNext:^(id x) {
        if ([x boolValue]) {
            [voteButton setTitle:@"Voted For!" forState:UIControlStateNormal];
        } else {
            [voteButton setTitle:@"Vote" forState:UIControlStateNormal];
        }
    }];
    voteButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            if (AppDelegate.apiHelper.authMode == PXAPIHelperModeNoAuth) {
                // Not logged in
                
                @strongify(self);
                FRPLoginViewController *viewController = [[FRPLoginViewController alloc] initWithNibName:@"FRPLoginViewController" bundle:nil];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
                
                [self presentViewController:navigationController animated:YES completion:^{
                    [subscriber sendCompleted];
                }];
                
                return nil;
            } else {
                
                return nil;
            }
        }];
    }];
    [self.view addSubview:voteButton];
}
@end
