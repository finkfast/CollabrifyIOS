//
//  LimitedTextView.m
//  WeWrite
//
//  Created by Joe Finkel on 27/9/13.
//  Copyright (c) 2013 Joe Finkel. All rights reserved.
//

#import "LimitedTextView.h"
#import "bufferStuff.h"

//true = insert
//false = remove
@implementation LimitedTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.text = @"";
        current = @"";
        //current3 = @"false";
        //cursorPos = [self selectedRange];
        undoArray1 = [[NSMutableArray alloc] init];
        redoArray1 = [[NSMutableArray alloc] init];
        undoArray2 = [[NSMutableArray alloc] init];
        redoArray2 = [[NSMutableArray alloc] init];
        undoArray3 = [[NSMutableArray alloc] init];
        redoArray3 = [[NSMutableArray alloc] init];
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
    //current3 = @"false";
    //cursorPos = [self selectedRange];
    undoArray1 = [[NSMutableArray alloc] init];
    redoArray1 = [[NSMutableArray alloc] init];
    undoArray2 = [[NSMutableArray alloc] init];
    redoArray2 = [[NSMutableArray alloc] init];
    undoArray3 = [[NSMutableArray alloc] init];
    redoArray3 = [[NSMutableArray alloc] init];
    [[self client] setDelegate:self];
    [[self client] setDataSource:self];
    //[[self client] ]
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
    else if (action == @selector(correctionCheckingResultWithRange:replacementString:))
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

- (void)copy:(id)sender //leaveSessionButton
{
   //end collabrify session
}


- (void)AddToStack:(NSNotification *)note
{
    if(!readonly)
    {
        [self emptyTheStack];
        NSString* toAdd;
        NSRange grab = [self selectedRange];
        grab.length++;
        if(current.length > [self.text length])
        {
            toAdd = [current substringWithRange:grab];
            current3 = @"false";
            cursorPos = [self selectedRange];
            [self undoPush:toAdd];
        }
        else if(current.length < [self.text length])
        {
            grab.location--;
            toAdd = [self.text substringWithRange:grab];
            current3 = @"true";
            cursorPos = [self selectedRange];
            [self undoPush:toAdd];
        }
        current = self.text;
    }
}

- (void)undo
{
    if(undoArray1.count > 0)
    {
        NSString* temp = [self undoPop];
        [self redoPush:temp];
        if([current3 isEqual: @"false"])
        {
            [self undoinsert:temp];
        }
        else
        {
            [self undodeleteChar:temp];
        }
        current = self.text;
    }
}

- (void)redo
{
    if(redoArray1.count > 0)
    {
        NSString* temp = [self redoPop];
        [self undoPush:temp];
        if([current3 isEqual: @"false"])
        {
            [self redodeleteChar:temp];
        }
        else
        {
            [self redoinsert:temp];
        }
        current = self.text;
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
    details::Event *msg = new details::Event();
    std::string temp = std::string([anObject UTF8String]);
    msg->set_variable(temp);
    if([current3 isEqualToString:@"false"])
    {
        msg->set_action(false);
    }
    else
    {
        msg->set_action(true);
    }
    msg->set_index(cursorPos.location);
    NSData* toBroadcast = dataForProtoBufMessage(*msg);
    [[self client] broadcast:toBroadcast eventType:[self userName]];
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
        [undoArray2 removeLastObject];
        cursorPos = NSRangeFromString(var);
        current3 = [undoArray3 lastObject];
        [undoArray3 removeLastObject];
    }
    return temp;
}

- (void)redoPush:(NSString*)anObject
{
    details::Event *msg = new details::Event();
    std::string temp = std::string([anObject UTF8String]);
    msg->set_variable(temp);
    if([current3 isEqualToString:@"false"])
    {
        msg->set_action(false);
    }
    else
    {
        msg->set_action(true);
    }
    msg->set_index(cursorPos.location);
    NSData* toBroadcast = dataForProtoBufMessage(*msg);
    [[self client] broadcast:toBroadcast eventType:[self userName]];
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
        [redoArray2 removeLastObject];
        cursorPos = NSRangeFromString(var);
        current3 = [redoArray3 lastObject];
        [redoArray3 removeLastObject];
    }
    return temp;
}

- (void)redoinsert:(id)input
{
    NSString* temp;
    NSString* temp1;
    if(self.text.length > 0)
    {
        if(cursorPos.location == 0)
        {
            temp1 = [self.text substringToIndex:cursorPos.location];
            temp1 = [temp1 stringByAppendingString:input];
            temp = [self.text substringFromIndex:cursorPos.location];
            temp1 = [temp1 stringByAppendingString:temp];
        }
        else
        {
            temp1 = [self.text substringToIndex:cursorPos.location - 1];
            temp1 = [temp1 stringByAppendingString:input];
            temp = [self.text substringFromIndex:cursorPos.location - 1];
            temp1 = [temp1 stringByAppendingString:temp];
        }
    }
    else
    {
        temp1 = input;
    }
    self.text = temp1;
}

- (void)redodeleteChar:(id)toDelete
{
    NSString* temp;
    NSString* temp1;
    temp1 = [self.text substringToIndex:cursorPos.location];
    temp = [self.text substringFromIndex:cursorPos.location + 1];
    temp1 = [temp1 stringByAppendingString:temp];
    self.text = temp1;
}

- (void)undoinsert:(id)input
{
    NSString* temp;
    NSString* temp1;
    if(self.text.length > 0)
    {
        if(cursorPos.location == 0)
        {
            temp1 = [self.text substringToIndex:cursorPos.location];
            temp1 = [temp1 stringByAppendingString:input];
            temp = [self.text substringFromIndex:cursorPos.location];
            temp1 = [temp1 stringByAppendingString:temp];
        }
        else
        {
            temp1 = [self.text substringToIndex:cursorPos.location];
            temp1 = [temp1 stringByAppendingString:input];
            temp = [self.text substringFromIndex:cursorPos.location];
            temp1 = [temp1 stringByAppendingString:temp];
        }
    }
    else
    {
        temp1 = input;
    }
    self.text = temp1;
}

- (void)undodeleteChar:(id)toDelete
{
    NSString* temp;
    NSString* temp1;
    temp1 = [self.text substringToIndex:cursorPos.location - 1];
    temp = [self.text substringFromIndex:cursorPos.location];
    temp1 = [temp1 stringByAppendingString:temp];
    self.text = temp1;
}

- (void)reflectDelete:(int)measure
{
    for(int i = 0; i < undoArray2.count; i++)
    {
        NSString* var = [undoArray2 objectAtIndex:i];
        NSRange temp = NSRangeFromString(var);
        if(temp.location > measure)
        {
            temp.location--;
            var = NSStringFromRange(temp);
            [undoArray2 setObject:var atIndexedSubscript:i];
        }
    }
    for(int i = 0; i < redoArray2.count; i++)
    {
        NSString* var = [redoArray2 objectAtIndex:i];
        NSRange temp = NSRangeFromString(var);
        if(temp.location > measure)
        {
            temp.location--;
            var = NSStringFromRange(temp);
            [redoArray2 setObject:var atIndexedSubscript:i];
        }
    }
}

- (void)reflectInsert:(int)measure
{
    for(int i = 0; i < undoArray2.count; i++)
    {
        NSString* var = [undoArray2 objectAtIndex:i];
        NSRange temp = NSRangeFromString(var);
        if(temp.location >= measure)
        {
            temp.location++;
            var = NSStringFromRange(temp);
            [undoArray2 setObject:var atIndexedSubscript:i];
        }
    }
    for(int i = 0; i < redoArray2.count; i++)
    {
        NSString* var = [redoArray2 objectAtIndex:i];
        NSRange temp = NSRangeFromString(var);
        if(temp.location >= measure)
        {
            temp.location++;
            var = NSStringFromRange(temp);
            [redoArray2 setObject:var atIndexedSubscript:i];
        }
    }

}

//receive text from session at launch
- (void)insertTextFromSession:(NSString *)input
{
    self.text = input;
}

- (void)foreignInsert:(NSString*)letter at:(int)spot
{
    NSString* temp;
    NSString* temp1;
    if(self.text.length > 0)
    {
        if(spot == 0)
        {
            temp1 = [self.text substringToIndex:spot];
            temp1 = [temp1 stringByAppendingString:letter];
            temp = [self.text substringFromIndex:spot];
            temp1 = [temp1 stringByAppendingString:temp];
        }
        else
        {
            temp1 = [self.text substringToIndex:spot - 1];
            temp1 = [temp1 stringByAppendingString:letter];
            temp = [self.text substringFromIndex:spot - 1];
            temp1 = [temp1 stringByAppendingString:temp];
        }
    }
    else
    {
        temp1 = letter;
    }
    [self reflectInsert:spot];
    self.text = temp1;
}

- (void)foreignDelete:(int)spot
{
    NSString* temp;
    NSString* temp1;
    temp1 = [self.text substringToIndex:spot];//subject to change
    temp = [self.text substringFromIndex:spot + 1];
    temp1 = [temp1 stringByAppendingString:temp];
    [self reflectDelete:spot];
    self.text = temp1;
}

- (void)receiveEvent:(NSData*)input
{
    details::Event *msg = new details::Event();
    parseDelimitedProtoBufMessageFromData(*msg, input);
    readonly = true;
    if(!msg->action())
    {
        [self foreignDelete:msg->index()];
    }
    else
    {
        NSString *temp = [NSString stringWithCString:msg->variable().c_str() encoding:[NSString defaultCStringEncoding]];
        [self foreignInsert:temp at:msg->index()];
    }
    readonly = false;
}
/*
- (void) client:(CollabrifyClient *)client receivedEventWithOrderID:(int64_t)orderID submissionRegistrationID:(int32_t)submissionRegistrationID eventType:(NSString *)eventType data:(NSData *)data
{
    NSLog(@"Server listener is called");
    [self receiveEvent:data];
}
*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
