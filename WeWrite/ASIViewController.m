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
{
    NSString* sessionName;
}

@property (strong, nonatomic) CollabrifyClient *client;
@property (strong, nonatomic) NSArray *tags;


@end

@implementation ASIViewController

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
}

- (IBAction)leaveSessionButtonAction:(id)sender
{
    [[self client] leaveAndDeleteSession:YES completionHandler:^(BOOL success, CollabrifyError *error) {
        //
    }];
}

-(IBAction)createJoinButtonAction:(id)sender
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Create/Join Session" message:@"Please create a new session, or join an active session" delegate:self cancelButtonTitle:@"Enter" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    sessionName = [[alertView textFieldAtIndex:0] text];
    __block CollabrifySession *session = nil;
    [self.client listSessionsWithTags:[self tags]
                    completionHandler:^(NSArray *sessionList, CollabrifyError *error)
    {
        if(!error)
        {
            for(int i = 0; i < sessionList.count; i ++)
            {
                if([[sessionList[i] sessionName] isEqualToString:sessionName])
                {
                    session = sessionList[i];
                    break;
                }
            }
        }
    }];
    if(session != nil)
    {
        [self.client joinSessionWithID:[session sessionID]
                              password:nil
                     completionHandler:^(int64_t maxOrderID, int32_t baseFileSize, CollabrifyError *error)
        {
            if(!error)
            {
                
            }
            else
            {
                NSLog(@"Failed to Join Session");
            }
        }];
    }
    else
    {
     [self.client createSessionWithName:sessionName
                                  tags:[self tags]
                              password:nil
                           startPaused:NO
                     completionHandler:^(int64_t sessionID, CollabrifyError *error)
                    {
                        if(!error)
                        {
                             
                        }
                        else
                        {
                            NSLog(@"Failed to Create Session");
                        }
                    }];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
