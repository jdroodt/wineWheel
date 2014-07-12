//
//  TasteViewController.h
//  wineWheel
//
//  Created by Jan-Dawid Roodt on 5/07/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TasteViewController : UIViewController <UIScrollViewDelegate> {
    UIButton *wineWheelButton;
    UIImageView *wineWheelImage;
    UIButton *backButton;
    UIButton *downButton;
    UIScrollView *infoScrollView;
    
    CGRect wheelStartFrame;
    CGRect wheelEndFrame;
    CGRect scrollViewFrame;
    
    float wheelDiameter;
}

@end
