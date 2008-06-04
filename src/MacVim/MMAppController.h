/* vi:set ts=8 sts=4 sw=4 ft=objc:
 *
 * VIM - Vi IMproved		by Bram Moolenaar
 *				MacVim GUI port by Bjorn Winckler
 *
 * Do ":help uganda"  in Vim to read copying and usage conditions.
 * Do ":help credits" in Vim to see a list of people who contributed.
 * See README.txt for an overview of the Vim source code.
 */

#import <Cocoa/Cocoa.h>
#import "MacVim.h"


@class MMWindowController;


@interface MMAppController : NSObject <MMAppProtocol> {
    NSConnection        *connection;
    NSMutableArray      *vimControllers;
    NSString            *openSelectionString;
    ATSFontContainerRef fontContainerRef;
    NSMutableDictionary *pidArguments;
    NSMenu              *defaultMainMenu;
    NSMenuItem          *recentFilesMenuItem;
}

+ (MMAppController *)sharedInstance;
- (NSMenu *)defaultMainMenu;
- (void)removeVimController:(id)controller;
- (void)windowControllerWillOpen:(MMWindowController *)windowController;
- (void)setMainMenu:(NSMenu *)mainMenu;
- (IBAction)newWindow:(id)sender;
- (IBAction)fileOpen:(id)sender;
- (IBAction)selectNextWindow:(id)sender;
- (IBAction)selectPreviousWindow:(id)sender;
- (IBAction)fontSizeUp:(id)sender;
- (IBAction)fontSizeDown:(id)sender;
- (IBAction)orderFrontPreferencePanel:(id)sender;
- (IBAction)openWebsite:(id)sender;
- (IBAction)showVimHelp:(id)sender;
- (IBAction)zoomAll:(id)sender;

@end
