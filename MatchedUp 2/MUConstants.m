//
//  MUConstants.m
//  MatchedUp 2
//
//  Created by Donald Chan on 2/03/2014.
//  Copyright (c) 2014 iEndeavour. All rights reserved.
//

#import "MUConstants.h"

@implementation MUConstants
#pragma mark - User Class
NSString *const kCCUserTagLineKey                       =@"tagLine";

NSString *const kCCUserProfileKey                       = @"profile";
NSString *const kCCUserProfileNameKey                   = @"name";
NSString *const kCCUserProfileFirstNameKey              = @"firstName";
NSString *const kCCUserProfileLocationKey               = @"location";
NSString *const kCCUserProfileGenderKey                 = @"gender";
NSString *const kCCUserProfileBirthdayKey               = @"birthday";
NSString *const kCCUserProfileInterestedInKey           = @"interested_in";
NSString *const kCCUserProfilePictureURL                = @"pictureURL";
NSString *const kCCUserProfileRelationshipStatusKey     = @"relationship_status";
NSString *const kCCUserProfileAgeKey                    = @"age";

#pragma mark - Photo Class
NSString *const kCCPhotoClassKey                        = @"Photo";
NSString *const kCCPhotoUserKey                         = @"user";
NSString *const kCCPhotoPictureKey                      = @"image";

#pragma  mark - Activity Class
NSString *const kCCActivityClassKey                     =@"Activity";
NSString *const kCCActivityTypeKey                      =@"type";
NSString *const kCCActivityFromUserKey                  =@"fromUser";
NSString *const kCCActivityToUserKey                    =@"toUser";
NSString *const kCCActivityPhotoKey                     =@"photo";
NSString *const kCCActivityTypeLikeKey                  =@"like";
NSString *const kCCActivityTypeDislikeKey               =@"dislike";

#pragma mark - Settings
NSString *const kCCMenEnabledKey                       =@"men";
NSString *const kCCWomenEnabledKey                     =@"women";
NSString *const kCCSingleEnabledKey                    =@"single";
NSString *const kCCAgeMaxKey                           =@"ageMax";



@end
