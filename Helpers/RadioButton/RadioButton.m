//
//  RadioButton.m
//  RadioButton
//
//  Created by ohkawa on 11/03/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RadioButton.h"

@interface RadioButton()
-(void)defaultInit;
-(void)otherButtonSelected:(id)sender;
-(void)handleButtonTap:(id)sender;
@end

@implementation RadioButton

@synthesize groupId=_groupId;
@synthesize index=_index;

static const NSUInteger kRadioButtonWidth=32;
static const NSUInteger kRadioButtonHeight=32;

static const NSUInteger kRadioButtonWidthLarge=44;
static const NSUInteger kRadioButtonHeightLarge=44;

static NSMutableArray *rb_instances=nil;
static NSMutableDictionary *rb_observers=nil;

#pragma mark - Observer

+(void)addObserverForGroupId:(NSString*)groupId observer:(id)observer{
    if(!rb_observers){
        rb_observers = [[NSMutableDictionary alloc] init];
    }
    
    if ([groupId length] > 0 && observer) {
        [rb_observers setObject:observer forKey:groupId];
        // Make it weak reference
    }
}

#pragma mark - Manage Instances

+(void)registerInstance:(RadioButton*)radioButton{
    if(!rb_instances){
        rb_instances = [[NSMutableArray alloc] init];
    }
    
    [rb_instances addObject:radioButton];
    // Make it weak reference
}

#pragma mark - Class level handler

+(void)buttonSelected:(RadioButton*)radioButton{
    
    // Notify observers
    if (rb_observers) {
        id observer= [rb_observers objectForKey:radioButton.groupId];
        
        if(observer && [observer respondsToSelector:@selector(radioButtonSelectedAtIndex:inGroup:)]){
            [observer radioButtonSelectedAtIndex:radioButton.index inGroup:radioButton.groupId];
        }
    }
    
    // Unselect the other radio buttons
    if (rb_instances) {
        for (int i = 0; i < [rb_instances count]; i++) {
            RadioButton *button = [rb_instances objectAtIndex:i];
            if (![button isEqual:radioButton] && [button.groupId isEqualToString:radioButton.groupId]) {
                [button otherButtonSelected:radioButton];
            }
        }
    }
}

#pragma mark - Object Lifecycle

-(id)initWithGroupId:(NSString*)groupId index:(NSUInteger)index{
    self = [self init];
    if (self) {
        _groupId = groupId;
        _index = index;
    }
    return  self;
}

- (id)init{
    self = [super init];
    if (self) {
        [self defaultInit];
    }
    return self;
}

#pragma mark - Tap handling

-(void)handleButtonTap:(id)sender{
    [_button setSelected:YES];
    [RadioButton buttonSelected:self];
}

-(void)otherButtonSelected:(id)sender{
    // Called when other radio button instance got selected
    if(_button.selected){
        [_button setSelected:NO];        
    }
}

#pragma mark - RadioButton init

-(void)defaultInit{
    // Customize UIButton
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect frame;
    UIImage *selectedImage, *unselectedImage;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        // Setup container view
        self.frame = CGRectMake(0, 0, kRadioButtonWidthLarge, kRadioButtonHeightLarge);
        
        frame = CGRectMake(0, 0,kRadioButtonWidthLarge, kRadioButtonHeightLarge);
        unselectedImage = [UIImage imageNamed:@"RadioButtonLarge-Unselected"];
        selectedImage = [UIImage imageNamed:@"RadioButtonLarge-Selected"];
        
    } else {
        // Setup container view
        self.frame = CGRectMake(0, 0, kRadioButtonWidth, kRadioButtonHeight);
        
        frame = CGRectMake(0, 0,kRadioButtonWidth, kRadioButtonHeight);
        unselectedImage = [UIImage imageNamed:@"RadioButton-Unselected"];
        selectedImage = [UIImage imageNamed:@"RadioButton-Selected"];
    }
    
    _button.frame = frame;
    _button.adjustsImageWhenHighlighted = NO;
    [_button setImage:unselectedImage forState:UIControlStateNormal];
    [_button setImage:selectedImage forState:UIControlStateSelected];
    
    [_button addTarget:self action:@selector(handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_button];
    
    [RadioButton registerInstance:self];
}

@end
