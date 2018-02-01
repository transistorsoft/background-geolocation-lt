//
//  ViewController.m
//  Demo
//
//  Created by Christopher Scott on 2018-03-02.
//  Copyright © 2018 Christopher Scott. All rights reserved.
//

#import "ViewController.h"
@import TSLocationManager;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    TSConfig *config = [TSConfig sharedInstance];
    [config updateWithBlock:^(TSConfigBuilder *builder) {
        builder.debug = YES;
        builder.logLevel = 5;
    }];
    TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
    //[bgGeo ready];
    [bgGeo start];
}

- (IBAction)onEnabledChange:(UISwitch*)sender {
    NSLog(@"- onEnabledChange");
    TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
    TSConfig *config = [TSConfig sharedInstance];
    if (sender.isOn) {
        [bgGeo start];
    } else {
        [bgGeo stop];
    }
    [_btnChangePace setEnabled:config.enabled];
}

- (IBAction)onClickChangePace:(UIBarButtonItem*)sender {
    TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
    TSConfig *config = [TSConfig sharedInstance];
    if (!config.enabled) { return; }
    [bgGeo changePace:!config.isMoving];
    [sender setTitle:(config.isMoving) ? @"||" : @">"];
}

- (IBAction)onClickGetCurrentPosition:(UIBarButtonItem*)sender {
    TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
    
    TSCurrentPositionRequest *request = [[TSCurrentPositionRequest alloc] initWithSuccess:^(TSLocation *location) {
        NSLog(@"- getCurrentPosition success");
    } failure:^(NSError *error) {
        NSLog(@"- getCurrentPosition failure");
    }];
    request.persist = NO;
    request.samples = 1;
    [bgGeo getCurrentPosition:request];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
