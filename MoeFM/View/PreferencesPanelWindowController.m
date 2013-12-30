//
//  PreferencesWindowController.m
//  MoeFM
//
//  Created by Kroderia on 12/25/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import "PreferencesPanelWindowController.h"

@interface PreferencesPanelWindowController ()

@end

@implementation PreferencesPanelWindowController

@synthesize currentTag;

- (void)recvData: (id)data {
    [self.loginWindowController close];
    [self resetAuthorizeButton];
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    
    if (self) {
    }
    
    return self;
}

- (void)awakeFromNib {
    [self initUserPreferencesCheck];
    
    NSToolbarItem *item = (NSToolbarItem*)[[self.preferencesSwitcher items] objectAtIndex:0];
    [self.preferencesSwitcher setSelectedItemIdentifier:item.itemIdentifier];
    self.currentTag = item.tag;
    
    [self resetAuthorizeButton];
}


- (void)resetAuthorizeButton {
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"] == nil) {
        [self.doAuthorizeBtn setEnabled:YES];
        [self.dismissAuthorizeBtn setEnabled:NO];
        self.authorizeInfoLabel.stringValue = @"当前未授权";
    } else {
        [self.doAuthorizeBtn setEnabled:NO];
        [self.dismissAuthorizeBtn setEnabled:YES];
        self.authorizeInfoLabel.stringValue = @"当前已授权";
    }
}


- (void)initUserPreferencesCheck {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    self.checkUseNotification.state = [ud integerForKey:@"useNotification"];
    self.checkPresentNotification.state = [ud integerForKey:@"presentNotification"];
    if (self.checkUseNotification.state == NSOffState) {
        [self.checkPresentNotification setEnabled:NO];
    }
}


- (IBAction)didCheckUseNotification:(NSButton *)sender {
    if (sender.state == NSOffState) {
        [self.checkPresentNotification setState:NSOffState];
        [self.checkPresentNotification setEnabled:NO];
        [[NSUserDefaults standardUserDefaults] setInteger:NSOffState forKey:@"presentNotification"];
    } else {
        [self.checkPresentNotification setEnabled:YES];
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:sender.state forKey:@"useNotification"];
}

- (IBAction)didCheckPresentNotification:(NSButton *)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:sender.state forKey:@"presentNotification"];
}

- (IBAction)switchView:(NSToolbarItem*)sender {
    if (sender.tag == self.currentTag) {
        return;
    }
    
    [self.preferencesSwitchView selectTabViewItemAtIndex:sender.tag];
    self.currentTag = sender.tag;
}

- (IBAction)showLoginWindow:(id)sender {
    self.loginWindowController = [[LoginWindowController alloc] initWithWindowNibName:@"LoginWindowController"];
    self.loginWindowController.receiver = self;
    self.loginWindowController.window.styleMask &= ~NSResizableWindowMask;
    [self.loginWindowController showWindow:self];
    
    [self.loginWindowController.window center];
}

- (IBAction)dismissAuthorize:(id)sender {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"accessToken"];
    [ud removeObjectForKey:@"accessTokenSecret"];
    
    [self resetAuthorizeButton];
}

@end


























