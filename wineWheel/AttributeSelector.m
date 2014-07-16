//
//  AttributeSelector.m
//  wineWheel
//
//  Created by Jan-Dawid Roodt on 13/07/14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import "AttributeSelector.h"
#import "TasteViewController.h"

@implementation AttributeSelector

- (id)initWithFrame:(CGRect)frame andButtonNames: (NSArray *)bNames andDiscriptions: (NSArray *)dNames andRefViewCon: (TasteViewController *) vc;
{
    self = [super initWithFrame:frame];
    if (self) {
        buttonNames = [[NSArray alloc]initWithArray:bNames];
        discriptionNames = [[NSArray alloc]initWithArray:dNames];
        _refViewController = vc;
        self.backgroundColor = [UIColor clearColor];
        [self setupButtonsForIphone];
    }
    return self;
}

- (void) setupButtonsForIphone {
    _currentlySelectedButton = 0;
    buttonFontSize = 13.5;
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_leftButton addTarget:self action:@selector(pressedLeft) forControlEvents:UIControlEventTouchUpInside];
    [_leftButton setTitle:buttonNames[0] forState:UIControlStateNormal];
    [_leftButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:buttonFontSize]];
    _leftButton.titleLabel.numberOfLines = 2;
    _leftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _leftButton.frame = CGRectMake(30, 0, 80, 60);
    _leftButton.backgroundColor = [UIColor whiteColor];
    _leftButton.layer.borderWidth = 0.5f;
    _leftButton.layer.cornerRadius = 5;
    [_leftButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self addSubview:_leftButton];
    
    _middleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_middleButton addTarget:self action:@selector(pressedMiddle) forControlEvents:UIControlEventTouchUpInside];
    [_middleButton setTitle:buttonNames[1] forState:UIControlStateNormal];
    [_middleButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:buttonFontSize]];
    _middleButton.titleLabel.numberOfLines = 2;
    _middleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _middleButton.frame = CGRectMake(120, 0, 80, 60);
    _middleButton.backgroundColor = [UIColor whiteColor];
    _middleButton.layer.borderWidth = 0.5f;
    _middleButton.layer.cornerRadius = 5;
    [_middleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self addSubview:_middleButton];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_rightButton addTarget:self action:@selector(pressedRight) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton setTitle:buttonNames[2] forState:UIControlStateNormal];
    [_rightButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:buttonFontSize]];
    _rightButton.titleLabel.numberOfLines = 2;
    _rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _rightButton.frame = CGRectMake(210, 0, 80, 60);
    _rightButton.backgroundColor = [UIColor whiteColor];
    _rightButton.layer.borderWidth = 0.5f;
    _rightButton.layer.cornerRadius = 5;
    [_rightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self addSubview:_rightButton];
    
    // label
    _discriptionOfOption = [[UILabel alloc]initWithFrame:CGRectMake(20, _leftButton.frame.size.height+10, 280, 100)];
    _discriptionOfOption.numberOfLines = 4;
    [self addSubview:_discriptionOfOption];
}


// button presses
- (void) pressedLeft {
    if (_currentlySelectedButton == 1) {
        [self clearAllButtons];
        _currentlySelectedButton = 0;
        _discriptionOfOption.hidden = YES;
    } else {
        _currentlySelectedButton = 1;
        _discriptionOfOption.text = discriptionNames[0];
        _discriptionOfOption.hidden = NO;
        [self clearAllButtons];
        _leftButton.backgroundColor = [UIColor greenColor];
    }
    [self generalButtonPressed];
}

- (void) pressedMiddle {
    if (_currentlySelectedButton == 2) {
        [self clearAllButtons];
        _currentlySelectedButton = 0;
        _discriptionOfOption.hidden = YES;
    } else {
        _currentlySelectedButton = 2;
        _discriptionOfOption.text = discriptionNames[1];
        _discriptionOfOption.hidden = NO;
        [self clearAllButtons];
        _middleButton.backgroundColor = [UIColor greenColor];
    }
    [self generalButtonPressed];
}

- (void) pressedRight {
    if (_currentlySelectedButton == 3) {
        [self clearAllButtons];
        _currentlySelectedButton = 0;
        _discriptionOfOption.hidden = YES;
    } else {
        _currentlySelectedButton = 3;
        _discriptionOfOption.text = discriptionNames[2];
        _discriptionOfOption.hidden = NO;
        [self clearAllButtons];
        _rightButton.backgroundColor = [UIColor greenColor];
    }
    [self generalButtonPressed];
}

- (void) unselectedButton {
    _currentlySelectedButton = 0;
    _discriptionOfOption.text = @"";
    _discriptionOfOption.hidden = YES;
    [self clearAllButtons];
}

- (void) generalButtonPressed {
    [_refViewController checkAttributesFufilment];
    // do general button press things
}

- (void) clearAllButtons {
    _leftButton.backgroundColor = [UIColor whiteColor];
    _middleButton.backgroundColor = [UIColor whiteColor];
    _rightButton.backgroundColor = [UIColor whiteColor];
}

@end
