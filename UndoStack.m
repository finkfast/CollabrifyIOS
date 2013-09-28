//
//  UndoStack.m
//  WeWrite
//
//  Created by Joe Finkel on 27/9/13.
//  Copyright (c) 2013 Joe Finkel. All rights reserved.
//

#import "UndoStack.h"

@implementation UndoStack
@synthesize size;

- (id)init
{
    if( self=[super init] )
    {
        array = [[NSMutableArray alloc] init];
        size = 0;
    }
    return self;
}

- (void)push:(NSString*)anObject
{
    [array addObject:anObject];
    size = size + 1;
}

- (NSString*)pop
{
    NSString* temp;
    if(array.count > 0)
    {
        temp = [array lastObject];
        [array removeLastObject];
        size = size - 1;
    }
    return temp;
}

- (void)emptyTheStack
{
    [array removeAllObjects];
    size = 0;
}
@end
