//
//  StackAction.h
//  WeWrite
//
//  Created by Joe Finkel on 27/9/13.
//  Copyright (c) 2013 Joe Finkel. All rights reserved.
//

#import "UndoStack.h"
#import <Foundation/Foundation.h>

@interface StackAction : NSObject
{
    char letter;
    int action;
}

-(char)getLetter;
-(void)setLetter:(char)inLetter;
-(int)getAction;
-(void)setAction:(int)inAction;
@end
