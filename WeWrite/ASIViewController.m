//
//  ASIViewController.m
//  WeWrite
//
//  Created by Joe Finkel on 16/9/13.
//  Copyright (c) 2013 Joe Finkel. All rights reserved.
//

#import "ASIViewController.h"
#import <Collabrify/Collabrify.h>
#import "ASITextViewController.h"

@interface ASIViewController () <CollabrifyClientDelegate, CollabrifyClientDataSource>
{
    NSString* sessionName;
    //LimitedTextView* IBOutlet limit1;
}

@property (strong, nonatomic) CollabrifyClient *client;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSString* isConnected;
@property (strong, nonatomic) ASITextViewController* text;
@property (strong, nonatomic) NSString* userName;

@end

@implementation ASIViewController


- (void) viewWillAppear:(BOOL)animated
{
    [self setUserName:@"josephfinkel92@gmail.com"];
    [super viewWillAppear:animated];
    if (![self client])
    {
        //From how to integrate collabrify document
        NSError *error;
        [self setClient:[[CollabrifyClient alloc] initWithGmail:[self userName]
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
    if (![self text])
    {
        [self setText:[ASITextViewController alloc]];
    }/*
    //if (!limit1)
    //{
    //    limit1 = [LimitedTextView alloc];
    //}
    [self setLimit:limit1];
    if(![[self limit] client])
    {
        [[self limit] setClient:[self client]];
    }*/
}

- (IBAction)leaveSessionButtonAction:(id)sender
{
    if([[self isConnected] isEqualToString:@"true"])
    {
        [[self client] leaveAndDeleteSession:YES completionHandler:^(BOOL success, CollabrifyError *error)
         {
             if(!error)
             {
                 [self setIsConnected:@"false"];
                 NSLog(@"Left the Session");
             }
             else
             {
                 NSLog(@"Did not leave and delete successfully");
             }
         }];
    }
}

-(IBAction)createJoinButtonAction:(id)sender
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Create/Join Session" message:@"Please create a new session, or join an active session" delegate:self cancelButtonTitle:@"Enter" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

-(IBAction)viewTextEditorAction:(id)sender
{
    if([[self isConnected] isEqualToString:@"false"])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please connect to a session first" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([[alertView buttonTitleAtIndex:0] isEqualToString:@"Enter"])
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
                 if(session != nil)
                 {
                     [self.client joinSessionWithID:[session sessionID]
                                      password:nil
                                  completionHandler:^(int64_t maxOrderID, int32_t baseFileSize, CollabrifyError *error)
                      {
                          if(!error)
                          {
                              [self setIsConnected:@"true"];
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
                              [self setIsConnected:@"true"];
                          }
                          else
                          {
                              NSLog(@"Failed to Create Session");
                          }
                      }];
                
                 }

             }
         }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"moveToTextEditor"])
    {
        [self setText:segue.destinationViewController];
        [self text].client = [self client];
        [self text].isConnected = [self isConnected];
        [self text].userName = [self userName];
        /*
        destASIView.limit = [self limit];
        destASIView.limit.client = [[self limit] client];
        destASIView.limit.text = [self limit].text;*/
    }
}
-(void) client:(CollabrifyClient *)client receivedEventWithOrderID:(int64_t)orderID submissionRegistrationID:(int32_t)submissionRegistrationID eventType:(NSString *)eventType data:(NSData *)data
{
    if(![eventType isEqualToString:[self userName]])
    {
        NSLog(@"I hear ya");
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[self text] limit]receiveEvent:data];
        });
    }
}

@end
