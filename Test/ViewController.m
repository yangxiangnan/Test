//
//  ViewController.m
//  Test
//
//  Created by xiangnan.yang on 2018/1/5.
//  Copyright © 2018年 xiangnan.yang. All rights reserved.
//

#import "ViewController.h"
#import "TestRunloop.h"

@interface ViewController ()
@property (nonatomic, strong)TestRunloop *testRunloop;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.testRunloop = [TestRunloop new];
    [self.testRunloop start];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
