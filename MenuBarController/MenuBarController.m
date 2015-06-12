//
//  MenuBarController.m
//  MenuBarController
//
//  Created by Dmitry Nikolaev on 27.10.14.
//  Copyright (c) 2014 Dmitry Nikolaev. All rights reserved.
//

#import "MenuBarController.h"
#import "StatusItemButton.h"

@interface MenuBarController () <StatusItemButtonDelegate>

@property (strong, nonatomic) NSStatusItem *statusItem;

@end

@implementation MenuBarController

- (instancetype) initWithImage: (NSImage *) image menu: (NSMenu *) menu handler: (MenuBarControllerActionBlock) handler
{
    self = [super init];
    if (self) {
        
        self.image = image;
        self.menu = menu;
        self.handler = handler;
        
        self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
        
        if ([self isYosemite]) {
            [self initStatusItem10];
        } else {
            [self initStatusItem];
        }
        
    }
    return self;
}

- (void) setImage: (NSImage *) image {
    _image = image;
    
    if ([self isYosemite]) {
        self.statusItem.button.image = image;
    } else {
        StatusItemButton *button = (StatusItemButton *)self.statusItem.view;
        button.image = image;
    }
}

- (NSView *) statusItemView {
    
    if ([self isYosemite]) {
        return self.statusItem.button;
    } else {
        return self.statusItem.view;
    }
    
}

// Yosemite

- (void) initStatusItem10 {
    
    self.statusItem.button.image = self.image;
    self.statusItem.button.appearsDisabled = NO;
    self.statusItem.button.target = self;
    self.statusItem.button.action = @selector(leftClick10:);
    
    __unsafe_unretained MenuBarController *weakSelf = self;
    
    [NSEvent addLocalMonitorForEventsMatchingMask:
     (NSRightMouseDownMask | NSAlternateKeyMask | NSLeftMouseDownMask) handler:^(NSEvent *incomingEvent) {
         
         if (incomingEvent.type == NSLeftMouseDown) {
             weakSelf.statusItem.menu = nil;
         }
         
         if (incomingEvent.type == NSRightMouseDown || [incomingEvent modifierFlags] & NSAlternateKeyMask || [incomingEvent modifierFlags] & NSCommandKeyMask || [incomingEvent modifierFlags] & NSControlKeyMask) {
             weakSelf.handler(NO);
             weakSelf.statusItem.menu = weakSelf.menu;
         }
         
         return incomingEvent;
     }];
}

- (IBAction)leftClick10:(id)sender {
    self.handler(YES);
}

// Before Yosemite

- (void) initStatusItem {
    self.statusItem.highlightMode = YES;
    StatusItemButton *button = [[StatusItemButton alloc] initWithImage:self.image];
    button.delegate = self;
    [self.statusItem setView:button];
}

- (void) statusItemButtonLeftClick: (StatusItemButton *) button {
    self.handler(YES);
}

- (void) statusItemButtonRightClick: (StatusItemButton *) button {
    self.handler(NO);
    [self.statusItem popUpStatusItemMenu:self.menu];
}

#pragma mark - Private

- (BOOL) isYosemite {
    return [self.statusItem respondsToSelector:@selector(button)];
}

@end
