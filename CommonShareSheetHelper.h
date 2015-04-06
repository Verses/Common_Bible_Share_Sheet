//
//  CommonShareSheetHelper.h
//  Verses
//
//  Created by Zach Whelchel on 4/2/15.
//  Copyright (c) 2015 Verses. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OSIS.h"

typedef enum {
    ReadIntention = 0, // 📖
    StudyIntention, // 🎓
    MemorizeIntention, // ⚓️
    ListenIntention // 🎧
} ShareIntention;

@class CommonShareSheetHelper;

@protocol CommonShareSheetHelperDelegate

@required

- (void)commonShareSheetHelper:(CommonShareSheetHelper *)commonShareSheetHelper;

@end

@interface CommonShareSheetHelper : NSObject

@property (nonatomic, weak) id <CommonShareSheetHelperDelegate> delegate;

- (id)initWithDelegate:(id)delegate;

- (void)showShareSheetInViewController:(UIViewController *)viewController forOSIS:(OSIS *)osis;
- (void)showShareSheetInViewController:(UIViewController *)viewController forIntentions:(NSArray *)intentions forOSIS:(OSIS *)osis;
- (void)showShareSheetInViewController:(UIViewController *)viewController includeNonOwnedByUserAppIds:(NSArray *)featureAppIds forOSIS:(OSIS *)osis;
- (void)showShareSheetInViewController:(UIViewController *)viewController forIntentions:(NSArray *)intentions includeNonOwnedByUserAppIds:(NSArray *)featureAppIds forOSIS:(OSIS *)osis;

@end