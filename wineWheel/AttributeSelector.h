//
//  AttributeSelector.h
//  wineWheel
//
//  Created by Jan-Dawid Roodt on 13/07/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TasteViewController;

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
@property (nonatomic, weak) TasteViewController *refViewController;


- (id)initWithFrame:(CGRect)frame andButtonNames: (NSArray *)bNames andDiscriptions: (NSArray *)dNames andRefViewCon: (TasteViewController *) vc;
- (void) unselectedButton;

@end
