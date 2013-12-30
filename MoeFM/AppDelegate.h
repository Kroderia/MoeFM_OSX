//
//  AppDelegate.h
//  MoeFM
//
//  Created by Kroderia on 12/17/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "PlayerViewController.h"
#import "AboutPanelWindowController.h"
#import "PreferencesPanelWindowController.h"
#import "MoefmPlayer.h"
#import "MoefmStatusItem.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

- (IBAction)showPreferencesPanel:(id)sender;
- (IBAction)showAboutPanel:(id)sender;

@property (strong) MoefmStatusItem *statusItem;
@property (weak) IBOutlet NSMenu *statusMenu;

@property (weak) MoefmPlayer *moefmPlayer;

@property (assign) IBOutlet NSWindow *window;
@property BOOL isTop;
@property (strong) PlayerViewController *playerViewController;
@property (strong) AboutPanelWindowController *aboutPanelWindowController;
@property (strong) PreferencesPanelWindowController *preferencesPanelWindowController;


- (IBAction)clickQuitBtn:(id)sender;
- (IBAction)clickNextBtn:(id)sender;
- (IBAction)clickFavBtn:(id)sender;
- (IBAction)clickTrashBtn:(id)sender;
- (IBAction)clickTopAction:(id)sender;
- (IBAction)clickPlayBtn:(id)sender;

@end
