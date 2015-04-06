//
//  CommonShareSheetHelper.m
//  Verses
//
//  Created by Zach Whelchel on 4/2/15.
//  Copyright (c) 2015 Verses. All rights reserved.
//

#import "CommonShareSheetHelper.h"
#import "BibleApp.h"

#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface CommonShareSheetHelper () <UIActionSheetDelegate>

@property (nonatomic, strong) NSArray *actions;
@property (nonatomic, strong) OSIS *osis;

@end

@implementation CommonShareSheetHelper

@synthesize delegate = _delegate;

- (id)initWithDelegate:(id)delegate
{
    self = [super init];
    if(self)
    {
        self.delegate = delegate;
    }
    return self;
}

- (void)showShareSheetInViewController:(UIViewController *)viewController forOSIS:(OSIS *)osis
{
    [self showShareSheetInViewController:viewController forIntentions:[CommonShareSheetHelper allIntentions] includeNonOwnedByUserAppIds:nil forOSIS:osis];
}

- (void)showShareSheetInViewController:(UIViewController *)viewController forIntentions:(NSArray *)intentions forOSIS:(OSIS *)osis
{
    [self showShareSheetInViewController:viewController forIntentions:intentions includeNonOwnedByUserAppIds:nil forOSIS:osis];
}

- (void)showShareSheetInViewController:(UIViewController *)viewController includeNonOwnedByUserAppIds:(NSArray *)featureAppIds forOSIS:(OSIS *)osis
{
    [self showShareSheetInViewController:viewController forIntentions:[CommonShareSheetHelper allIntentions] includeNonOwnedByUserAppIds:featureAppIds forOSIS:osis];
}

- (void)showShareSheetInViewController:(UIViewController *)viewController forIntentions:(NSArray *)intentions includeNonOwnedByUserAppIds:(NSArray *)featureAppIds forOSIS:(OSIS *)osis
{
    NSMutableArray *actions = [NSMutableArray array];
    
    for (BibleApp *bibleApp in [CommonShareSheetHelper supportedApps]) {
        
        NSLog(@"Looking at %@", bibleApp.name);
        
        for (NSNumber *intention in intentions) {
            
            NSLog(@"-%@", [CommonShareSheetHelper nameForIntention:intention]);
            
            if ([bibleApp.supportedIntentions indexOfObject:intention] != NSNotFound) {
                
                // This BibleApp has the desired intention... so now we validate the OS can open it.
                
                NSLog(@"Intention supported!");
                
                NSNumber *primarySupportedIntentionOurOfAvailableIntentions = [self primarySupportedIntentionForBibleApp:bibleApp inAvailableIntentions:intentions];
                
                NSLog(@"primary intention:%@", [CommonShareSheetHelper nameForIntention:primarySupportedIntentionOurOfAvailableIntentions]);
                
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:bibleApp.appStoreUrl]]) {
                    
                    // This BibleApp is owned by the user. So lets give them the option to share to the app.
                    
                    NSLog(@"Can open!");

                    [self addAction:[NSDictionary dictionaryWithObjectsAndKeys:@"share", @"action", primarySupportedIntentionOurOfAvailableIntentions, @"intention", bibleApp, @"bibleApp", [NSString stringWithFormat:@"%@ %@ %@", [CommonShareSheetHelper nameForIntention:primarySupportedIntentionOurOfAvailableIntentions], [CommonShareSheetHelper verbForIntention:primarySupportedIntentionOurOfAvailableIntentions], bibleApp.name], @"displayString", nil] toActionsIfUniqueBibleApp:actions];
                    
                }
                else if ([featureAppIds indexOfObject:bibleApp.bibleAppId] != NSNotFound) {
                    
                    // This BibleApp is not owned by the user... but we should show a link to get it from the App Store. No one Bible app is going to fully ace all of the intentions... so why not share the love? ❤️
                    
                    NSLog(@"Show app store!");
                    
                    [self addAction:[NSDictionary dictionaryWithObjectsAndKeys:@"appStore", @"action", primarySupportedIntentionOurOfAvailableIntentions, @"intention", bibleApp, @"bibleApp", [NSString stringWithFormat:@"Get %@ to %@", bibleApp.name, [[CommonShareSheetHelper nameForIntention:primarySupportedIntentionOurOfAvailableIntentions] lowercaseString]], @"displayString", nil] toActionsIfUniqueBibleApp:actions];
                }
                else {
                    
                    NSLog(@"Cant open and not featured!");
                    
                }
            }
        }
    }

    self.actions = actions;
    self.osis = osis;
    
    if (IS_OS_8_OR_LATER) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        for (NSDictionary *action in actions) {
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:[action valueForKey:@"displayString"] style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction *alertAction)
                                          {
                                              [self handleAction:action];
                                          }];
            
            [alertController addAction:alertAction];
        }
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *alertAction)
                                       {
                                           
                                       }];
        
        [alertController addAction:cancelAction];

        [viewController presentViewController:alertController animated:YES completion:nil];
    
    }
    else {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        for (NSDictionary *action in actions) {
            [actionSheet addButtonWithTitle:[action valueForKey:@"displayString"]];
        }
        
        actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
        
        [actionSheet showInView:viewController.view];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSDictionary *action = [self.actions objectAtIndex:buttonIndex];
    [self handleAction:action];
}

- (void)addAction:(NSDictionary *)action toActionsIfUniqueBibleApp:(NSMutableArray *)actions
{
    BibleApp *bibleApp = [action valueForKey:@"bibleApp"];
    
    BOOL sameBibleAppFound = NO;
    
    for (NSDictionary *anAction in actions) {
        BibleApp *aBibleApp = [anAction valueForKey:@"bibleApp"];
        if ([bibleApp.bibleAppId isEqualToString:aBibleApp.bibleAppId]) {
            sameBibleAppFound = YES;
        }
    }
    
    if (!sameBibleAppFound) {
        [actions addObject:action];
    }
}

- (NSNumber *)primarySupportedIntentionForBibleApp:(BibleApp *)bibleApp inAvailableIntentions:(NSArray *)availableIntentions
{
    for (NSNumber *intention in bibleApp.supportedIntentions) {
        if ([availableIntentions indexOfObject:intention] != NSNotFound) {
            return intention;
        }
    }
    return nil;
}

- (void)handleAction:(NSDictionary *)action
{
    BibleApp *bibleApp = [action valueForKey:@"bibleApp"];
    
    if ([[action valueForKey:@"action"] isEqualToString:@"appStore"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:bibleApp.appStoreUrl]];
    }
    else if ([[action valueForKey:@"action"] isEqualToString:@"share"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/?%@", bibleApp.sharedUrlScheme, self.osis]]];
    }
}

+ (NSArray *)supportedApps
{
    NSMutableArray *supportedApps = [NSMutableArray array];
    
    [supportedApps addObject:[[BibleApp alloc] initWithBibleAppId:@"1" name:@"Verses" appStoreUrl:@"itms://itunes.apple.com/us/app/verses-bible-memory/id939461663?ls=1&mt=8" sharedUrlScheme:@"bible-verses://" supportedIntentions:[NSArray arrayWithObjects:[NSNumber numberWithInt:MemorizeIntention], nil]]];
    
    [supportedApps addObject:[[BibleApp alloc] initWithBibleAppId:@"2" name:@"ESV" appStoreUrl:@"itms://itunes.apple.com/us/app/esv-bible/id361797273?mt=8" sharedUrlScheme:@"bible-esv://" supportedIntentions:[NSArray arrayWithObjects:[NSNumber numberWithInt:ReadIntention], [NSNumber numberWithInt:StudyIntention], nil]]];
    
    [supportedApps addObject:[[BibleApp alloc] initWithBibleAppId:@"3" name:@"OliveTree" appStoreUrl:@"itms://itunes.apple.com/us/app/bible+/id332615624?mt=8" sharedUrlScheme:@"bible-olivetree://" supportedIntentions:[NSArray arrayWithObjects:[NSNumber numberWithInt:StudyIntention], [NSNumber numberWithInt:ReadIntention], nil]]];

    // 👆 To add support to your app simply duplicate a line above with your appropriate information. Need an id?
    
    return supportedApps;
}

+ (NSArray *)allIntentions
{
    // 📖, 🎓, ⚓️, 🎧 Want to add a new intention? Post your idea as an issue on the Github repo.

    return [NSArray arrayWithObjects:[NSNumber numberWithInt:ReadIntention], [NSNumber numberWithInt:StudyIntention], [NSNumber numberWithInt:MemorizeIntention], [NSNumber numberWithInt:ListenIntention], nil];
}

+ (NSString *)nameForIntention:(NSNumber *)intention
{
    if ([intention intValue] == ReadIntention) {
        return @"Read";
    }
    else if ([intention intValue] == StudyIntention) {
        return @"Study";
    }
    else if ([intention intValue] == MemorizeIntention) {
        return @"Memorize";
    }
    else if ([intention intValue] == ListenIntention) {
        return @"Listen";
    }
    return nil;
}

+ (NSString *)verbForIntention:(NSNumber *)intention
{
    if ([intention intValue] == ReadIntention) {
        return @"in";
    }
    else if ([intention intValue] == StudyIntention) {
        return @"with";
    }
    else if ([intention intValue] == MemorizeIntention) {
        return @"using";
    }
    else if ([intention intValue] == ListenIntention) {
        return @"via";
    }
    return nil;
}

@end