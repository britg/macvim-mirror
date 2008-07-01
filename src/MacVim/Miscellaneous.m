/* vi:set ts=8 sts=4 sw=4 ft=objc:
 *
 * VIM - Vi IMproved		by Bram Moolenaar
 *				MacVim GUI port by Bjorn Winckler
 *
 * Do ":help uganda"  in Vim to read copying and usage conditions.
 * Do ":help credits" in Vim to see a list of people who contributed.
 * See README.txt for an overview of the Vim source code.
 */

#import "MacVim.h"
#import "Miscellaneous.h"



// NSUserDefaults keys
NSString *MMTabMinWidthKey              = @"MMTabMinWidth";
NSString *MMTabMaxWidthKey              = @"MMTabMaxWidth";
NSString *MMTabOptimumWidthKey          = @"MMTabOptimumWidth";
NSString *MMTextInsetLeftKey            = @"MMTextInsetLeft";
NSString *MMTextInsetRightKey           = @"MMTextInsetRight";
NSString *MMTextInsetTopKey             = @"MMTextInsetTop";
NSString *MMTextInsetBottomKey          = @"MMTextInsetBottom";
NSString *MMTerminateAfterLastWindowClosedKey
                                        = @"MMTerminateAfterLastWindowClosed";
NSString *MMTypesetterKey               = @"MMTypesetter";
NSString *MMCellWidthMultiplierKey      = @"MMCellWidthMultiplier";
NSString *MMBaselineOffsetKey           = @"MMBaselineOffset";
NSString *MMTranslateCtrlClickKey       = @"MMTranslateCtrlClick";
NSString *MMTopLeftPointKey             = @"MMTopLeftPoint";
NSString *MMOpenFilesInTabsKey          = @"MMOpenFilesInTabs";
NSString *MMNoFontSubstitutionKey       = @"MMNoFontSubstitution";
NSString *MMLoginShellKey               = @"MMLoginShell";
NSString *MMAtsuiRendererKey            = @"MMAtsuiRenderer";
NSString *MMUntitledWindowKey           = @"MMUntitledWindow";
NSString *MMTexturedWindowKey           = @"MMTexturedWindow";
NSString *MMZoomBothKey                 = @"MMZoomBoth";
NSString *MMCurrentPreferencePaneKey    = @"MMCurrentPreferencePane";
NSString *MMLoginShellCommandKey        = @"MMLoginShellCommand";
NSString *MMLoginShellArgumentKey       = @"MMLoginShellArgument";
NSString *MMDialogsTrackPwdKey          = @"MMDialogsTrackPwd";




@implementation NSIndexSet (MMExtras)

+ (id)indexSetWithVimList:(NSString *)list
{
    NSMutableIndexSet *idxSet = [NSMutableIndexSet indexSet];
    NSArray *array = [list componentsSeparatedByString:@"\n"];
    unsigned i, count = [array count];

    for (i = 0; i < count; ++i) {
        NSString *entry = [array objectAtIndex:i];
        if ([entry intValue] > 0)
            [idxSet addIndex:i];
    }

    return idxSet;
}

@end // NSIndexSet (MMExtras)




@implementation NSDocumentController (MMExtras)

- (void)noteNewRecentFilePath:(NSString *)path
{
    NSURL *url = [NSURL fileURLWithPath:path];
    if (url)
        [self noteNewRecentDocumentURL:url];
}

@end // NSDocumentController (MMExtras)




@implementation NSOpenPanel (MMExtras)

- (void)hiddenFilesButtonToggled:(id)sender
{
    [self setShowsHiddenFiles:[sender intValue]];
}

- (void)setShowsHiddenFiles:(BOOL)show
{
    // This is undocumented stuff, so be careful. This does the same as
    //     [[self _navView] setShowsHiddenFiles:show];
    // but does not produce warnings.

    if (![self respondsToSelector:@selector(_navView)])
        return;

    id navView = [self performSelector:@selector(_navView)];
    if (![navView respondsToSelector:@selector(setShowsHiddenFiles:)])
        return;

    // performSelector:withObject: does not support a BOOL
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
        [navView methodSignatureForSelector:@selector(setShowsHiddenFiles:)]];
    [invocation setTarget:navView];
    [invocation setSelector:@selector(setShowsHiddenFiles:)];
    [invocation setArgument:&show atIndex:2];
    [invocation invoke];
}

@end // NSOpenPanel (MMExtras)




@implementation NSMenu (MMExtras)

- (int)indexOfItemWithAction:(SEL)action
{
    int i, count = [self numberOfItems];
    for (i = 0; i < count; ++i) {
        NSMenuItem *item = [self itemAtIndex:i];
        if ([item action] == action)
            return i;
    }

    return -1;
}

- (NSMenuItem *)itemWithAction:(SEL)action
{
    int idx = [self indexOfItemWithAction:action];
    return idx >= 0 ? [self itemAtIndex:idx] : nil;
}

- (NSMenu *)findMenuContainingItemWithAction:(SEL)action
{
    // NOTE: We only look for the action in the submenus of 'self'
    int i, count = [self numberOfItems];
    for (i = 0; i < count; ++i) {
        NSMenu *menu = [[self itemAtIndex:i] submenu];
        NSMenuItem *item = [menu itemWithAction:action];
        if (item) return menu;
    }

    return nil;
}

- (NSMenu *)findWindowsMenu
{
    return [self findMenuContainingItemWithAction:
        @selector(performMiniaturize:)];
}

- (NSMenu *)findApplicationMenu
{
    // TODO: Just return [self itemAtIndex:0]?
    return [self findMenuContainingItemWithAction:@selector(terminate:)];
}

- (NSMenu *)findServicesMenu
{
    // NOTE!  Our heuristic for finding the "Services" menu is to look for the
    // second item before the "Hide MacVim" menu item on the "MacVim" menu.
    // (The item before "Hide MacVim" should be a separator, but this is not
    // important as long as the item before that is the "Services" menu.)

    NSMenu *appMenu = [self findApplicationMenu];
    if (!appMenu) return nil;

    int idx = [appMenu indexOfItemWithAction: @selector(hide:)];
    if (idx-2 < 0) return nil;  // idx == -1, if selector not found

    return [[appMenu itemAtIndex:idx-2] submenu];
}

- (NSMenu *)findFileMenu
{
    return [self findMenuContainingItemWithAction:@selector(performClose:)];
}

@end // NSMenu (MMExtras)




@implementation NSToolbar (MMExtras)

- (int)indexOfItemWithItemIdentifier:(NSString *)identifier
{
    NSArray *items = [self items];
    int i, count = [items count];
    for (i = 0; i < count; ++i) {
        id item = [items objectAtIndex:i];
        if ([[item itemIdentifier] isEqual:identifier])
            return i;
    }

    return NSNotFound;
}

- (NSToolbarItem *)itemAtIndex:(int)idx
{
    NSArray *items = [self items];
    if (idx < 0 || idx >= [items count])
        return nil;

    return [items objectAtIndex:idx];
}

- (NSToolbarItem *)itemWithItemIdentifier:(NSString *)identifier
{
    int idx = [self indexOfItemWithItemIdentifier:identifier];
    return idx != NSNotFound ? [self itemAtIndex:idx] : nil;
}

@end // NSToolbar (MMExtras)




@implementation NSTabView (MMExtras)

- (void)removeAllTabViewItems
{
    NSArray *existingItems = [self tabViewItems];
    NSEnumerator *e = [existingItems objectEnumerator];
    NSTabViewItem *item;
    while (item = [e nextObject]){
        [self removeTabViewItem:item];
    }
}

@end // NSTabView (MMExtras)




@implementation NSNumber (MMExtras)

- (int)tag
{
    return [self intValue];
}

@end // NSNumber (MMExtras)




    NSView *
openPanelAccessoryView()
{
    // Return a new button object for each NSOpenPanel -- several of them
    // could be displayed at once.
    // If the accessory view should get more complex, it should probably be
    // loaded from a nib file.
    NSButton *button = [[[NSButton alloc]
        initWithFrame:NSMakeRect(0, 0, 140, 18)] autorelease];
    [button setTitle:
        NSLocalizedString(@"Show Hidden Files", @"Open File Dialog")];
    [button setButtonType:NSSwitchButton];

    [button setTarget:nil];
    [button setAction:@selector(hiddenFilesButtonToggled:)];

    // use the regular control size (checkbox is a bit smaller without this)
    NSControlSize buttonSize = NSRegularControlSize;
    float fontSize = [NSFont systemFontSizeForControlSize:buttonSize];
    NSCell *theCell = [button cell];
    NSFont *theFont = [NSFont fontWithName:[[theCell font] fontName]
                                      size:fontSize];
    [theCell setFont:theFont];
    [theCell setControlSize:buttonSize];
    [button sizeToFit];

    return button;
}


    NSString *
buildTabDropCommand(NSArray *filenames)
{
    // Create a command line string that will open the specified files in tabs.

    if (!filenames || [filenames count] == 0)
        return [NSString string];

    NSMutableString *cmd = [NSMutableString stringWithString:
            @"<C-\\><C-N>:tab drop"];

    NSEnumerator *e = [filenames objectEnumerator];
    id o;
    while ((o = [e nextObject])) {
        NSString *file = [o stringByEscapingSpecialFilenameCharacters];
        [cmd appendString:@" "];
        [cmd appendString:file];
    }

    [cmd appendString:@"|redr|f<CR>"];

    return cmd;
}

    NSString *
buildSelectRangeCommand(NSRange range)
{
    // Build a command line string that will select the given range of lines.
    // If range.length == 0, then position the cursor on the given line but do
    // not select.

    if (range.location == NSNotFound)
        return [NSString string];

    NSString *cmd;
    if (range.length > 0) {
        cmd = [NSString stringWithFormat:@"<C-\\><C-N>%dGV%dGz.0",
                NSMaxRange(range), range.location];
    } else {
        cmd = [NSString stringWithFormat:@"<C-\\><C-N>%dGz.0", range.location];
    }

    return cmd;
}

    NSString *
buildSearchTextCommand(NSString *searchText)
{
    // TODO: Searching is an exclusive motion, so if the pattern would match on
    // row 0 column 0 then this pattern will miss that match.
    return [NSString stringWithFormat:@"<C-\\><C-N>gg/\\c%@<CR>", searchText];
}




