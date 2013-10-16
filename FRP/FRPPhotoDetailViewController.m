//
//  FRPPhotoDetailViewController.m
//  FRP
//
//  Created by Ash Furrow on 10/15/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "FRPPhotoDetailViewController.h"

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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
    self.navigationItem.leftBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
        return [RACSignal empty];
    }];
    
    // Configure self's view
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
