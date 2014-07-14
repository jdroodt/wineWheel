//
//  TasteViewController.m
//  wineWheel
//
//  Created by Jan-Dawid Roodt on 5/07/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import "TasteViewController.h"
#import "AttributeSelector.h"

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
    isScoringWine = NO;
    currentSegment = 0;
    
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
    [wineWheelButton setBackgroundImage:[UIImage imageNamed:@"wineWheelStraight.png"] forState:UIControlStateNormal];
    wineWheelButton.frame = wheelStartFrame;
    [self.view addSubview:wineWheelButton];
    
    // wine wheel
    wheelEndFrame = CGRectMake(-SCREENWIDTH/4, SCREENHEIGHT-(SCREENWIDTH*1.5)*(0.4), SCREENWIDTH*1.5, SCREENWIDTH*1.5);
    
    wineWheelImage = [[UIImageView alloc]initWithFrame:wheelStartFrame];
    wineWheelImage.image = [UIImage imageNamed:@"wineWheelStraight.png"];
    [self.view addSubview:wineWheelImage];
    wineWheelImage.hidden = YES;
    
    wineWheelImage.autoresizingMask = UIViewAutoresizingNone;
    wineWheelButton.autoresizingMask = UIViewAutoresizingNone;

    [self.view bringSubviewToFront:downButton];
    [self.view bringSubviewToFront:backButton];
    
    // gestures for swiping
    UISwipeGestureRecognizer *leftRecognizer;
    leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromLeft)];
    [leftRecognizer setDirection: UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:leftRecognizer];
    
    UISwipeGestureRecognizer *rightRecognizer;
    rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromRight)];
    [rightRecognizer setDirection: UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:rightRecognizer];
    
    
    // attribute selectors
    // colour
    NSArray *names0 = [[NSArray alloc]initWithObjects:@"Unappealing",@"Non-descript", @"Appealing", nil];
    NSArray *dis0 = [[NSArray alloc]initWithObjects:
    @"discription of the left button... this will give the user a bit more info on what it means ",
    @"discription of the middle button... this will give the user a bit more info on what it means ",
    @"discription of the right button... this will give the user a bit more info on what it means ",
    nil];
    AttributeSelector *selector0 = [[AttributeSelector alloc]initWithFrame:CGRectMake(0, 100, 320, 50) andButtonNames:names0 andDiscriptions:dis0];
    [self.view addSubview:selector0];
    
    // aroma
    NSArray *names1 = [[NSArray alloc]initWithObjects:@"Off-puting",@"Closed", @"Inviting", nil];
    NSArray *dis1 = [[NSArray alloc]initWithObjects:
                    @"discription of the left button... this will give the user a bit more info on what it means ",
                    @"discription of the middle button... this will give the user a bit more info on what it means ",
                    @"discription of the right button... this will give the user a bit more info on what it means ",
                    nil];
    AttributeSelector *selector1 = [[AttributeSelector alloc]initWithFrame:CGRectMake(320, 100, 320, 50) andButtonNames:names1 andDiscriptions:dis1];
    [self.view addSubview:selector1];
    
    // flavour
    NSArray *names2 = [[NSArray alloc]initWithObjects:@"Off-putting",@"Closed", @"Inviting", nil];
    NSArray *dis2 = [[NSArray alloc]initWithObjects:
                     @"discription of the left button... this will give the user a bit more info on what it means ",
                     @"discription of the middle button... this will give the user a bit more info on what it means ",
                     @"discription of the right button... this will give the user a bit more info on what it means ",
                     nil];
    AttributeSelector *selector2 = [[AttributeSelector alloc]initWithFrame:CGRectMake(320, 100, 320, 50) andButtonNames:names2 andDiscriptions:dis2];
    [self.view addSubview:selector2];
    
    // complexity
    NSArray *names3 = [[NSArray alloc]initWithObjects:@"One-dimentional",@"Interesting", @"Multi-layered", nil];
    NSArray *dis3 = [[NSArray alloc]initWithObjects:
                     @"discription of the left button... this will give the user a bit more info on what it means ",
                     @"discription of the middle button... this will give the user a bit more info on what it means ",
                     @"discription of the right button... this will give the user a bit more info on what it means ",
                     nil];
    AttributeSelector *selector3 = [[AttributeSelector alloc]initWithFrame:CGRectMake(320, 100, 320, 50) andButtonNames:names3 andDiscriptions:dis3];
    [self.view addSubview:selector3];
    
    // balance
    NSArray *names4 = [[NSArray alloc]initWithObjects:@"Imbalanced",@"Slightly out of balance", @"Well-balanced", nil];
    NSArray *dis4 = [[NSArray alloc]initWithObjects:
                     @"discription of the left button... this will give the user a bit more info on what it means ",
                     @"discription of the middle button... this will give the user a bit more info on what it means ",
                     @"discription of the right button... this will give the user a bit more info on what it means ",
                     nil];
    AttributeSelector *selector4 = [[AttributeSelector alloc]initWithFrame:CGRectMake(320, 100, 320, 50) andButtonNames:names4 andDiscriptions:dis4];
    [self.view addSubview:selector4];
    
    // texuture
    NSArray *names5 = [[NSArray alloc]initWithObjects:@"Unappealing",@"Non-descript", @"Well-balanced", nil];
    NSArray *dis5 = [[NSArray alloc]initWithObjects:
                     @"discription of the left button... this will give the user a bit more info on what it means ",
                     @"discription of the middle button... this will give the user a bit more info on what it means ",
                     @"discription of the right button... this will give the user a bit more info on what it means ",
                     nil];
    AttributeSelector *selector5 = [[AttributeSelector alloc]initWithFrame:CGRectMake(320, 100, 320, 50) andButtonNames:names5 andDiscriptions:dis5];
    [self.view addSubview:selector5];
    
    // finish
    NSArray *names6 = [[NSArray alloc]initWithObjects:@"Unattractive",@"Non-descript", @"Attractive", nil];
    NSArray *dis6 = [[NSArray alloc]initWithObjects:
                     @"discription of the left button... this will give the user a bit more info on what it means ",
                     @"discription of the middle button... this will give the user a bit more info on what it means ",
                     @"discription of the right button... this will give the user a bit more info on what it means ",
                     nil];
    AttributeSelector *selector6 = [[AttributeSelector alloc]initWithFrame:CGRectMake(320, 100, 320, 50) andButtonNames:names6 andDiscriptions:dis6];
    [self.view addSubview:selector6];
    
    attributeSelectorArray = [[NSArray alloc]initWithObjects:selector0, selector1, selector2, selector3, selector4, selector5, selector6, nil];
    [self hideAllAttributes:NO];
    
    
    
    // ======== demonstration code ========
    for (int i = wheelDiameter/2; i < 800; i += 80 ) {
        UILabel *thing = [[UILabel alloc]initWithFrame:CGRectMake(50, i, 320-100, 20)];
        thing.text = @"Place holder. cultivar or something";
        thing.font = [UIFont systemFontOfSize:18];
        thing.textColor = [UIColor blackColor];
        [infoScrollView addSubview:thing];
    }
    
}

- (void) tastingPressed {
    // hiding wheel button and show wheel image
    isScoringWine = YES;
    wineWheelButton.hidden = YES;
    wineWheelImage.hidden = NO;
    wineWheelImage.frame = wineWheelButton.frame;
    [self hideAllAttributes:YES];
    //[((AttributeSelector *)attributeSelectorArray[0]) unselectedButton];
    
    
    // animation
    [UIView animateWithDuration:0.4 animations:^{
        wineWheelImage.frame= wheelEndFrame;
        backButton.frame= CGRectMake(-50, backButton.frame.origin.y, backButton.frame.size.width, backButton.frame.size.height);
        downButton.frame = CGRectMake(SCREENWIDTH/2-25, SCREENHEIGHT-60, 50, 50);
        infoScrollView.frame = CGRectMake(0, SCREENHEIGHT, scrollViewFrame.size.width, scrollViewFrame.size.height);
        ((AttributeSelector *)attributeSelectorArray[0]).frame = CGRectMake(0, 100, 320, 50);
    }];
    
    [infoScrollView setContentOffset:CGPointZero animated:NO];
    wheelDegree = 0;
}

- (void) returnToTasteInfo {
    // show wheel button and hide wheel image
    isScoringWine = NO;
    wineWheelButton.hidden = NO;
    wineWheelButton.frame = wheelEndFrame;
    wineWheelImage.hidden = YES;
    wineWheelImage.frame = wheelStartFrame;
    [self hideAllAttributes:YES];
    
    // animation
    [UIView animateWithDuration:0.4 animations:^{
        wineWheelButton.frame= wheelStartFrame;
        backButton.frame= CGRectMake(10, backButton.frame.origin.y, backButton.frame.size.width, backButton.frame.size.height);
        downButton.frame = CGRectMake(SCREENWIDTH/2-25, SCREENHEIGHT, 50, 50);
        infoScrollView.frame = scrollViewFrame;
        
    }];
    wineWheelImage.transform = CGAffineTransformRotate(wineWheelImage.transform, DEGREES_TO_RADIANS(-wheelDegree));
    [infoScrollView setContentOffset:CGPointZero animated:NO];
    
}

- (void) backPressed {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) hideAllAttributes: (bool) animation {
    currentSegment = 0;
    float animationTime = 0;
    if (animation) {
        animationTime = 0.4;
    }
    
    [UIView animateWithDuration:animationTime animations:^{
        for (AttributeSelector *att in attributeSelectorArray) {
            att.frame = CGRectMake(0, -200, 320, 50);
        }
    }];
}


// scroll delegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    // no idea why -20 offset at top?!?!? but account for it.
    if (scrollView.contentOffset.y  < wheelDiameter/2) {
        float moveSpace = -scrollView.contentOffset.y + wheelStartFrame.origin.y - 20;
        wineWheelButton.frame = CGRectMake(wineWheelButton.frame.origin.x, moveSpace, wheelDiameter, wheelDiameter);
    }
}


// gestures delegate
- (void) handleSwipeFromLeft {
    if (isScoringWine) {
         NSLog(@"left swipe detected");
        wheelDegree -= 51.4285;
       
        
        int lastSegment = currentSegment;
        currentSegment++;
        if (currentSegment > 6) {
            currentSegment = 0;
        }
        ((AttributeSelector *)attributeSelectorArray[currentSegment]).frame = CGRectMake(340, 100, 320, 50);
        ((AttributeSelector *)attributeSelectorArray[lastSegment]).frame = CGRectMake(0, 100, 320, 50);
        
        
        [UIView animateWithDuration:0.5 animations:^{
            wineWheelImage.transform = CGAffineTransformRotate(wineWheelImage.transform, DEGREES_TO_RADIANS(-51.4285));
            ((AttributeSelector *)attributeSelectorArray[lastSegment]).frame = CGRectMake(-340, 100, 320, 50);
            ((AttributeSelector *)attributeSelectorArray[currentSegment]).frame = CGRectMake(0, 100, 320, 50);
            
        }];
    }
}

- (void) handleSwipeFromRight {
    if (isScoringWine) {
        NSLog(@"right swipe detected");
        wheelDegree += 51.4285;
        
        int lastSegment = currentSegment;
        currentSegment--;
        if (currentSegment < 0) {
            currentSegment = 6;
        }
        ((AttributeSelector *)attributeSelectorArray[currentSegment]).frame = CGRectMake(-340, 100, 320, 50);
        ((AttributeSelector *)attributeSelectorArray[lastSegment]).frame = CGRectMake(0, 100, 320, 50);
        
        [UIView animateWithDuration:0.4 animations:^{
            wineWheelImage.transform = CGAffineTransformRotate(wineWheelImage.transform, DEGREES_TO_RADIANS(51.4285));
            ((AttributeSelector *)attributeSelectorArray[lastSegment]).frame = CGRectMake(340, 100, 320, 50);
            ((AttributeSelector *)attributeSelectorArray[currentSegment]).frame = CGRectMake(0, 100, 320, 50);
        }];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
