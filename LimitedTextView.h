//
//  LimitedTextView.h
//  WeWrite
//
//  Created by Joe Finkel on 27/9/13.
//  Copyright (c) 2013 Joe Finkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UndoStack.h"


@interface LimitedTextView : UITextView <UITextViewDelegate>
{
    NSMutableArray* undoArray;
    NSMutableArray* redoArray;
    NSString* current;
    BOOL readonly;
}

- (void)undo;
- (void)redo;
- (void)undoPush:(id)anObject;
- (id)undoPop;
- (void)redoPush:(id)anObject;
- (id)redoPop;
- (void)emptyTheStack;
- (void)AddToStack:(NSNotification *)note;

@end
