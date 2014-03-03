//
//  MUChatViewController.h
//  MatchedUp 2
//
//  Created by Donald Chan on 3/03/2014.
//  Copyright (c) 2014 iEndeavour. All rights reserved.
//

#import "JSMessagesViewController.h"

@interface MUChatViewController : JSMessagesViewController <JSMessagesViewDataSource, JSMessagesViewDelegate>

@property (strong, nonatomic) PFObject *chatRoom;

@end
