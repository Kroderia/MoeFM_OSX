//
//  AppDelegate.h
//  MoeFM
//
//  Created by Kroderia on 12/17/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "PlayerWindowController.h"
#import "AboutPanelWindowController.h"
#import "PreferencesPanelWindowController.h"
#import "MoefmApi.h"
#import "MoefmPlayer.h"
#import "MoefmStatusItem.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    BOOL isTop;
    MoefmPlayer *moefmPlayer;
    MoefmStatusItem *statusItem;
    
    
    PlayerWindowController *playerWindowController;
    AboutPanelWindowController *aboutPanelWindowController;
    PreferencesPanelWindowController *preferencesPanelWindowController;
}

@property (weak) IBOutlet NSMenu *statusMenu;

- (IBAction)showPreferencesPanel:(id)sender;
- (IBAction)showAboutPanel:(id)sender;

- (IBAction)clickQuitBtn:(id)sender;
- (IBAction)clickNextBtn:(id)sender;
- (IBAction)clickFavBtn:(id)sender;
- (IBAction)clickTrashBtn:(id)sender;
- (IBAction)clickTopAction:(id)sender;
- (IBAction)clickPlayBtn:(id)sender;

@end
