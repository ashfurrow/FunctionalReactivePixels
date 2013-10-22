//
//  FRPLoginViewController.m
//  FRP
//
//  Created by Ash Furrow on 10/18/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "FRPLoginViewController.h"

// Utilities
#import "FRPPhotoImporter.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface FRPLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation FRPLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Configure self's view
//    self.view.backgroundColor = [UIColor blackColor];
    
    // Configure navigation item
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log In" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:nil];
    
    // Reactive Stuff
    @weakify(self);
    RACSignal *enabledSignal = [RACSignal combineLatest:@[self.usernameTextField.rac_textSignal, self.passwordTextField.rac_textSignal] reduce:^id(NSString *username, NSString *password){
        return @(username.length > 0 && password.length > 0);
    }];
    self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc] initWithEnabled:enabledSignal signalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [FRPPhotoImporter logInWithUsername:self.usernameTextField.text password:self.passwordTextField.text];
    }];
    [self.navigationItem.rightBarButtonItem.rac_command.executionSignals subscribeNext:^(id x) {
        [x subscribeCompleted:^{
            @strongify(self);
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }];
    }];
    [self.navigationItem.rightBarButtonItem.rac_command.errors subscribeNext:^(id x) {
        NSLog(@"Login error: %@", x);
    }];
    
    self.navigationItem.leftBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
