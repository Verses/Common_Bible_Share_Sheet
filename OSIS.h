//
//  OSIS.h
//  Verses
//
//  Created by Meph on 3/24/15.
//  Copyright (c) 2015 Verses. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Passage.h"
#import "Reference.h"
#import "DataHelper.h"

@interface OSIS : NSObject

- (instancetype)initFromPassage:(Passage*)passage;
- (instancetype)initFromReferences:(NSArray*)references;
- (instancetype)initFromString:(NSString*)string;
- (instancetype)initFromURL:(NSURL*)url;

- (void)addReferenceFromString:(NSString*)string;
- (void)addPassage:(Passage*)passage;

- (NSString *)stringValue;
- (NSArray *)passages;

- (NSURL *)URLwithIntent:(NSString*)intent andTranslation:(NSString*)translation;

@end