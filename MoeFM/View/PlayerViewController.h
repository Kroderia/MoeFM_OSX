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
#import "ImageSwitchButton.h"

@interface PlayerViewController : NSViewController<MoefmPlayerDelegate>
{
    MoefmPlayer *moefmPlayer;
    NSImage *songCoverDefault;
}

@property (weak) IBOutlet ScrollTextView *songTitleText;
@property (weak) IBOutlet ScrollTextView *songAlbumText;
@property (weak) IBOutlet NSImageView *songCoverImageView;
@property (weak) IBOutlet SongProgressBar *songProgressBar;
@property (weak) IBOutlet NSTextField *songProgressTimer;

@property (weak) IBOutlet ImageSwitchButton *favBtn;
@property (weak) IBOutlet ImageSwitchButton *playBtn;
@property (weak) IBOutlet ImageSwitchButton *trashBtn;
@property (weak) IBOutlet ImageSwitchButton *nextBtn;

- (IBAction)clickPlayBtn:(id)sender;
- (IBAction)clickNextBtn:(id)sender;
- (IBAction)clickTrashBtn:(id)sender;
- (IBAction)clickFavBtn:(id)sender;

@property (strong) NSImage *songCoverImage;

@end
