//
//  BibleApp.h
//  Verses
//
//  Created by Zach Whelchel on 4/2/15.
//  Copyright (c) 2015 Verses. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonShareSheetHelper.h"

@interface BibleApp : NSObject

@property (nonatomic, strong) NSString *bibleAppId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *appStoreUrl;
@property (nonatomic, strong) NSString *sharedUrlScheme;
@property (nonatomic, strong) NSArray *supportedIntentions; // The first one is the most featured.

- (id)initWithBibleAppId:(NSString *)bibleAppId name:(NSString *)name appStoreUrl:(NSString *)appStoreUrl sharedUrlScheme:(NSString *)sharedUrlScheme supportedIntentions:(NSArray *)supportedIntentions;

@end
