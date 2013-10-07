//
//  ASITextViewController.h
//  WeWrite
//
//  Created by Joe Finkel on 7/10/13.
//  Copyright (c) 2013 Joe Finkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Collabrify/Collabrify.h>
#import "LimitedTextView.h"

@interface ASITextViewController : UIViewController

{
    LimitedTextView* IBOutlet limit1;
}

@property (strong, nonatomic) CollabrifyClient *client;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSString* isConnected;
@property (strong, nonatomic) LimitedTextView* limit;

@end
