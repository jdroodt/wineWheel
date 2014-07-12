//
//  TasteViewController.m
//  wineWheel
//
//  Created by Jan-Dawid Roodt on 5/07/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import "TasteViewController.h"

#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREENWIDTH ([[UIScreen mainScreen] bounds].size.width)
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface TasteViewController ()

@end

@implementation TasteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupPage];
}

- (void)viewWillDisappear:(BOOL)animated {
    wineWheelImage.alpha = 1;
    [UIView animateWithDuration:0.1 animations:^{
        wineWheelImage.alpha = 0;
    }];
    backButton.hidden = YES;
}

- (void) setupPage {
    self.view.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1];
    
    // scroll view
    scrollViewFrame = CGRectMake(0,(SCREENWIDTH-SCREENWIDTH/5)/2 + 50, SCREENWIDTH, SCREENHEIGHT-(SCREENWIDTH-SCREENWIDTH/5)/2 -50);
    infoScrollView = [[UIScrollView alloc]initWithFrame: scrollViewFrame];
    infoScrollView.delegate = self;
    infoScrollView.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1];
    infoScrollView.contentSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT*1.6);
    [infoScrollView setContentOffset:CGPointMake(0, 0)];
    [self.view addSubview:infoScrollView];
    
    // back button
    backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10, 25, 40, 40);
    [self.view addSubview:backButton];
    
    // down button
    downButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [downButton addTarget:self action:@selector(returnToTasteInfo) forControlEvents:UIControlEventTouchUpInside];
    [downButton setTitle:@"" forState:UIControlStateNormal];
    [downButton setBackgroundImage:[UIImage imageNamed:@"downButton.png"] forState:UIControlStateNormal];
    downButton.frame = CGRectMake(SCREENWIDTH/2-25, SCREENHEIGHT, 50, 50);
    [self.view addSubview:downButton];
    
    // start tasting button
    wheelStartFrame = CGRectMake(SCREENWIDTH/10, 50, SCREENWIDTH-SCREENWIDTH/5, SCREENWIDTH-SCREENWIDTH/5);
    wheelDiameter = wheelStartFrame.size.width;
    
    wineWheelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [wineWheelButton addTarget:self action:@selector(tastingPressed) forControlEvents:UIControlEventTouchUpInside];
    [wineWheelButton setTitle:@"Start" forState:UIControlStateNormal];
    wineWheelButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
    [wineWheelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [wineWheelButton setBackgroundImage:[UIImage imageNamed:@"wineWheelFull.png"] forState:UIControlStateNormal];
    wineWheelButton.frame = wheelStartFrame;
    [self.view addSubview:wineWheelButton];
    
    // wine wheel
    wheelEndFrame = CGRectMake(-SCREENWIDTH/4, SCREENHEIGHT-(SCREENWIDTH*1.5)*(0.4), SCREENWIDTH*1.5, SCREENWIDTH*1.5);
    
    wineWheelImage = [[UIImageView alloc]initWithFrame:wheelStartFrame];
    wineWheelImage.image = [UIImage imageNamed:@"wineWheelFull.png"];
    [self.view addSubview:wineWheelImage];
    wineWheelImage.hidden = YES;
    
    
    [self.view bringSubviewToFront:downButton];
    [self.view bringSubviewToFront:backButton];
    
    
    // ======== demonstration code ========
    for (int i = wheelDiameter/2; i < 800; i += 80 ) {
        UILabel *thing = [[UILabel alloc]initWithFrame:CGRectMake(50, i, 320-100, 20)];
        thing.text = @"Place holder. cultivar or something";
        thing.font = [UIFont systemFontOfSize:18];
        thing.textColor = [UIColor blackColor];
        [infoScrollView addSubview:thing];
    }
    
    // TESTING CODE LATE AT NIGHT
    //wineWheelImage.center = CGPointMake(wheelDiameter/2, wheelDiameter/2);
    
//    wineWheelButton.contentMode = UIViewContentModeCenter;
//    wineWheelImage.contentMode = UIViewContentModeCenter;
//    wineWheelImage.autoresizingMask = UIViewAutoresizingNone;
//    wineWheelButton.autoresizingMask = UIViewAutoresizingNone;
//    
//    wineWheelButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
//    wineWheelImage.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
}

- (void) tastingPressed {
    // hiding wheel button and show wheel image
    wineWheelButton.hidden = YES;
    wineWheelImage.hidden = NO;
    wineWheelImage.frame = wineWheelButton.frame;
    
    // animation
    [UIView animateWithDuration:0.4 animations:^{
        wineWheelImage.frame= wheelEndFrame;
        backButton.frame= CGRectMake(-50, backButton.frame.origin.y, backButton.frame.size.width, backButton.frame.size.height);
        downButton.frame = CGRectMake(SCREENWIDTH/2-25, SCREENHEIGHT-60, 50, 50);
        infoScrollView.frame = CGRectMake(0, SCREENHEIGHT, scrollViewFrame.size.width, scrollViewFrame.size.height);
    }];
    
    [infoScrollView setContentOffset:CGPointZero animated:NO];
}

- (void) returnToTasteInfo {
    // show wheel button and hide wheel image
    wineWheelButton.hidden = NO;
    wineWheelButton.frame = wheelEndFrame;
    wineWheelImage.hidden = YES;
    wineWheelImage.frame = wheelStartFrame;
    
    // animation
    [UIView animateWithDuration:0.4 animations:^{
        wineWheelButton.frame= wheelStartFrame;
        backButton.frame= CGRectMake(10, backButton.frame.origin.y, backButton.frame.size.width, backButton.frame.size.height);
        downButton.frame = CGRectMake(SCREENWIDTH/2-25, SCREENHEIGHT, 50, 50);
        infoScrollView.frame = scrollViewFrame;
    }];
    
    [infoScrollView setContentOffset:CGPointZero animated:NO];
}

- (void) backPressed {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    // no idea why -20 offset at top?!?!? but account for it. MAY BE DIFFERENT ON OTHER DEVICES
    if (scrollView.contentOffset.y  < wheelDiameter/2) {
        float moveSpace = -scrollView.contentOffset.y + wheelStartFrame.origin.y - 20;
        wineWheelButton.frame = CGRectMake(wineWheelButton.frame.origin.x, moveSpace, wheelDiameter, wheelDiameter);
    }
    NSLog(@"%f", scrollView.contentOffset.y);
}

//- (void) scrollViewDidScrollToTop:(UIScrollView *)scrollView {
//    
//}



@end
