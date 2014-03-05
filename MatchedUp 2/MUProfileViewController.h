//
//  MUProfileViewController.h
//  MatchedUp 2
//
//  Created by Donald Chan on 2/03/2014.
//  Copyright (c) 2014 iEndeavour. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MUProfileViewControllerDelegate <NSObject>

-(void) didPressLike;
-(void) didPressDislike;

@end

@interface MUProfileViewController : UIViewController

@property (strong, nonatomic) PFObject *photo;

@property (weak, nonatomic) id <MUProfileViewControllerDelegate> delegate;

@end
