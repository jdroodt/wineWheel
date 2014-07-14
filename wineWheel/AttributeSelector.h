//
//  AttributeSelector.h
//  wineWheel
//
//  Created by Jan-Dawid Roodt on 13/07/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttributeSelector : UIView {
    NSArray *buttonNames;
    NSArray *discriptionNames;
    int buttonFontSize;
    //int currentlySelectedButton; // make this enums when I have time (values are 1, 2, 3, {left, mid, right}) 0 for unselected
}

@property UIButton *leftButton;
@property UIButton *middleButton;
@property UIButton *rightButton;
@property UILabel *discriptionOfOption;
@property int currentlySelectedButton;


- (id)initWithFrame:(CGRect)frame andButtonNames: (NSArray *)bNames andDiscriptions: (NSArray *)dNames;
- (void) unselectedButton;

@end
