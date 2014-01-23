//
//  AppDelegate.m
//  MoeFM
//
//  Created by Kroderia on 12/17/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize playerViewController;
@synthesize aboutPanelWindowController;

- (void)awakeFromNib {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"notFirstLaunch"];
    
    if ([self isFirstLaunch]) {
        [self initUserDefault];
    }
    
    self.statusItem = [[MoefmStatusItem alloc] init];
    [self.statusItem setMenu:self.statusMenu];

    self.moefmPlayer = [MoefmPlayer sharedInstance];
    
    self.playerViewController = [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
    [self.window setContentSize:self.playerViewController.view.frame.size];
    self.window.contentView = self.playerViewController.view;
    self.window.styleMask &= ~NSResizableWindowMask;
    
    NSPoint pos;
    NSRect screenFrame = [[NSScreen mainScreen] visibleFrame];
    pos.x = screenFrame.origin.x + screenFrame.size.width - self.window.frame.size.width;
    pos.y = screenFrame.origin.y + screenFrame.size.height - self.window.frame.size.height;
    [self.window setFrameOrigin: pos];
    NSLog(@"%f %f", self.window.frame.origin.x, self.window.frame.origin.y);
    
    self.isTop = [[NSUserDefaults standardUserDefaults] integerForKey:@"alwaysTop"];
    [self resetIsTop];
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


- (IBAction)showPreferencesPanel:(id)sender {
    if (self.preferencesPanelWindowController == nil) {
        self.preferencesPanelWindowController = [[PreferencesPanelWindowController alloc] initWithWindowNibName:@"PreferencesPanelWindowController"];
        self.preferencesPanelWindowController.window.styleMask &= ~NSResizableWindowMask;
    }
    
    [self.preferencesPanelWindowController.window center];
    [self.preferencesPanelWindowController showWindow:sender];
}

- (IBAction)showAboutPanel:(id)sender {
    if (self.aboutPanelWindowController == nil) {
        self.aboutPanelWindowController = [[AboutPanelWindowController alloc] initWithWindowNibName:@"AboutPanelWindowController"];
        self.aboutPanelWindowController.window.styleMask &= ~NSResizableWindowMask;
    }
    
    [self.aboutPanelWindowController.window center];
    [self.aboutPanelWindowController showWindow:sender];
}

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

- (IBAction)clickQuitBtn:(id)sender {
    [NSApp terminate: self];
}

- (IBAction)clickNextBtn:(id)sender {
    if (self.moefmPlayer.isLoading) {
        return;
    }
    
    [self.moefmPlayer playNextSong];
}

- (IBAction)clickTrashBtn:(id)sender {
    if ([self.moefmPlayer isTrashing] || [self.moefmPlayer isLoading]) {
        return;
    }
    
    if (! [MoefmApi isAuthorized]) {
        [self showUnauthorizeToActAlert];
        return;
    }
    
    [self.moefmPlayer addTrash];
}

- (IBAction)clickFavBtn:(id)sender {
    if ([self.moefmPlayer isFaving]) {
        return;
    }
    
    if (! [MoefmApi isAuthorized]) {
        [self showUnauthorizeToActAlert];
        return;
    }
    
    if ([self.moefmPlayer isFav]) {
        [self.moefmPlayer deleteFav];
    } else {
        [self.moefmPlayer addFav];
    }
}


- (IBAction)clickTopAction:(id)sender {
    self.isTop = ! self.isTop;
    [self resetIsTop];
}

- (IBAction)clickPlayBtn:(id)sender {
    MoefmPlayer *moefmPlayer = [MoefmPlayer sharedInstance];
    if (moefmPlayer.isPlaying) {
        [moefmPlayer pause];
    } else {
        [moefmPlayer play];
    }
}

- (void)resetIsTop {
    if (self.isTop == NSOffState) {
        [self.window setLevel:NSNormalWindowLevel];
        [[NSUserDefaults standardUserDefaults] setInteger:NSOffState forKey:@"alwaysTop"];
        self.isTop = NSOffState;
        [[self.statusMenu itemWithTitle:@"取消置顶"] setTitle:@"置顶"];
    } else {
        [self.window setLevel:NSFloatingWindowLevel];
        [[NSUserDefaults standardUserDefaults] setInteger:NSOnState forKey:@"alwaysTop"];
        self.isTop = NSOnState;
        [[self.statusMenu itemWithTitle:@"置顶"] setTitle:@"取消置顶"];
    }
}

- (void)showUnauthorizeToActAlert {
    NSAlert *alert = [NSAlert alertWithMessageText:@"当前尚未授权, 无法进行该操作. 先到偏好设置进行授权吧." defaultButton:@"你没机会的, 只能点我" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
    [alert runModal];
}


@end

















