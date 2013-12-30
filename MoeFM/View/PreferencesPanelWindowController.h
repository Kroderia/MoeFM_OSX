//
//  PreferencesWindowController.h
//  MoeFM
//
//  Created by Kroderia on 12/25/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DataNotifyReceiver.h"
#import "LoginWindowController.h"

@interface PreferencesPanelWindowController : NSWindowController<NSToolbarDelegate, DataNotifyReceiver>

@property int currentTag;

@property (weak) IBOutlet NSTabView *preferencesSwitchView;
@property (weak) IBOutlet NSToolbar *preferencesSwitcher;

@property (weak) IBOutlet NSButton *checkUseNotification;
@property (weak) IBOutlet NSButton *checkPresentNotification;

@property (weak) IBOutlet NSTextField *authorizeInfoLabel;
@property (weak) IBOutlet NSButton *doAuthorizeBtn;
@property (weak) IBOutlet NSButton *dismissAuthorizeBtn;

@property (strong) LoginWindowController *loginWindowController;

- (IBAction)didCheckUseNotification:(NSButton*)sender;
- (IBAction)didCheckPresentNotification:(NSButton *)sender;


- (IBAction)switchView:(NSToolbarItem*)sender;
- (IBAction)showLoginWindow:(id)sender;
- (IBAction)dismissAuthorize:(id)sender;


@end
