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
    self.checkUseNotification.state = [[NSUserDefaults standardUserDefaults] integerForKey:@"useNotification"];
}


- (IBAction)didCheckUseNotification:(NSButton *)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:sender.state forKey:@"useNotification"];
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


























