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
    UndoStack* undoStack;
    UndoStack* redoStack;
}

- (void)undo;
- (void)redo;
- (void)insertAddToStack:(id)anObject;
- (void)deleteAddToStack:(id)anObject;

@end
