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

- (void)recvData: (id)data {
    [self.loginWindowController close];
    [self resetAuthorizeButton];
}

- (void)awakeFromNib {
    [self initUserPreferencesCheck];
    
    NSToolbarItem *item = (NSToolbarItem*)[[self.preferencesSwitcher items] objectAtIndex:0];
    [self.preferencesSwitcher setSelectedItemIdentifier:item.itemIdentifier];
    currentTag = item.tag;
    
    [self resetAuthorizeButton];
}

- (void)showWindow:(id)sender {
    [super showWindow:sender];
    [self resetAuthorizeButton];
}

- (void)resetAuthorizeButton {
    if ([MoefmApi isAuthorized]) {
        [self.doAuthorizeBtn setEnabled:NO];
        [self.dismissAuthorizeBtn setEnabled:YES];
        self.authorizeInfoLabel.stringValue = @"当前已授权";
    } else {
        [self.doAuthorizeBtn setEnabled:YES];
        [self.dismissAuthorizeBtn setEnabled:NO];
        self.authorizeInfoLabel.stringValue = @"当前未授权";
    }
}


- (void)initUserPreferencesCheck {
    self.checkUseNotification.state = [[NSUserDefaults standardUserDefaults] integerForKey:@"useNotification"];
}


- (IBAction)didCheckUseLogListen:(NSButton*)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:sender.state forKey:@"useLogListen"];
}

- (IBAction)didCheckUseNotification:(NSButton *)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:sender.state forKey:@"useNotification"];
}

- (IBAction)switchView:(NSToolbarItem*)sender {
    if (sender.tag == currentTag) {
        return;
    }
    
    [self.preferencesSwitchView selectTabViewItemAtIndex:sender.tag];
    currentTag = sender.tag;
}

- (IBAction)showLoginWindow:(id)sender {
    self.loginWindowController = [[LoginWindowController alloc] initWithWindowNibName:@"LoginWindowController"];
    self.loginWindowController.receiver = self;
    self.loginWindowController.window.styleMask &= ~NSResizableWindowMask;
    [self.loginWindowController.window center];
    [self.loginWindowController showWindow:self];
}

- (IBAction)dismissAuthorize:(id)sender {
    [MoefmApi clearAuthorized];
    [self resetAuthorizeButton];
}

@end


























