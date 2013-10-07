//
//  LimitedTextView.h
//  WeWrite
//
//  Created by Joe Finkel on 27/9/13.
//  Copyright (c) 2013 Joe Finkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Collabrify/Collabrify.h>

@interface LimitedTextView : UITextView <UITextViewDelegate, CollabrifyClientDelegate, CollabrifyClientDataSource>
{
    NSMutableArray* undoArray1;//char
    NSMutableArray* undoArray2;//index
    NSMutableArray* undoArray3;//bool
    NSMutableArray* redoArray1;
    NSMutableArray* redoArray2;
    NSMutableArray* redoArray3;
    NSString* current;
    NSRange cursorPos;
    NSString* current3;
    NSString* false_;
    NSString* true_;
    BOOL readonly;
}

@property (strong, nonatomic) CollabrifyClient* client;

- (void)undo;
- (void)redo;
- (void)undoPush:(id)anObject;
- (id)undoPop;
- (void)redoPush:(id)anObject;
- (id)redoPop;
- (void)emptyTheStack;
- (void)AddToStack:(NSNotification *)note;
- (void)redoinsert:(id)input;
- (void)redodeleteChar:(id)toDelete;
- (void)undoinsert:(id)input;
- (void)undodeleteChar:(id)toDelete;
- (void)reflectDelete:(int)measure;
- (void)reflectInsert:(int)measure;
- (void)insertTextFromSession:(NSString*)input;
- (void)foreignInsert:(NSString*)letter at:(int)spot;
- (void)foreignDelete:(int)spot;
- (void)receiveEvent:(NSData*)input;

@end
