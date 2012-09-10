//
//  ActionSheetDelegate.m
//
//  Created by Joshua Caswell on 12/5/11.
// 
// To the extent possible under law, the author has dedicated all
// copyright and related and neighboring rights to this software to 
// the public domain worldwide. This software is distributed without
// any warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication 
// along with this software. 
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

#import "ActionSheetDelegate.h"
#import <objc/runtime.h>

#define SAFE_BLOCK_INVOKE(b,...) ((b) ? (b)(__VA_ARGS__) : 0)

@implementation ActionSheetDelegate

@synthesize handler;

+ (id)delegateWithHandler: (ButtonClickedHandler)newHandler {
    return [[[self alloc] initWithHandler:newHandler] autorelease];
}

- (id)initWithHandler: (ButtonClickedHandler)newHandler {
    
    self = [super init];
    if( !self ) return nil;
    
    handler = [newHandler copy];
    
    return self;
}

- (void)dealloc {
    [handler release];
    [super dealloc];
}

static char sheet_key;
- (void)associateSelfWithSheet: (UIActionSheet *)sheet {
    // Tie delegate's lifetime to that of the action sheet
    objc_setAssociatedObject(sheet, &sheet_key, self, OBJC_ASSOCIATION_RETAIN);
}

//MARK: -
//MARK: Action sheet delegate methods

- (void)actionSheet: (UIActionSheet *)actionSheet clickedButtonAtIndex: (NSInteger)buttonIndex {
    SAFE_BLOCK_INVOKE(handler, actionSheet, buttonIndex);
}

@end
