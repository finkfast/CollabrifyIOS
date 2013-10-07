//
//  ASIViewController.m
//  WeWrite
//
//  Created by Joe Finkel on 16/9/13.
//  Copyright (c) 2013 Joe Finkel. All rights reserved.
//

#import "ASIViewController.h"
#import <Collabrify/Collabrify.h>

@interface ASIViewController () < CollabrifyClientDelegate, CollabrifyClientDataSource>

@property (strong, nonatomic) CollabrifyClient *client;


@end

@implementation ASIViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self client])
    {
        //From how to integrate collabrify document
        NSError *error;
        //[self setClient:[[CollabrifyClient alloc] initWithGmail:@"usersGmail@gmail.com"
        //                                            displayName:@"User's Display Name"
        //                                           accountGmail:@"441fall2013@umich.edu"
        //                                            accessToken:@"XY3721425NoScOpE"
        //                                         getLatestEvent:NO
        //                                                  error:&error]];
        [[self client] setDelegate:self];
        [[self client] setDataSource:self];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
