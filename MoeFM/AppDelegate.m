//
//  AppDelegate.m
//  MoeFM
//
//  Created by Kroderia on 12/17/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate


//==========================================
// Override
- (void)awakeFromNib {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"notFirstLaunch"];
    
    if ([self isFirstLaunch]) {
        [self initUserDefault];
    }
    
    statusItem = [[MoefmStatusItem alloc] init];
    [statusItem setMenu:self.statusMenu];

    moefmPlayer = [MoefmPlayer sharedInstance];
    
    playerViewController = [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
    [self.window setContentSize:playerViewController.view.frame.size];
    self.window.contentView = playerViewController.view;
    self.window.styleMask &= ~NSResizableWindowMask;
    
    NSPoint pos;
    NSRect screenFrame = [[NSScreen mainScreen] visibleFrame];
    CGSize windowSize = self.window.frame.size;
    pos.x = screenFrame.origin.x + screenFrame.size.width - windowSize.width;
    pos.y = screenFrame.origin.y + screenFrame.size.height - windowSize.height;
    [self.window setFrameOrigin: pos];
    
    [self setIsTop:[[NSUserDefaults standardUserDefaults] integerForKey:@"alwaysTop"]];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    if (flag) {
        [self.window orderFront:self];
    } else {
        [self.window makeKeyAndOrderFront:self];
    }
    
    return YES;
}


//==========================================
// Show window
- (IBAction)showPreferencesPanel:(id)sender {
    if (preferencesPanelWindowController == nil) {
        preferencesPanelWindowController = [[PreferencesPanelWindowController alloc] initWithWindowNibName:@"PreferencesPanelWindowController"];
        preferencesPanelWindowController.window.styleMask &= ~NSResizableWindowMask;
    }
    
    [preferencesPanelWindowController.window center];
    [preferencesPanelWindowController showWindow:sender];
}

- (IBAction)showAboutPanel:(id)sender {
    if (aboutPanelWindowController == nil) {
        aboutPanelWindowController = [[AboutPanelWindowController alloc] initWithWindowNibName:@"AboutPanelWindowController"];
        aboutPanelWindowController.window.styleMask &= ~NSResizableWindowMask;
    }
    
    [aboutPanelWindowController.window center];
    [aboutPanelWindowController showWindow:sender];
}

//==========================================
// Launch state
- (BOOL)isFirstLaunch {
    BOOL state = [[NSUserDefaults standardUserDefaults] boolForKey:@"notFirstLaunch"];
    
    return ! state;
}

- (void)initUserDefault {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setInteger:NSOnState forKey:@"useNotification"];
    [ud setInteger:NSOnState forKey:@"useLogListen"];
    [ud setInteger:NSOffState forKey:@"alwaysTop"];
    [ud setBool:YES forKey:@"notFirstLaunch"];
}

//==========================================
// Click action
- (IBAction)clickQuitBtn:(id)sender {
    [NSApp terminate: self];
}

- (IBAction)clickNextBtn:(id)sender {
    if (moefmPlayer.isLoading) {
        return;
    }
    
    [moefmPlayer playNextSong];
}

- (IBAction)clickFavBtn:(id)sender {
    if (moefmPlayer.isFaving) {
        return;
    }
    
    if (! MoefmApi.isAuthorized) {
        [self showUnauthorizeToActAlert];
        return;
    }
    
    if (moefmPlayer.isFav) {
        [moefmPlayer deleteFav];
    } else {
        [moefmPlayer addFav];
    }
}

- (IBAction)clickTrashBtn:(id)sender {
    if (moefmPlayer.isTrashing || moefmPlayer.isLoading) {
        return;
    }
    
    if (! MoefmApi.isAuthorized) {
        [self showUnauthorizeToActAlert];
        return;
    }
    
    [moefmPlayer addTrash];
}

- (IBAction)clickTopAction:(id)sender {
    [self setIsTop:(! isTop)];
}

- (IBAction)clickPlayBtn:(id)sender {
    if (moefmPlayer.isPlaying) {
        [moefmPlayer pause];
    } else {
        [moefmPlayer play];
    }
}

//==========================================
// Window top
- (void)setIsTop: (BOOL)state {
    isTop = state;
    
    if (isTop == NSOffState) {
        [self.window setLevel:NSNormalWindowLevel];
        [[NSUserDefaults standardUserDefaults] setInteger:NSOffState forKey:@"alwaysTop"];
        isTop = NSOffState;
        [[self.statusMenu itemWithTitle:@"取消置顶"] setTitle:@"置顶"];
    } else {
        [self.window setLevel:NSFloatingWindowLevel];
        [[NSUserDefaults standardUserDefaults] setInteger:NSOnState forKey:@"alwaysTop"];
        isTop = NSOnState;
        [[self.statusMenu itemWithTitle:@"置顶"] setTitle:@"取消置顶"];
    }
}

- (void)showUnauthorizeToActAlert {
    NSAlert *alert = [NSAlert alertWithMessageText:@"当前尚未授权, 无法进行该操作. 先到偏好设置进行授权吧." defaultButton:@"你没机会的, 只能点我" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
    [alert runModal];
}


@end

















