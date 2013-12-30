//
//  PlayerViewController.h
//  MoeFM
//
//  Created by Kroderia on 12/17/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>
#import "MoefmPlayer.h"
#import "SongProgressBar.h"
#import "EasyNotification.h"
#import "ScrollTextView.h"

@interface PlayerViewController : NSViewController<MoefmPlayerDelegate>

@property (weak) IBOutlet ScrollTextView *songTitleText;
@property (weak) IBOutlet ScrollTextView *songAlbumText;
@property (weak) IBOutlet NSImageView *songCoverImageView;
@property (weak) IBOutlet SongProgressBar *songProgressBar;
@property (weak) IBOutlet NSTextField *songProgressTimer;

@property (weak) IBOutlet NSButton *favBtn;
@property (weak) IBOutlet NSButton *playBtn;
@property (weak) IBOutlet NSButton *trashBtn;
@property (weak) IBOutlet NSButton *nextBtn;
- (IBAction)clickPlayBtn:(id)sender;
- (IBAction)clickNextBtn:(id)sender;
- (IBAction)clickTrashBtn:(id)sender;
- (IBAction)clickFavBtn:(id)sender;

@property (strong) NSImage *songCoverDefault;
@property (strong) NSImage *songCoverImage;
@property (weak) MoefmPlayer *moefmPlayer;

@property int errorCounter;

@end
