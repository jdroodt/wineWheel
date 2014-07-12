//
//  ViewController.m
//  wineDemo
//
//  Created by Jan-Dawid Roodt on 29/06/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import "MainMenuViewController.h"
#import "TasteViewController.h"

#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREENWIDTH ([[UIScreen mainScreen] bounds].size.width)


@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"main menu view did load");
    
    [self setupButtons];
    self.navigationController.navigationBarHidden = YES;
}

//- (void) viewWillAppear:(BOOL)animated {
//    self.navigationController.navigationBarHidden = TRUE;
//}

- (void) setupButtons {
    // background
    self.view.backgroundColor = [UIColor whiteColor];
    
    // alpha sign
    UILabel *betaLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-100, SCREENHEIGHT-20, 200, 20)];
    betaLabel.textColor = [UIColor redColor];
    [betaLabel setTextAlignment:NSTextAlignmentCenter];
    betaLabel.text = @"For testing purposes only";
    betaLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:betaLabel];
    
    // tasting button
    UIButton *tasteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [tasteButton addTarget:self action:@selector(tasteButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [tasteButton setTitle:@"Taste" forState:UIControlStateNormal];
    [tasteButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    tasteButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    tasteButton.frame = CGRectMake(SCREENWIDTH/2-SCREENWIDTH/6, SCREENHEIGHT/4, SCREENWIDTH/3, SCREENHEIGHT/10);
    [self.view addSubview:tasteButton];
    
    [[tasteButton layer] setBorderWidth:2.0f];
    [[tasteButton layer] setBorderColor:[UIColor darkGrayColor].CGColor];
    [[tasteButton layer] setMasksToBounds:YES];
    [[tasteButton layer] setCornerRadius:7.0];
    
    
    // cellar button
    UIButton *cellarButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cellarButton addTarget:self action:@selector(cellarButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [cellarButton setTitle:@"Cellar" forState:UIControlStateNormal];
    cellarButton.frame = CGRectMake(50, self.view.frame.size.height-25-140, 220, 140);
    [cellarButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    cellarButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    cellarButton.frame = CGRectMake(SCREENWIDTH/2-SCREENWIDTH/6, SCREENHEIGHT/8*5, SCREENWIDTH/3, SCREENHEIGHT/10);
    [self.view addSubview:cellarButton];
    
    
    [[cellarButton layer] setBorderWidth:2.0f];
    [[cellarButton layer] setBorderColor:[UIColor darkGrayColor].CGColor];
    [[cellarButton layer] setMasksToBounds:YES];
    [[cellarButton layer] setCornerRadius:7.0];
}


- (void) tasteButtonPressed {
    NSLog(@"taste pressed");
    
    TasteViewController *nextScreen = [[TasteViewController alloc]init];
    [self.navigationController pushViewController:nextScreen animated:YES];
}

- (void) cellarButtonPressed {
    UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"Coming Soon" message:@"Stone to Stars iOS dev team are still constructing the virtual cellar, sorry" delegate:nil cancelButtonTitle:@"Sweet as" otherButtonTitles:nil];
    [alert1 show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
