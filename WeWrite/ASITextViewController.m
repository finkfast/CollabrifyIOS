//
//  ASITextViewController.m
//  WeWrite
//
//  Created by Joe Finkel on 7/10/13.
//  Copyright (c) 2013 Joe Finkel. All rights reserved.
//

#import "ASITextViewController.h"

@interface ASITextViewController () <CollabrifyClientDelegate, CollabrifyClientDataSource>

@end

@implementation ASITextViewController 

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self client])
    {
        //From how to integrate collabrify document
        NSError *error;
        [self setClient:[[CollabrifyClient alloc] initWithGmail:@"josephfinkel92@gmail.com"
                                                    displayName:@"User's Display Name"
                                                   accountGmail:@"441fall2013@umich.edu"
                                                    accessToken:@"XY3721425NoScOpE"
                                                 getLatestEvent:NO
                                                          error:&error]];
        [self setTags:@[@"jfjx"]];
        [[self client] setDelegate:self];
        [[self client] setDataSource:self];
    }
    if (![self isConnected])
    {
        [self setIsConnected:@"false"];
    }
    if (!limit1)
    {
        limit1 = [LimitedTextView alloc];
    }
    [self setLimit:limit1];
    if(![[self limit] client])
    {
        [[self limit] setClient:[self client]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
