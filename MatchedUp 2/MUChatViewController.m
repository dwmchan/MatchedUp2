//
//  MUChatViewController.m
//  MatchedUp 2
//
//  Created by Donald Chan on 3/03/2014.
//  Copyright (c) 2014 iEndeavour. All rights reserved.
//

#import "MUChatViewController.h"

@interface MUChatViewController ()

@property (strong, nonatomic) PFUser *withUser;
@property (strong, nonatomic) PFUser *currentUser;

@property (strong, nonatomic) NSTimer *chatsTimer;
@property (nonatomic) BOOL initialLoadComplete;
@property (strong, nonatomic) NSMutableArray *chats;


@end

@implementation MUChatViewController

#pragma mark - Lazy Instantiation
-(NSMutableArray *)chats
{
    if (!_chats) {
        _chats = [[NSMutableArray alloc] init];
    }
    return _chats;
}

#pragma mark - Initial Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    // Setting self.delegate and self.dataSource above the [super] method we can get iOS7 UI rather than iOS6 UI if set below [super] method.
    
    self.delegate = self;
    self.dataSource = self;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.delegate = self;
//    self.dataSource = self;
    
    
    [[JSBubbleView appearance] setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0f]];
    self.messageInputView.textView.placeHolder = @"New Message";
    [self setBackgroundColor:[UIColor whiteColor]];
    self.currentUser = [PFUser currentUser];
    PFUser *testUser1 = self.chatRoom[kCCChatRoomUser1Key];
    if ([testUser1.objectId isEqual:self.currentUser.objectId]) {
        self.withUser = self.chatRoom[kCCChatRoomUser2Key];
    }
    else {
        self.withUser = self.chatRoom[kCCChatRoomUser1Key];
    }
    self.title = self.withUser[kCCUserProfileKey][kCCUserProfileFirstNameKey];
    self.initialLoadComplete = NO;
    
    [self checkForNewChats];
    self.chatsTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(checkForNewChats) userInfo:nil repeats:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.chatsTimer invalidate];
    self.chatsTimer = nil;
}

#pragma mark - TableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.chats count];
}

#pragma mark - TableViewDelegate
-(void)didSendText:(NSString *)text
{
    if (text.length != 0) {
        //Create Chat Class
        PFObject *chat = [PFObject objectWithClassName:kCCChatClassKey];
        [chat setObject:self.chatRoom forKey:kCCChatChatRoomKey];
        [chat setObject:self.currentUser forKey:kCCChatFromUserKey];
        [chat setObject:self.withUser forKey:kCCChatToUserKey];
        [chat setObject:text forKey:kCCChatTextKey];
        [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self.chats addObject:chat];
            [JSMessageSoundEffect playMessageSentSound];
            [self.tableView reloadData];
            [self finishSend];
            [self scrollToBottomAnimated:YES];
        }];
    }
}


-(JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chat = self.chats[indexPath.row];
    PFUser *testFromUser = chat[kCCChatFromUserKey];
    
    if ([testFromUser.objectId isEqual:self.currentUser.objectId]) {
        return JSBubbleMessageTypeOutgoing;
    }
    else {
        return JSBubbleMessageTypeIncoming;
    }
}

-(UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chat = self.chats[indexPath.row];
    PFUser *testFromUser = chat[kCCChatFromUserKey];
    
    if ([testFromUser.objectId isEqual:self.currentUser.objectId]) {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type color:[UIColor js_bubbleGreenColor]];
    }
    else {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type color:[UIColor js_bubbleLightGrayColor]];
    }
}

#pragma mark - Additional Methods

-(JSMessagesViewTimestampPolicy) timestampPolicy
{
    return JSMessagesViewTimestampPolicyAll;
}

-(JSMessagesViewAvatarPolicy) avatarPolicy
{
    return JSMessagesViewAvatarPolicyNone;
}

-(JSMessagesViewSubtitlePolicy)subtitlePolicy
{
    return JSMessagesViewSubtitlePolicyNone;
}

-(JSMessageInputViewStyle) inputViewStyle
{
    return JSMessageInputViewStyleFlat;
}


#pragma mark - Messages View Delegate OPTIONAL

-(void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell messageType] == JSBubbleMessageTypeOutgoing) {
        cell.bubbleView.textView.textColor = [UIColor whiteColor];
    }
}

-(BOOL)shouldPreventScrollToBottomWhileUserScrolling
{
    return YES;
}

#pragma mark - Messages View Data Source REQUIRED

-(NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chat = self.chats[indexPath.row];
    NSString *message = chat[kCCChatTextKey];
    return message;
}

-(NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(NSString *)subtitleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - Helper Methods
-(void) checkForNewChats
{
    int oldChatCount = [self.chats count];
    
    PFQuery *queryForChats = [PFQuery queryWithClassName:kCCChatClassKey];
    [queryForChats whereKey:kCCChatChatRoomKey equalTo:self.chatRoom];
    [queryForChats orderByAscending:@"createdAt"];
    [queryForChats findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (self.initialLoadComplete == NO || oldChatCount != [objects count]) {
                self.chats = [objects mutableCopy];
                [self.tableView reloadData];
                if (self.initialLoadComplete == YES) {
                    [JSMessageSoundEffect playMessageReceivedSound];
                }
                self.initialLoadComplete = YES;
                [self scrollToBottomAnimated:YES];
            }
        }
    }];
}






@end
