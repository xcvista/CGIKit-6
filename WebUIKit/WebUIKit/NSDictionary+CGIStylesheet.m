//
//  NSDictionary+CGIStylesheet.m
//  WebUIKit
//
//  Created by Maxthon Chan on 9/2/13.
//
//

#import "NSDictionary+CGIStylesheet.h"

#define _CGI_InitRollback NSUInteger _rollback = [self scanLocation]
#define _CGI_Assert(func) do { if (!(func)) { [self setScanLocation:_rollback]; return NO; } } while(0)

@implementation NSScanner (CGIStylesheetParsing)

- (BOOL)scanStylesheetItem:(NSString **)key value:(NSString **)value
{
    NSString *_key = nil, *_value = nil;
    _CGI_InitRollback;
    _CGI_Assert([self scanUpToString:@":" intoString:&_key]);
    _CGI_Assert([self scanString:@":" intoString:NULL]);
    _value = [[self string] substringFromIndex:[self scanLocation]];
    MSAssignPointer(key, [_key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
    MSAssignPointer(value, [_value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
    return YES;
}

@end

NSString *_CGI_RemoveCSSComments(NSString *source)
{
    NSMutableString *dest = [NSMutableString stringWithCapacity:[source length]];
    NSMutableString *buffer = [NSMutableString stringWithCapacity:5];
    
    BOOL inLiteral = NO, inComment = NO, preChange = NO;
    
    for (NSUInteger i = 0; i < [source length]; i++)
    {
        unichar ch = [source characterAtIndex:i];
        
    }
}

@implementation NSDictionary (CGIStylesheet)

+ (instancetype)dictionaryWithStylesheet:(NSString *)stylesheet
{
    return [[self alloc] initWithStylesheet:stylesheet];
}

- (id)initWithStylesheet:(NSString *)stylesheet
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    
    
    return [self initWithDictionary:dictionary];
}

- (NSString *)stylesheetStringWithOptions:(CGIStylesheetWriteOptions)options
{
    
}

@end
