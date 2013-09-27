//
//  LimitedTextView.m
//  WeWrite
//
//  Created by Joe Finkel on 27/9/13.
//  Copyright (c) 2013 Joe Finkel. All rights reserved.
//

#import "LimitedTextView.h"

@implementation LimitedTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.text = @"";
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(AddToStack:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self setDelegate:self];
    }
    self.text = @"";
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(AddToStack:) name:UITextViewTextDidChangeNotification object:nil];
    return self;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))
        return NO;
    else if (action == @selector(copy:))
        return NO;
    else if (action == @selector(cut:))
        return NO;
    else if (action == @selector(select:))
        return NO;
    else if (action == @selector(selectAll:))
        return NO;
    
    return [super canPerformAction:action withSender:sender];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.length <= 1)
    {
        return YES;
    }
    
    return NO;
}

- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        [(UITapGestureRecognizer *)gestureRecognizer setNumberOfTapsRequired:1];
    }
    
    [super addGestureRecognizer:gestureRecognizer];
}

- (void)undo
{
    if(undoStack.size > 0)
    {
        NSString* temp = [undoStack pop];
        self.text = temp;
        [redoStack push:temp];
    }
}

- (void)redo
{
    if(redoStack.size > 0)
    {
        NSString* temp = [redoStack pop];
        self.text = temp;
        [undoStack push:temp];
    }
}

- (void)AddToStack:(NSNotification *)note
{
    [redoStack emptyTheStack];
    NSString* temp = self.text;
    [undoStack push:temp];
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
