//
//  StackAction.m
//  WeWrite
//
//  Created by Joe Finkel on 27/9/13.
//  Copyright (c) 2013 Joe Finkel. All rights reserved.
//

#import "StackAction.h"

@implementation StackAction

-(NSString*)getText
{
    return text;
}

-(void)setText:(NSString*)inText
{
    text = inText;
}

-(int)getAction
{
    return action;
}

-(void)setAction:(int)inAction
{
    action = inAction;
}

@end
