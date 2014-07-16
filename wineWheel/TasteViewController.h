//
//  TasteViewController.h
//  wineWheel
//
//  Created by Jan-Dawid Roodt on 5/07/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AttributeSelector;

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
    
    AttributeSelector *selector0, *selector1, *selector2, *selector3, *selector4, *selector5, *selector6;
    UIButton *scoreButton;
    int currentScore;
}

@property int completedAttributes;

- (void) checkAttributesFufilment;

@end
