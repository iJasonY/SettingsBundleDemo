//
//  ViewController.m
//  SettingsBundleDemo
//
//  Created by James Tang on 22/10/14.
//  Copyright (c) 2014 James Tang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(weak, nonatomic) IBOutlet UILabel *swtichStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  BOOL switc = [[NSUserDefaults standardUserDefaults]
      boolForKey:@"innernetswitch_preference"];

  self.swtichStatusLabel.text = switc ? @"YES" : @"NO";

  [[NSNotificationCenter defaultCenter]
      addObserverForName:UIApplicationDidBecomeActiveNotification
                  object:nil
                   queue:nil
              usingBlock:^(NSNotification *_Nonnull note) {
                BOOL switc = [[NSUserDefaults standardUserDefaults]
                    boolForKey:@"innernetswitch_preference"];

                self.swtichStatusLabel.text = switc ? @"YES" : @"NO";
              }];
    
    [self setUptestLabel];
}

-(void)setUptestLabel{
    self.testLabel.text = @"Hello";
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
