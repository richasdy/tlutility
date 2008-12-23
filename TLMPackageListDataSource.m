//
//  TLMPackageListDataSource.m
//  TeX Live Manager
//
//  Created by Adam Maxwell on 12/22/08.
/*
 This software is Copyright (c) 2008
 Adam Maxwell. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 
 - Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 - Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in
 the documentation and/or other materials provided with the
 distribution.
 
 - Neither the name of Adam Maxwell nor the names of any
 contributors may be used to endorse or promote products derived
 from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "TLMPackageListDataSource.h"
#import "TLMPackageNode.h"
#import "TLMInfoController.h"

@implementation TLMPackageListDataSource

@synthesize outlineView = _outlineView;
@synthesize packageNodes = _packageNodes;
@synthesize _searchField;

- (id)init
{
    self = [super init];
    if (self) {
        _displayedPackageNodes = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc
{
    [_outlineView setDelegate:nil];
    [_outlineView setDataSource:nil];
    [_outlineView release];
    [_packageNodes release];
    [_displayedPackageNodes release];
    [_searchField release];
    [super dealloc];
}

- (void)setPackageNodes:(NSArray *)nodes
{
    [_packageNodes autorelease];
    _packageNodes = [nodes copy];
    [self search:nil];
}

- (IBAction)showInfo:(id)sender;
{
    if ([self selectedItem] != nil)
        [[TLMInfoController sharedInstance] showInfoForPackage:[self selectedItem]];
    else if ([[[TLMInfoController sharedInstance] window] isVisible] == NO) {
        [[TLMInfoController sharedInstance] showInfoForPackage:nil];
        [[TLMInfoController sharedInstance] showWindow:nil];
    }
}

- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem;
{
    SEL action = [anItem action];
    if (@selector(showInfo:) == action)
        return [[[TLMInfoController sharedInstance] window] isVisible] == NO;
    else
        return YES;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)anIndex ofItem:(TLMPackageNode *)item;
{
    return (nil == item) ? [_displayedPackageNodes objectAtIndex:anIndex] : [item childAtIndex:anIndex];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(TLMPackageNode *)item;
{
    return (nil == item) ? YES : [item numberOfChildren];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(TLMPackageNode *)item;
{
    return (nil == item) ? [_displayedPackageNodes count] : [item numberOfChildren];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item;
{
    return [item valueForKey:[tableColumn identifier]];
}

- (id)selectedItem
{
    return [_outlineView selectedRow] != -1 ? [_outlineView itemAtRow:[_outlineView selectedRow]] : nil;
}

- (IBAction)search:(id)sender;
{
    NSString *searchString = [_searchField stringValue];
    
    if (nil == searchString || [searchString isEqualToString:@""]) {
        [_displayedPackageNodes setArray:_packageNodes];
    }
    else {
        [_displayedPackageNodes removeAllObjects];
        for (TLMPackageNode *node in _packageNodes) {
            if ([node matchesSearchString:searchString])
                [_displayedPackageNodes addObject:node];
        }
    }
    //[_packages sortUsingDescriptors:_sortDescriptors];    
    [_outlineView reloadData];
}

- (void)outlineView:(NSOutlineView *)outlineView didClickTableColumn:(NSTableColumn *)tableColumn;
{
    NSLog(@"sort by %@", [tableColumn identifier]);
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification;
{
    if ([[[TLMInfoController sharedInstance] window] isVisible]) {
        // reset for multiple selection or empty selection
        if ([_outlineView numberOfSelectedRows] != 1)
            [[TLMInfoController sharedInstance] showInfoForPackage:nil];
        else
            [self showInfo:nil];
    }
}

@end