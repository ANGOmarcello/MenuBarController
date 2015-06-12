//
//  AppDelegate.m
//  MenuBarControllerSample
//
//  Created by Дмитрий Николаев on 19.01.15.
//  Copyright (c) 2015 Dmitry Nikolaev. All rights reserved.
//

#import "AppDelegate.h"
#import "MyViewController.h"
@import MenuBarController;

@interface AppDelegate ()

@property (strong) MenuBarController *menuBarController;
@property (strong) NSPopover *popover;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self createPopover];
    [self createMenuBarController];
    // Insert code here to initialize your application
}

- (void) createMenuBarController {
    NSImage *image = [NSImage imageNamed:NSImageNameAddTemplate];
    
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Menu"];
    NSMenuItem *itemOne = [menu addItemWithTitle:NSLocalizedString(@"Quit",@"") action:nil keyEquivalent:@""];
    itemOne.target = self;
    itemOne.action = @selector(quit:);
    
    NSMenuItem *itemTwo = [menu addItemWithTitle:NSLocalizedString(@"Revert",@"") action:nil keyEquivalent:@""];
    itemTwo.target = self;
    itemTwo.action = @selector (revertMethod);
    
    // Could be set in an option to switch right and left click behavior makes it easier to get accepted in appstore
    revertBool = true;
    
    __weak AppDelegate *weakSelf = self;
    self.menuBarController = [[MenuBarController alloc] initWithImage:image menu:menu revert:revertBool handler:^(BOOL active) {
        
        NSLog(@"Test");
        if (active){
            if (revertBool) {
                [weakSelf.popover showRelativeToRect:NSZeroRect ofView:[weakSelf.menuBarController statusItemView] preferredEdge:CGRectMinYEdge];
            } else {
                [weakSelf.popover close];
            }
            
        } else {
            if (revertBool) {
                [weakSelf.popover close];
            } else {
                [weakSelf.popover showRelativeToRect:NSZeroRect ofView:[weakSelf.menuBarController statusItemView] preferredEdge:CGRectMinYEdge];
            }
        }
    }];
}

- (void) revertMethod {
    if (revertBool) {
        revertBool = false;
        [self.menuBarController setRevert: revertBool];
    } else {
        revertBool = true;
        [self.menuBarController setRevert: revertBool];
    }
}

- (void) createPopover {
    self.popover = [[NSPopover alloc] init];
    self.popover.contentViewController = [[MyViewController alloc] init];
    self.popover.behavior = NSPopoverBehaviorApplicationDefined;
}

- (IBAction) quit:(id)sender {
    [[NSApplication sharedApplication] terminate:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
