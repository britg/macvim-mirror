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




@interface MMTextStorage : NSTextStorage {
    NSMutableAttributedString *attribString;
    int maxRows, maxColumns;
    int actualRows, actualColumns;
    NSAttributedString *emptyRowString;
    NSFont *font;
    NSColor *defaultBackgroundColor;
    //NSMutableParagraphStyle *paragraphStyle;
}

- (NSString *)string;
- (NSDictionary *)attributesAtIndex:(unsigned)index
                     effectiveRange:(NSRangePointer)aRange;
- (void)replaceCharactersInRange:(NSRange)aRange
                      withString:(NSString *)aString;
- (void)setAttributes:(NSDictionary *)attributes range:(NSRange)aRange;

- (int)maxRows;
- (int)maxColumns;
- (void)getMaxRows:(int*)rows columns:(int*)cols;
- (void)setMaxRows:(int)rows columns:(int)cols;
- (void)replaceString:(NSString*)string atRow:(int)row column:(int)col
        withFlags:(int)flags foregroundColor:(NSColor*)fg
        backgroundColor:(NSColor*)bg;
- (void)deleteLinesFromRow:(int)row lineCount:(int)count
              scrollBottom:(int)bottom left:(int)left right:(int)right
                     color:(NSColor *)color;
- (void)insertLinesAtRow:(int)row lineCount:(int)count
            scrollBottom:(int)bottom left:(int)left right:(int)right
                   color:(NSColor *)color;
- (void)clearBlockFromRow:(int)row1 column:(int)col1 toRow:(int)row2
                   column:(int)col2 color:(NSColor *)color;
- (void)clearAllWithColor:(NSColor *)color;
- (void)setDefaultColorsBackground:(NSColor *)bgColor
                        foreground:(NSColor *)fgColor;
- (void)setFont:(NSFont*)newFont;
- (NSFont*)font;
- (NSSize)size;
- (NSSize)calculateAverageFontSize;
- (NSRect)rectForRowsInRange:(NSRange)range;
- (NSRect)rectForColumnsInRange:(NSRange)range;
- (unsigned)offsetFromRow:(int)row column:(int)col;
- (BOOL)resizeToFitSize:(NSSize)size;
- (NSSize)fitToSize:(NSSize)size;
- (NSSize)fitToSize:(NSSize)size rows:(int *)rows columns:(int *)columns;

@end

/* vim: set filetype=objc: */
