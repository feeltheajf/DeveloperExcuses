//
//  DeveloperExcusesView.m
//  DeveloperExcuses
//
//  Created by ekzo! on 13/09/2018.
//  Copyright © 2018 ekzo!. All rights reserved.
//

#import "DeveloperExcusesView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DeveloperExcusesView

CGFloat width = 550, height = 150, linewidth = 5;

NSArray *excuses;
NSRect frame;
NSDictionary *textFontAttributes;

BOOL textIsShowing = NO;
BOOL animatingOpening = YES;
BOOL animatingClosing = NO;

int frameNumber = 0;
int delay = 10000;
int tmpWidth = 0;
int step = 50;

float interval = 1000;

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/interval];
    }
    
    excuses = @[@"WELL DONE\nYOU FOUND MY EASTER EGG",
                @"OH, YOU SAID YOU DIDN'T\nWANT THAT TO HAPPEN?",
                @"MAY CONTAIN CONTENT\nINAPPROPRIATE FOR CHILDREN",
                @"IT WORKS\nBUT IT'S NOT BEEN TESTED",
                @"YOU'RE DOING IT WRONG",
                @"I'M SURPRISED THAT\nWAS WORKING AT ALL",
                @"WELL, AT LEAST IT DISPLAYS\nA VERY PRETTY ERROR",
                @"I BROKE THAT DELIBERATELY\nTO DO SOME TESTING",
                @"I HAVE NEVER SEEN THAT\nBEFORE IN MY LIFE",
                @"I DIDN'T FIX IT\nIN CASE I MADE IT WORSE",
                @"ACTUALLY, THAT'S A FEATURE",
                @"EVERYTHING LOOKS FINE MY END",
                @"SOMEBODY MUST HAVE\nCHANGED MY CODE",
                @"IT CAN'T BE BROKEN\nIT PASSES ALL UNIT TESTS",
                @"THAT'S THE FAULT OF\nTHE GRAPHIC DESIGNER",
                @"I THOUGHT I FINISHED THAT",
                @"EVEN THOUGH IT DOESN'T WORK\nHOW DOES IT FEEL?",
                @"I DID A QUICK FIX BUT\nIT BROKE WHEN WE REBOOTED",
                @"THAT ERROR MEANS\nIT WAS SUCCESSFUL",
                @"I FORGOT TO COMMIT\nTHE CODE THAT FIXES THAT",
                @"IT MUST BE A\nHARDWARE PROBLEM",
                @"THE PROJECT MANAGER TOLD ME\nTO DO IT THAT WAY",
                @"WHAT DID YOU TYPE IN WRONG\nTO GET IT TO CRASH?",
                @"IT WORKS FOR ME",
                @"THE USER MUST NOT\nKNOW HOW TO USE IT"];

    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
    
//    Calculate frame location
    NSSize size = [self bounds].size;
    
    if (animatingOpening) {
        if (tmpWidth < width) {
            tmpWidth += step;
        }
        else {
            animatingOpening = NO;
            textIsShowing = YES;
        }
    }
    else if (animatingClosing) {
        if (tmpWidth > 0) {
            tmpWidth -= step;
        }
        else {
            animatingClosing = NO;
            textIsShowing = NO;
            return;
        }
    }
    else {
        tmpWidth = width;
    }
    
    CGFloat horizontalMid = (size.width - tmpWidth) / 2, verticalMid = (size.height - height) / 2;
    frame.size = NSMakeSize(tmpWidth, height);
    frame.origin = NSMakePoint(horizontalMid, verticalMid);
    
//    Draw frame
    [[NSColor whiteColor] set];
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:frame];
    path.lineWidth = linewidth;
    [path stroke];
    
    if (animatingOpening || animatingClosing) {
        return;
    }
    
//    Set text font attributes
    NSMutableParagraphStyle *textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    textStyle.alignment = NSTextAlignmentCenter;
    textFontAttributes = @{NSFontAttributeName: [NSFont fontWithName:@"Blogger Sans Medium" size:36], NSForegroundColorAttributeName:NSColor.whiteColor, NSParagraphStyleAttributeName:textStyle};
    
//    Pick Random String
    NSString *randomExcuseString = excuses[SSRandomIntBetween(0, 24)];
    
//    Calculate padding
    int padding = [randomExcuseString containsString:@"\n"] ? 42 : 63;
    NSRect textFrame = frame;
    textFrame.origin.y = frame.origin.y - padding;
    
//    Draw text in frame
    [randomExcuseString drawInRect:textFrame withAttributes:textFontAttributes];
}

- (void)animateOneFrame
{
    if (animatingOpening || animatingClosing) {
        [self setNeedsDisplay:YES];
        return;
    }
    
    if ((frameNumber += 1) == delay) {
        [self setNeedsDisplay:YES];
        frameNumber = 0;
        
        if (textIsShowing) {
            animatingClosing = YES;
            delay = SSRandomIntBetween(3, 5) * 1000;
        }
        else {
            animatingOpening = YES;
            delay = SSRandomIntBetween(9, 15) * 1000;
        }
    }
    
    return;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
