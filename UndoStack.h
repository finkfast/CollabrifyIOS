//
//  UndoStack.h
//  WeWrite
//
//  Created by Joe Finkel on 27/9/13.
//  Copyright (c) 2013 Joe Finkel. All rights reserved.
//

#import <Foundation/Foundation.h>

enum TextAction
{
    INSERT = 0,
    REMOVE = 1
};

@interface UndoStack : NSObject
{
    NSMutableArray* array;
    int size;
}

- (void)push:(id)anObject;
- (id)pop;
- (void)emptyTheStack;
@property (nonatomic, readonly) int size;
@end
