//
//  LimitedTextView.h
//  WeWrite
//
//  Created by Joe Finkel on 27/9/13.
//  Copyright (c) 2013 Joe Finkel. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LimitedTextView : UITextView <UITextViewDelegate>
{
    NSMutableArray* undoArray1;//char
    NSMutableArray* undoArray2;//index
    NSMutableArray* undoArray3;//bool
    NSMutableArray* redoArray1;
    NSMutableArray* redoArray2;
    NSMutableArray* redoArray3;
    NSString* current;
    NSString* current3;
    BOOL readonly;
    int currentSize;
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
