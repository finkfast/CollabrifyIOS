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
        undoArray = [[NSMutableArray alloc] init];
        redoArray = [[NSMutableArray alloc] init];
        self.text = @"";
        current = @"";
        readonly = false;
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
    current = @"";
    undoArray = [[NSMutableArray alloc] init];
    redoArray = [[NSMutableArray alloc] init];
    readonly = false;
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(AddToStack:) name:UITextViewTextDidChangeNotification object:nil];
    return self;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))
    {
        return NO;
    }
    else if (action == @selector(copy:))
        return NO;
    else if (action == @selector(cut:))
    {
        return NO;
    }
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

- (void)cut:(id)sender //undo
{
    readonly = true;
    [self undo];
    readonly = false;
}

- (void)paste:(id)sender //redo
{
    readonly = true;
    [self redo];
    readonly = false;
}

- (void)AddToStack:(NSNotification *)note
{
    if(!readonly)
    {
        [self emptyTheStack];
        [self undoPush:current];
        current = self.text;
    }
}

- (void)undo
{
    if(undoArray.count > 0)
    {
        [self redoPush:current];
        current = [self undoPop];
        self.text = current;
    }
}

- (void)redo
{
    if(redoArray.count > 0)
    {
        [self undoPush:current];
        current = [self redoPop];
        self.text = current;
    }
}

- (void)emptyTheStack
{
    [redoArray removeAllObjects];
}

- (void)undoPush:(NSString*)anObject
{
    [undoArray addObject:anObject];
}

- (NSString*)undoPop
{
    NSString* temp;
    if(undoArray.count > 0)
    {
        temp = [undoArray lastObject];
        [undoArray removeLastObject];
    }
    return temp;
}

- (void)redoPush:(NSString*)anObject
{
    [redoArray addObject:anObject];
}

- (NSString*)redoPop
{
    NSString* temp;
    if(redoArray.count > 0)
    {
        temp = [redoArray lastObject];
        [redoArray removeLastObject];
    }
    return temp;
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
