//
//  wineWheel.m
//  wineWheel
//
//  Created by Jan-Dawid Roodt on 12/07/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import "wineWheel.h"

@implementation wineWheel

@synthesize wineWheelImage, wineWheelButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        wineWheelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        //[wineWheelButton addTarget:self action:@selector(tastingPressed) forControlEvents:UIControlEventTouchUpInside];
//        [wineWheelButton setTitle:@"Start" forState:UIControlStateNormal];
//        wineWheelButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
//        [wineWheelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [wineWheelButton setBackgroundImage:[UIImage imageNamed:@"wineWheelFull.png"] forState:UIControlStateNormal];
//        wineWheelButton.frame = frame;
//        
//        // wine wheel
//        wheelEndFrame = CGRectMake(-SCREENWIDTH/4, SCREENHEIGHT-(SCREENWIDTH*1.5)*(0.4), SCREENWIDTH*1.5, SCREENWIDTH*1.5);
//        
//        wineWheelImage = [[UIImageView alloc]initWithFrame:wheelStartFrame];
//        wineWheelImage.image = [UIImage imageNamed:@"wineWheelFull.png"];
//        [self.view addSubview:wineWheelImage];
//        wineWheelImage.hidden = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
