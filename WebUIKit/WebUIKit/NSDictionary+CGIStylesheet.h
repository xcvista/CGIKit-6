//
//  NSDictionary+CGIStylesheet.h
//  WebUIKit
//
//  Created by Maxthon Chan on 9/2/13.
//
//

#import <Foundation/Foundation.h>
#import <MSBooster/MSBooster.h>

typedef NS_OPTIONS(NSUInteger, CGIStylesheetWriteOptions)
{
    CGIStylesheetWriteOptionsPrettyPrinted = 1UL << 0,
};

@interface NSDictionary (CGIStylesheet)

+ (instancetype)dictionaryWithStylesheet:(NSString *)stylesheet;
+ (instancetype)dictionaryWithStylesheetSelector:(NSString *)stylesheetSelector;

- (id)initWithStylesheet:(NSString *)stylesheet;
- (id)initWithStylesheetSelector:(NSString *)stylesheetSelector;

- (NSString *)stylesheetStringWithOptions:(CGIStylesheetWriteOptions)options;
- (NSString *)stylesheetSelectorStringWithOptions:(CGIStylesheetWriteOptions)options;

@end
