//
//  AboutPanelWindowController.h
//  MoeFM
//
//  Created by Kroderia on 12/25/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AboutPanelWindowController : NSWindowController

@property (weak) IBOutlet NSTextField *versionLabel;

- (void)setVersion: (NSString*)version;

@end

