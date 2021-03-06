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
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

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
    _completedAttributes = 0;
    currentTaster = 0;
    
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
    int writeSize = 21;
    if (IPAD) {
        writeSize = 40;
    }
    wineWheelButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:writeSize];
    [wineWheelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [wineWheelButton setBackgroundImage:[UIImage imageNamed:@"wineWheelHenk.png"] forState:UIControlStateNormal];
    wineWheelButton.frame = wheelStartFrame;
    [self.view addSubview:wineWheelButton];
    
    // wine wheel
    wheelEndFrame = CGRectMake(-SCREENWIDTH/4, SCREENHEIGHT-(SCREENWIDTH*1.5)*(0.4), SCREENWIDTH*1.5, SCREENWIDTH*1.5);
    
    wineWheelImage = [[UIImageView alloc]initWithFrame:wheelStartFrame];
    wineWheelImage.image = [UIImage imageNamed:@"wineWheelHenk.png"];
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
    if (IPAD) {
        attributeHeight = 300;
    } else {
        attributeHeight = 50;
    }
    
    // colour
    NSArray *names0 = [[NSArray alloc]initWithObjects:@"Unappealing",@"Non-descript", @"Appealing", nil];
    NSArray *dis0 = [[NSArray alloc]initWithObjects:
    @"discription of the left button... this will give the user a bit more info on what it means ",
    @"discription of the middle button... this will give the user a bit more info on what it means ",
    @"discription of the right button... this will give the user a bit more info on what it means ",
    nil];
    selector0 = [[AttributeSelector alloc]initWithFrame:CGRectMake(0, 100, SCREENWIDTH, attributeHeight) andButtonNames:names0 andDiscriptions:dis0 andRefViewCon: self];
    [self.view addSubview:selector0];
    
    // aroma
    NSArray *names1 = [[NSArray alloc]initWithObjects:@"Off-puting",@"Closed", @"Inviting", nil];
    NSArray *dis1 = [[NSArray alloc]initWithObjects:
                    @"discription of the left button... this will give the user a bit more info on what it means ",
                    @"discription of the middle button... this will give the user a bit more info on what it means ",
                    @"discription of the right button... this will give the user a bit more info on what it means ",
                    nil];
    selector1 = [[AttributeSelector alloc]initWithFrame:CGRectMake(SCREENWIDTH, 100, SCREENWIDTH, attributeHeight) andButtonNames:names1 andDiscriptions:dis1 andRefViewCon: self];
    [self.view addSubview:selector1];
    
    // flavour
    NSArray *names2 = [[NSArray alloc]initWithObjects:@"Off-putting",@"Closed", @"Inviting", nil];
    NSArray *dis2 = [[NSArray alloc]initWithObjects:
                     @"discription of the left button... this will give the user a bit more info on what it means ",
                     @"discription of the middle button... this will give the user a bit more info on what it means ",
                     @"discription of the right button... this will give the user a bit more info on what it means ",
                     nil];
    selector2 = [[AttributeSelector alloc]initWithFrame:CGRectMake(SCREENWIDTH, 100, SCREENWIDTH, attributeHeight) andButtonNames:names2 andDiscriptions:dis2 andRefViewCon: self];
    [self.view addSubview:selector2];
    
    // complexity
    NSArray *names3 = [[NSArray alloc]initWithObjects:@"One-dimentional",@"Interesting", @"Multi-layered", nil];
    NSArray *dis3 = [[NSArray alloc]initWithObjects:
                     @"discription of the left button... this will give the user a bit more info on what it means ",
                     @"discription of the middle button... this will give the user a bit more info on what it means ",
                     @"discription of the right button... this will give the user a bit more info on what it means ",
                     nil];
    selector3 = [[AttributeSelector alloc]initWithFrame:CGRectMake(SCREENWIDTH, 100, SCREENWIDTH, attributeHeight) andButtonNames:names3 andDiscriptions:dis3 andRefViewCon: self];
    [self.view addSubview:selector3];
    
    // balance
    NSArray *names4 = [[NSArray alloc]initWithObjects:@"Imbalanced",@"Slightly out of balance", @"Well-balanced", nil];
    NSArray *dis4 = [[NSArray alloc]initWithObjects:
                     @"discription of the left button... this will give the user a bit more info on what it means ",
                     @"discription of the middle button... this will give the user a bit more info on what it means ",
                     @"discription of the right button... this will give the user a bit more info on what it means ",
                     nil];
    selector4 = [[AttributeSelector alloc]initWithFrame:CGRectMake(SCREENWIDTH, 100, SCREENWIDTH, attributeHeight) andButtonNames:names4 andDiscriptions:dis4 andRefViewCon: self];
    [self.view addSubview:selector4];
    
    // texuture
    NSArray *names5 = [[NSArray alloc]initWithObjects:@"Unappealing",@"Non-descript", @"Well-balanced", nil];
    NSArray *dis5 = [[NSArray alloc]initWithObjects:
                     @"discription of the left button... this will give the user a bit more info on what it means ",
                     @"discription of the middle button... this will give the user a bit more info on what it means ",
                     @"discription of the right button... this will give the user a bit more info on what it means ",
                     nil];
    selector5 = [[AttributeSelector alloc]initWithFrame:CGRectMake(SCREENWIDTH, 100, SCREENWIDTH, attributeHeight) andButtonNames:names5 andDiscriptions:dis5 andRefViewCon: self];
    [self.view addSubview:selector5];
    
    // finish
    NSArray *names6 = [[NSArray alloc]initWithObjects:@"Unattractive",@"Non-descript", @"Attractive", nil];
    NSArray *dis6 = [[NSArray alloc]initWithObjects:
                     @"discription of the left button... this will give the user a bit more info on what it means ",
                     @"discription of the middle button... this will give the user a bit more info on what it means ",
                     @"discription of the right button... this will give the user a bit more info on what it means ",
                     nil];
    selector6 = [[AttributeSelector alloc]initWithFrame:CGRectMake(SCREENWIDTH, 100, SCREENWIDTH, attributeHeight) andButtonNames:names6 andDiscriptions:dis6 andRefViewCon: self];
    [self.view addSubview:selector6];
    
    attributeSelectorArray = [[NSArray alloc]initWithObjects:selector0, selector1, selector2, selector3, selector4, selector5, selector6, nil];
    [self hideAllAttributes:NO];
    
    scoreButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 - 140/2, 30, 140, 50)];
    scoreButton.backgroundColor = [UIColor colorWithRed:0.5 green:1 blue:0.5 alpha:1];
    [scoreButton setTitle:@"Check score" forState:UIControlStateNormal];
    [scoreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [scoreButton addTarget:self action:@selector(openScore) forControlEvents:UIControlEventTouchUpInside];
    scoreButton.hidden = YES;
    [self.view addSubview:scoreButton];
    
    currentScore = 0;
    
    // profile pictures
    
    averageButton = [[UIButton alloc]initWithFrame:CGRectMake( SCREENWIDTH/10, wheelDiameter/2 + 30, SCREENWIDTH/5, SCREENWIDTH/5)];
    [averageButton setBackgroundImage:[UIImage imageNamed:@"averageSelected.png"] forState:UIControlStateNormal];
    [averageButton addTarget:self action:@selector(averagePressed) forControlEvents:UIControlEventTouchUpInside];
    [infoScrollView addSubview:averageButton];
    
    rickyButton = [[UIButton alloc]initWithFrame:CGRectMake(averageButton.frame.origin.x + averageButton.frame.size.width + SCREENWIDTH/10, wheelDiameter/2 + 30, SCREENWIDTH/5, SCREENWIDTH/5)];
    [rickyButton setBackgroundImage:[UIImage imageNamed:@"ricky.png"] forState:UIControlStateNormal];
    [rickyButton addTarget:self action:@selector(rickyPressed) forControlEvents:UIControlEventTouchUpInside];
    [infoScrollView addSubview:rickyButton];
    
    alisterButton = [[UIButton alloc]initWithFrame:CGRectMake(rickyButton.frame.origin.x + rickyButton.frame.size.width + SCREENWIDTH/10, wheelDiameter/2 + 30, SCREENWIDTH/5, SCREENWIDTH/5)];
    [alisterButton setBackgroundImage:[UIImage imageNamed:@"alister.png"] forState:UIControlStateNormal];
    [alisterButton addTarget:self action:@selector(alisterPressed) forControlEvents:UIControlEventTouchUpInside];
    [infoScrollView addSubview:alisterButton];
    
    henkButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH/10, averageButton.frame.origin.y + averageButton.frame.size.height + SCREENHEIGHT/17, SCREENWIDTH/5, SCREENWIDTH/5)];
    [henkButton setBackgroundImage:[UIImage imageNamed:@"henk.png"] forState:UIControlStateNormal];
    [henkButton addTarget:self action:@selector(henkPressed) forControlEvents:UIControlEventTouchUpInside];
    [infoScrollView addSubview:henkButton];
    
    jdButton = [[UIButton alloc]initWithFrame:CGRectMake(rickyButton.frame.origin.x, averageButton.frame.origin.y + averageButton.frame.size.height + SCREENHEIGHT/17, SCREENWIDTH/5, SCREENWIDTH/5)];
    [jdButton setBackgroundImage:[UIImage imageNamed:@"jdSelected.png"] forState:UIControlStateNormal];
    [jdButton addTarget:self action:@selector(jdPressed) forControlEvents:UIControlEventTouchUpInside];
    [infoScrollView addSubview:jdButton];

    
    // ======== demonstration code ========
//    for (int i = wheelDiameter/2; i < 800; i += 80 ) {
//        UILabel *thing = [[UILabel alloc]initWithFrame:CGRectMake(50, i, SCREENWIDTH-100, 20)];
//        thing.text = @"Place holder. cultivar or something";
//        thing.font = [UIFont systemFontOfSize:18];
//        thing.textColor = [UIColor blackColor];
//        [infoScrollView addSubview:thing];
//    }
    
}

- (void) tastingPressed {
    // hiding wheel button and show wheel image
    isScoringWine = YES;
    wineWheelButton.hidden = YES;
    wineWheelImage.hidden = NO;
    wineWheelImage.frame = wineWheelButton.frame;
    [self hideAllAttributes:YES];
    
    if ([self areAllAttributesFilledIn]) {
        scoreButton.hidden = NO;
        scoreButton.alpha = 0;
    } else {
        scoreButton.hidden = YES;
    }
    
    
    // animation
    [UIView animateWithDuration:0.4 animations:^{
        wineWheelImage.frame= wheelEndFrame;
        backButton.frame= CGRectMake(-50, backButton.frame.origin.y, backButton.frame.size.width, backButton.frame.size.height);
        downButton.frame = CGRectMake(SCREENWIDTH/2-25, SCREENHEIGHT-60, 50, 50);
        infoScrollView.frame = CGRectMake(0, SCREENHEIGHT, scrollViewFrame.size.width, scrollViewFrame.size.height);
        ((AttributeSelector *)attributeSelectorArray[0]).frame = CGRectMake(0, 100, SCREENWIDTH, attributeHeight);
        scoreButton.alpha = 1;
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
    scoreButton.hidden = YES;
    
    [wineWheelButton setTitle:@"Start" forState:UIControlStateNormal];
    int writeSize = 21;
    if (IPAD) {
        writeSize = 40;
    }
    wineWheelButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:writeSize];
    [wineWheelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
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
            att.frame = CGRectMake(0, -400, SCREENWIDTH, attributeHeight);
        }
    }];
}

- (void) checkAttributesFufilment {
    scoreButton.hidden = ![self areAllAttributesFilledIn];    // comment a ! infront to bring out of testing mode
}

- (BOOL) areAllAttributesFilledIn {
    BOOL readyToScore = true;
    for (AttributeSelector *slide in attributeSelectorArray) {
        if (slide.currentlySelectedButton == 0) {
            readyToScore = false;
        }
    }
    return readyToScore;
}

- (void) openScore {
    [self returnToTasteInfo];
    [self calculateScore];
}

- (void) calculateScore {
    // calculating score
    currentScore = 0;
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"UserProperties" ofType:@"plist"];
    NSArray *users = [NSArray arrayWithContentsOfFile:plistPath];
    
    for (int i = 0; i < [attributeSelectorArray count]; i++) {
        int selectedAttribute = [attributeSelectorArray[i] currentlySelectedButton];
        currentScore += [users[currentTaster][i][0] floatValue] * [users[currentTaster][i][selectedAttribute] floatValue];
    }
    
    
    NSLog(@"checking score");
    [wineWheelButton setTitle:[NSString stringWithFormat:@"%.f", round(currentScore) ] forState:UIControlStateNormal];
    
    int writeSize = 40;
    if (IPAD) {
        writeSize = 70;
    }
    wineWheelButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:writeSize];
    
    float red = 255.0;
    float green = 255.0;
    if (currentScore >= 50) {
        red = ((currentScore - 50)/50.0) * 255.0;
        red = 255.0 - red;
    } else {
        green = ((currentScore)/50.0) * 255.0;
    }
    [wineWheelButton setTitleColor:[UIColor colorWithRed:red/255.0 green:green/255.0 blue:0 alpha:1] forState:UIControlStateNormal];
    NSLog(@"red: %f    green: %f", red, green);
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
        ((AttributeSelector *)attributeSelectorArray[currentSegment]).frame = CGRectMake(SCREENWIDTH+20, 100, SCREENWIDTH, attributeHeight);
        ((AttributeSelector *)attributeSelectorArray[lastSegment]).frame = CGRectMake(0, 100, SCREENWIDTH, attributeHeight);
        
        
        [UIView animateWithDuration:0.5 animations:^{
            wineWheelImage.transform = CGAffineTransformRotate(wineWheelImage.transform, DEGREES_TO_RADIANS(-51.4285));
            ((AttributeSelector *)attributeSelectorArray[lastSegment]).frame = CGRectMake(-SCREENWIDTH-20, 100, SCREENWIDTH, attributeHeight);
            ((AttributeSelector *)attributeSelectorArray[currentSegment]).frame = CGRectMake(0, 100, SCREENWIDTH, attributeHeight);
            
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
        ((AttributeSelector *)attributeSelectorArray[currentSegment]).frame = CGRectMake(-SCREENWIDTH-20, 100, SCREENWIDTH, attributeHeight);
        ((AttributeSelector *)attributeSelectorArray[lastSegment]).frame = CGRectMake(0, 100, SCREENWIDTH, attributeHeight);
        
        [UIView animateWithDuration:0.4 animations:^{
            wineWheelImage.transform = CGAffineTransformRotate(wineWheelImage.transform, DEGREES_TO_RADIANS(51.4285));
            ((AttributeSelector *)attributeSelectorArray[lastSegment]).frame = CGRectMake(SCREENWIDTH+20, 100, SCREENWIDTH, attributeHeight);
            ((AttributeSelector *)attributeSelectorArray[currentSegment]).frame = CGRectMake(0, 100, SCREENWIDTH, attributeHeight);
        }];
    }
}

- (UIImageView*) makeCircularImage: (UIImageView*) imageView {
    UIImage *image = imageView.image;
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, [UIScreen mainScreen].scale);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:10.0] addClip];
    // Draw your image
    [image drawInRect:imageView.bounds];
    
    // Get the image, here setting the UIImageView image
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return imageView;
}


// just give profile buttons a tag and call one method
- (void) henkPressed {
    currentTaster = 1;
    [self deselectProfiles];
    [henkButton setBackgroundImage:[UIImage imageNamed:@"henkSelected.png"] forState:UIControlStateNormal];
}

- (void) rickyPressed {
    currentTaster = 2;
    [self deselectProfiles];
    [rickyButton setBackgroundImage:[UIImage imageNamed:@"rickySelected.png"] forState:UIControlStateNormal];
}

- (void) alisterPressed {
    currentTaster = 3;
    [self deselectProfiles];
    [alisterButton setBackgroundImage:[UIImage imageNamed:@"alisterSelected.png"] forState:UIControlStateNormal];
}

- (void) averagePressed {
    currentTaster = 0;
    [self deselectProfiles];
    [averageButton setBackgroundImage:[UIImage imageNamed:@"averageSelected.png"] forState:UIControlStateNormal];
}

- (void) jdPressed {
    currentTaster = 4;
    [self deselectProfiles];
    [jdButton setBackgroundImage:[UIImage imageNamed:@"jd.png"] forState:UIControlStateNormal];
}

- (void) deselectProfiles {
    if ([self areAllAttributesFilledIn]) {
        [self calculateScore];
    }
    [henkButton setBackgroundImage:[UIImage imageNamed:@"henk.png"] forState:UIControlStateNormal];
    [rickyButton setBackgroundImage:[UIImage imageNamed:@"ricky.png"] forState:UIControlStateNormal];
    [alisterButton setBackgroundImage:[UIImage imageNamed:@"alister.png"] forState:UIControlStateNormal];
    [averageButton setBackgroundImage:[UIImage imageNamed:@"average.png"] forState:UIControlStateNormal];
    [jdButton setBackgroundImage:[UIImage imageNamed:@"jdSelected.png"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
