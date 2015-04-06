//
//  BibleApp.m
//  Verses
//
//  Created by Zach Whelchel on 4/2/15.
//  Copyright (c) 2015 Verses. All rights reserved.
//

#import "BibleApp.h"

@implementation BibleApp

@synthesize bibleAppId = _bibleAppId;
@synthesize name = _name;
@synthesize appStoreUrl = _appStoreUrl;
@synthesize sharedUrlScheme = _sharedUrlScheme;
@synthesize supportedIntentions = _supportedIntentions;

- (id)initWithBibleAppId:(NSString *)bibleAppId name:(NSString *)name appStoreUrl:(NSString *)appStoreUrl sharedUrlScheme:(NSString *)sharedUrlScheme supportedIntentions:(NSArray *)supportedIntentions
{
    self = [super init];
    if(self)
    {
        self.bibleAppId = bibleAppId;
        self.name = name;
        self.appStoreUrl = appStoreUrl;
        self.sharedUrlScheme = sharedUrlScheme;
        self.supportedIntentions = supportedIntentions;
    }
    return self;
}

@end