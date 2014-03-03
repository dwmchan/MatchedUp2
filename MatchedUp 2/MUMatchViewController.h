//
//  MUMatchViewController.h
//  MatchedUp 2
//
//  Created by Donald Chan on 3/03/2014.
//  Copyright (c) 2014 iEndeavour. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MUMatchViewControllerDelegate <NSObject>

-(void) presentMatchesViewController;

@end

@interface MUMatchViewController : UIViewController

@property (strong, nonatomic) UIImage *matchedUserImage;

@property (weak) id <MUMatchViewControllerDelegate> delegate;



@end
