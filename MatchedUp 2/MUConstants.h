//
//  MUConstants.h
//  MatchedUp 2
//
//  Created by Donald Chan on 2/03/2014.
//  Copyright (c) 2014 iEndeavour. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUConstants : NSObject

#pragma mark - User Class
extern NSString *const kCCUserTagLineKey;

extern NSString *const kCCUserProfileKey;
extern NSString *const kCCUserProfileNameKey;
extern NSString *const kCCUserProfileFirstNameKey;
extern NSString *const kCCUserProfileLocationKey;
extern NSString *const kCCUserProfileGenderKey;
extern NSString *const kCCUserProfileBirthdayKey;
extern NSString *const kCCUserProfileInterestedInKey;
extern NSString *const kCCUserProfilePictureURL;
extern NSString *const kCCUserProfileRelationshipStatusKey;
extern NSString *const kCCUserProfileAgeKey;

#pragma mark - Photo Class
extern NSString *const kCCPhotoClassKey;
extern NSString *const kCCPhotoUserKey;
extern NSString *const kCCPhotoPictureKey;

#pragma mark - Activity Class
extern NSString *const kCCActivityClassKey;
extern NSString *const kCCActivityTypeKey;
extern NSString *const kCCActivityFromUserKey;
extern NSString *const kCCActivityToUserKey;
extern NSString *const kCCActivityPhotoKey;
extern NSString *const kCCActivityTypeLikeKey;
extern NSString *const kCCActivityTypeDislikeKey;

@end
