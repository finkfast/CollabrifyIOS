//
//  LimitedTextView.m
//  WeWrite
//
//  Created by Joe Finkel on 27/9/13.
//  Copyright (c) 2013 Joe Finkel. All rights reserved.
//

#import "LimitedTextView.h"

//true = insert
//false = remove
@implementation LimitedTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        undoArray1 = [[NSMutableArray alloc] init];
        redoArray1 = [[NSMutableArray alloc] init];
        self.text = @"";
        current = @"";
        current3 = @"false";
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
    current3 = @"false";
    cursorPos = [self selectedRange];
    currentSize = 0;
    undoArray1 = [[NSMutableArray alloc] init];
    redoArray1 = [[NSMutableArray alloc] init];
    undoArray2 = [[NSMutableArray alloc] init];
    redoArray2 = [[NSMutableArray alloc] init];
    undoArray3 = [[NSMutableArray alloc] init];
    redoArray3 = [[NSMutableArray alloc] init];
    readonly = false;
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
        if(current.length > [self.text length])
        {
            current3 = @"false";
        }
        else
        {
            current3 = @"true";
        }
        cursorPos = [self selectedRange];
        current = self.text;
    }
}

- (void)undo
{
    if(undoArray1.count > 0)
    {
        [self redoPush:current];
        current = [self undoPop];        
        self.text = current;
    }
}

- (void)redo
{
    if(redoArray1.count > 0)
    {
        [self undoPush:current];
        current = [self redoPop];
        self.text = current;
    }
}

- (void)emptyTheStack
{
    [redoArray1 removeAllObjects];
    [redoArray2 removeAllObjects];
    [redoArray3 removeAllObjects];
}

- (void)undoPush:(NSString*)anObject
{
    [undoArray1 addObject:anObject];
    NSString* var = NSStringFromRange(cursorPos);
    [undoArray2 addObject:var];
    [undoArray3 addObject:current3];
}

- (NSString*)undoPop
{
    NSString* temp;
    if(undoArray1.count > 0)
    {
        temp = [undoArray1 lastObject];
        [undoArray1 removeLastObject];
        NSString* var = [undoArray2 lastObject];
        cursorPos = NSRangeFromString(var);
        current3 = [undoArray3 lastObject];
        [undoArray3 removeLastObject];
    }
    return temp;
}

- (void)redoPush:(NSString*)anObject
{
    [redoArray1 addObject:anObject];
    NSString* var = NSStringFromRange(cursorPos);
    [redoArray2 addObject:var];
    [redoArray3 addObject:current3];
}

- (NSString*)redoPop
{
    NSString* temp;
    if(redoArray1.count > 0)
    {
        temp = [redoArray1 lastObject];
        [redoArray1 removeLastObject];
        NSString* var = [redoArray2 lastObject];
        cursorPos = NSRangeFromString(var);
        current3 = [redoArray3 lastObject];
        [redoArray3 removeLastObject];
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
