//
//  NSDictionary+CGICSSWriter.h
//  WebUIKit
//
//  Created by Maxthon Chan on 9/1/13.
//
//

#import <MSBooster/MSBooster.h>

typedef NS_OPTIONS(NSUInteger, CGICSSOptions)
{
    CGICSSOptionsPrettyPrint = 1UL << 0,
};

@interface NSDictionary (CGICSSWriter)

- (id)initWithCSSString:(NSString *)css;
- (id)initWithCSSSelector:(NSString *)selector;

- (NSString *)CSSSelectorWithOptions:(CGICSSOptions)options;
- (NSString *)CSSStringWithOptions:(CGICSSOptions)options;

@end
