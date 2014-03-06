//
//  MUTestUser.m
//  MatchedUp 2
//
//  Created by Donald Chan on 2/03/2014.
//  Copyright (c) 2014 iEndeavour. All rights reserved.
//

#import "MUTestUser.h"

@implementation MUTestUser

+(void)saveTestUserToParse
{
    PFUser *newUser = [PFUser user];
    newUser.username = @"user2";
    newUser.password = @"password2";
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSDictionary *profile = @{kCCUserProfileAgeKey: @28, kCCUserProfileBirthdayKey: @"04/14/1988", kCCUserProfileFirstNameKey: @"Ellie", kCCUserProfileGenderKey: @"female", kCCUserProfileLocationKey: @"Queensland, Australia", kCCUserProfileNameKey: @"Ellie Gonsalves"};
            [newUser setObject:profile forKey:kCCUserProfileKey];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                UIImage *profileImage = [UIImage imageNamed:@"ellie_gonsalves.jpg"];
                NSData *imageData = UIImageJPEGRepresentation(profileImage, 0.8);
                PFFile *photoFile = [PFFile fileWithData:imageData];
                [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        PFObject *photo = [PFObject objectWithClassName:kCCPhotoClassKey];
                        [photo setObject:newUser forKey:kCCPhotoUserKey];
                        [photo setObject:photoFile forKey:kCCPhotoPictureKey];
                        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            NSLog(@"photo saved successfully");
                        }];
                    }
                }];
            }];
        }
    }];
    
    
}

@end
