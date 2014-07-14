//
//  TasteViewController.h
//  wineWheel
//
//  Created by Jan-Dawid Roodt on 5/07/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttributeSelector.h"

@interface TasteViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate> {
    float wheelDegree;
    int currentSegment;
    NSArray *attributeSelectorArray;
    
    UIButton *wineWheelButton;
    UIImageView *wineWheelImage;
    UIButton *backButton;
    UIButton *downButton;
    UIScrollView *infoScrollView;
    BOOL isScoringWine;
    
    CGRect wheelStartFrame;
    CGRect wheelEndFrame;
    CGRect scrollViewFrame;
    
    float wheelDiameter;
}

- (IBAction)swipeDetected:(UIGestureRecognizer *)sender;

@end
