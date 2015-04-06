//
//  OSIS.m
//  Verses
//
//  Created by Meph on 3/24/15.
//  Copyright (c) 2015 Verses. All rights reserved.
//

#import "OSIS.h"

@interface OSIS()

-(NSArray *)convertArrayOfStringsToNumbers:(NSArray *)strings;

@property NSArray *books;

/**
 * Intermediary representation of all references
 * in (0.0.0) format
 *
 **/
@property NSMutableArray *refs;

@end

@implementation OSIS

#pragma mark Initializers
- (instancetype) init {
    self = [super init];
    if (self) {
        self.books = @[
                       @"Gen",
                       @"Exod",
                       @"Lev",
                       @"Num",
                       @"Deut",
                       @"Josh",
                       @"Judg",
                       @"Ruth",
                       @"1Sam",
                       @"2Sam",
                       @"1Kgs",
                       @"2Kgs",
                       @"1Chr",
                       @"2Chr",
                       @"Ezra",
                       @"Neh",
                       @"Esth",
                       @"Job",
                       @"Ps",
                       @"Prov",
                       @"Eccl",
                       @"Song",
                       @"Isa",
                       @"Jer",
                       @"Lam",
                       @"Ezek",
                       @"Dan",
                       @"Hos",
                       @"Joel",
                       @"Amos",
                       @"Obad",
                       @"Jonah",
                       @"Mic",
                       @"Nah",
                       @"Hab",
                       @"Zeph",
                       @"Hag",
                       @"Zech",
                       @"Mal",
                       @"Matt",
                       @"Mark",
                       @"Luke",
                       @"John",
                       @"Acts",
                       @"Rom",
                       @"1Cor",
                       @"2Cor",
                       @"Gal",
                       @"Eph",
                       @"Phil",
                       @"Col",
                       @"1Thess",
                       @"2Thess",
                       @"1Tim",
                       @"2Tim",
                       @"Titus",
                       @"Phlm",
                       @"Heb",
                       @"Jas",
                       @"1Pet",
                       @"2Pet",
                       @"1John",
                       @"2John",
                       @"3John",
                       @"Jude",
                       @"Rev",
                       ];
        self.refs = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (instancetype)initFromURL:(NSURL *)url {
    self = [self init];
    if (self) {
        
        NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
        
        NSArray *qItems = components.queryItems;
        
        NSLog(@"passages %@", qItems);
        
        NSString *qPass = [[qItems firstObject] valueForKey:@"value"];
        
        self.refs = [[self refsFromQueryString:qPass] mutableCopy];
    }
    
    return self;
}

- (instancetype)initFromString:(NSString *)string {
    self = [self init];
    if (self) {
        [self.refs addObject:[NSArray arrayWithObject:string]];
    }
    return self;
}

- (instancetype)initFromPassage:(Passage *)passage {
    self = [self initFromReferences:passage.references];
    if (self) {
        
    }
    
    return self;
}


- (instancetype)initFromReferences:(NSArray *)references {
    self = [self init];
    if (self) {
        [self addReferences:references];
    }
    return self;
    
}

#pragma mark Mutators
- (void)addReferences:(NSArray *)references {
    NSMutableArray *refArray = [[NSMutableArray alloc] init];
    for (Reference *ref in references) {
        
        NSMutableString *stringRef = [[NSMutableString alloc] initWithFormat:@"%@.%@.%@",
                                      [ref.indexes firstObject],
                                      [ref.indexes objectAtIndex:1],
                                      [ref.indexes lastObject]];
        [refArray addObject:stringRef];
    }
    [self.refs addObject:refArray];
}

- (void)addReferenceFromString:(NSString *)string
{
    [self.refs addObject:[NSArray arrayWithObject:string]];
}

- (void)addPassage:(Passage *)passage
{
    [self addReferences:passage.references];
}


#pragma mark Translation

- (NSString *) stringValue {
    
    if ([self.refs count] == 0) {
        return nil;
    } else {
        NSMutableString *totalReferenceString = [[NSMutableString alloc] init];
        for (int i=0; i<[self.refs count]; i++) {
            NSArray *ref = [self.refs objectAtIndex:i];
            
            if (ref) {
                // iterate over every one and see if they are sequential
                
                // save the book and chapter for later
                NSArray *bookChapterVerse = [[ref firstObject] componentsSeparatedByString:@"."];
                NSArray *bookChapter = [NSArray arrayWithObjects:[bookChapterVerse firstObject],
                                        [bookChapterVerse objectAtIndex:1],
                                        nil];
                
                __block NSMutableArray *verseValues = [[NSMutableArray alloc] init];
                [ref enumerateObjectsUsingBlock:^(NSString *trip, NSUInteger idx, BOOL *stop) {
                    NSArray *parts = [trip componentsSeparatedByString:@"."];
                    [verseValues addObject:[parts lastObject]];
                }];
                
                // gather sequential series of verses into 2d array
                
                NSMutableArray *gatheredSeqVerses = [[NSMutableArray alloc] init];
                NSMutableString *prevV = nil;
                
                NSMutableArray *collector = [[NSMutableArray alloc] init];
                
                for (int idx=0; idx < [verseValues count]; idx++) {
                    NSString *v = [verseValues objectAtIndex:idx];
                    if (prevV) {
                        if (([prevV intValue] + 1) == [v intValue]) {
                            // add the first value
                            if ([collector count] < 1) {
                                [collector addObject:prevV];
                            }
                            // add sequential
                            [collector addObject:v];
                        } else {
                            // reinitialize
                            if ([collector count] > 0) {
                                [gatheredSeqVerses addObject:collector];
                            }
                            collector = [[NSMutableArray alloc] init];
                            
                            [collector addObject:v];
                        }
                    }
                    
                    prevV = [v mutableCopy];
                    
                    // we are at the end, add last match
                    if (idx == [verseValues count]-1) {
                        [gatheredSeqVerses addObject:collector];
                    }
                }
                
                // build string for this ref
                NSMutableString *refString = [[NSMutableString alloc] init];
                NSString *book = [self.books objectAtIndex:[[bookChapter firstObject] intValue]];
                int chapter = [[bookChapter lastObject] intValue] + 1;
                
                for (NSArray *sequence in gatheredSeqVerses) {
                    if ([sequence count] > 1) {
                        [refString appendFormat:@"%@.%d.%d-%@.%d.%d,",
                         book,
                         chapter,
                         [[sequence firstObject] intValue] + 1,
                         book,
                         chapter,
                         [[sequence lastObject] intValue] + 1];
                    } else {
                        [refString appendFormat:@"%@.%d.%d,",
                         book,
                         chapter,
                         [[sequence firstObject] intValue] + 1];
                    }
                }
                //strip trailing comma
                refString = [[refString substringToIndex:[refString length] -1] mutableCopy];
                
                [totalReferenceString appendFormat:@"[%@],", refString];
                
            }
            
        }
        
        totalReferenceString = [[totalReferenceString substringToIndex:[totalReferenceString length]-1] mutableCopy];
        return totalReferenceString;
    }
}

- (NSArray *)passages
{
    if (!self.refs) {
        return nil;
    }else {
        NSMutableArray *passages = [[NSMutableArray alloc] init];
        
        for (NSArray *ref in self.refs) {
            [passages addObject: [[Passage alloc] initWithReferences:ref contentSource:[DataHelper sharedDataHelper].contentSource]];
        }
        
        return passages;
    }
    
}

- (NSURL *)URLwithIntent:(NSString *)intent andTranslation:(NSString *)translation
{
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"bible-verses";
    components.host = intent;
    
    NSURLQueryItem *passages = [NSURLQueryItem queryItemWithName:@"passages" value: [self stringValue]];
    NSURLQueryItem *trans = [NSURLQueryItem queryItemWithName:@"translation" value: translation];
    components.queryItems = @[ passages, trans ];
    
    return components.URL;
}

#pragma mark Internal Utility

- (NSArray *)refsFromQueryString:(NSString *)string
{
    NSError *e;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\[.*?\\])" options:NSRegularExpressionCaseInsensitive error:&e];
    
    NSRange range = NSMakeRange(0, string.length);
    
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:range];
    
    __block NSMutableArray *matchesStrings = [[NSMutableArray alloc] init];
    [matches enumerateObjectsUsingBlock:^(NSTextCheckingResult *result, NSUInteger idx, BOOL *stop) {
        NSString *match = [string substringWithRange:result.range];
        [matchesStrings addObject:match];
    }];
    
    // split up each passage string into references
    
    NSArray *fullyExpandedReferences = [self convertArrayOfURLStringsToReferenceIndexes:matchesStrings];
    
    return fullyExpandedReferences;
    
}

- (NSArray *)trimAndSplitPassageStrings:(NSArray *)passageStrings{
    NSCharacterSet *commaSet = [NSCharacterSet characterSetWithCharactersInString:@","];
    NSCharacterSet *bracketSet = [NSCharacterSet characterSetWithCharactersInString:@"[]"];
    NSMutableArray *referenceStrings = [[NSMutableArray alloc] init];
    
    for (NSString *passageString in passageStrings) {
        
        NSString *trimmedString = [passageString stringByTrimmingCharactersInSet:bracketSet];
        if ([trimmedString rangeOfCharacterFromSet:commaSet].location != NSNotFound) {
            // we have multiple verses
            NSArray *referenceVerses = [trimmedString componentsSeparatedByString:@","];
            NSMutableArray *splitReferenceVerses = [[NSMutableArray alloc] init];
            for (NSString *referenceString in referenceVerses) {
                [splitReferenceVerses addObject:referenceString];
            }
            [referenceStrings addObject:splitReferenceVerses];
        } else {
            [referenceStrings addObject: [NSArray arrayWithObject: trimmedString]
             ];
        }
    }
    
    return referenceStrings;
}

-(NSArray *)expandAndSeparateURLStrings:(NSArray *)splitPassageStrings {
    
    NSCharacterSet *dashSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    
    NSMutableArray *expandedAndSeparatedURLStrings = [[NSMutableArray alloc] init];
    
    for (NSString *passageString in splitPassageStrings) {
        if ([passageString rangeOfCharacterFromSet:dashSet].location != NSNotFound) {
            // we have a range
            NSArray *verses = [passageString componentsSeparatedByString:@"-"];
            NSString *firstVerse = [verses firstObject];
            NSString *lastVerse = [verses lastObject];
            
            NSArray *firstVerseParts = [firstVerse componentsSeparatedByString:@"."];
            NSArray *lastVerseParts = [lastVerse componentsSeparatedByString:@"."];
            
            NSString *firstVerseNum = [firstVerseParts lastObject];
            NSString *lastVerseNum = [lastVerseParts lastObject];
            
            NSString *book = [firstVerseParts firstObject];
            NSString *chapter = [firstVerseParts objectAtIndex:1];
            
            
            NSRange versesRange = NSMakeRange(firstVerseNum.integerValue, lastVerseNum.integerValue - firstVerseNum.integerValue);
            
            // rebuild range with fully qualified base level references for each verse
            
            for (NSUInteger idx = versesRange.location; idx <= versesRange.location + versesRange.length; idx++) {
                [expandedAndSeparatedURLStrings addObject:[NSString stringWithFormat:@"%@.%@.%lu", book, chapter, (unsigned long)idx]];
            }
        } else {
            [expandedAndSeparatedURLStrings addObject:passageString];
        }
    }
    return expandedAndSeparatedURLStrings;
}

- (NSArray *)translateArrayofOSISRefs:(NSArray *)OSISRefs
{
    NSMutableArray *translatedRefs = [[NSMutableArray alloc] init];
    
    for (NSString *OSISRef in OSISRefs) {
        NSArray *refParts = [OSISRef componentsSeparatedByString:@"."];
        [translatedRefs addObject: [NSString stringWithFormat:@"%lu.%@.%@",
                                   (unsigned long)[self.books indexOfObject: [refParts firstObject]],
                                   [refParts objectAtIndex: 1],
                                   [refParts lastObject]]];
    }
    return translatedRefs;
}

- (NSArray *)convertArrayOfURLStringsToReferenceIndexes:(NSArray *)URLStrings {
    
    NSArray *splitPassageStrings = [self trimAndSplitPassageStrings:URLStrings];
    
    NSMutableArray *expandedPassageStringsSets = [[NSMutableArray alloc] init];
    for (NSArray *passageStringsSet in splitPassageStrings) {
        [expandedPassageStringsSets addObject: [self expandAndSeparateURLStrings:passageStringsSet]];
    }
    
    NSMutableArray *expandedAndTranslatedPassageStringsSets = [[NSMutableArray alloc] init];
    for (NSArray *expandedPassageStringsSet in expandedPassageStringsSets) {
        [expandedAndTranslatedPassageStringsSets addObject: [self translateArrayofOSISRefs:expandedPassageStringsSet]];
    }
    
    return expandedAndTranslatedPassageStringsSets;
    
}

/** Maybe implement as category on NSString? **/
-(NSArray *) convertArrayOfStringsToNumbers:(NSArray *)strings {
    
    NSMutableArray *ints = [[NSMutableArray alloc] init];
    
    for (NSString *string in strings) {
        
        [ints addObject:[NSNumber numberWithInteger:string.integerValue]];
    }
    return ints;
}

@end