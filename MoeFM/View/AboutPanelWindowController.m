//
//  AboutPanelWindowController.m
//  MoeFM
//
//  Created by Kroderia on 12/25/13.
//  Copyright (c) 2013 im.kroderia. All rights reserved.
//

#import "AboutPanelWindowController.h"

@interface AboutPanelWindowController ()

@end

@implementation AboutPanelWindowController


- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [self setVersion:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}

- (void)setVersion:(NSString *)version {
    self.versionLabel.stringValue = version;
}

@end
