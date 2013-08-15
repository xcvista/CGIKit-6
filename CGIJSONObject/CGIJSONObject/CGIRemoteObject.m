//
//  CGIRemoteObject.m
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/15/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "CGIRemoteObject.h"
#import <MSBooster/MSBooster.h>
#import "NSObject+CGIJSONSerializable.h"
#import "NSArray+CGIJSONSerializable.h"
#import "CGIRemoteConnection.h"

extern CGIRemoteConnection *_CGI_defaultRemoteConnection;

@implementation CGIRemoteObject

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSString *methodName = NSStringFromSelector(aSelector);
    if ([self respondsToSelector:aSelector])
        return [super methodSignatureForSelector:aSelector];
    else if ([methodName rangeOfString:@":"].location == NSNotFound)
        return [NSMethodSignature signatureWithObjCTypes:"@@:"];
    else
    {
        [self doesNotRecognizeSelector:aSelector];
        return nil;
    }
}

- (Class)classForSelector:(SEL)selector
{
    NSString *queryMethodName = MSSTR(@"classForMethod%@", NSStringFromSelector(selector));
    SEL querySelector = NSSelectorFromString(queryMethodName);
    Class class = Nil;
    
    if ([self respondsToSelector:querySelector])
    {
        class = objc_msgSend(self, querySelector);
    }
    
    return class;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL method = [anInvocation selector];
    Class class = [self classForSelector:method];
    id value = nil;
    
    if (!_CGI_defaultRemoteConnection)
    {
        [NSException raise:@"CGINoConnectionException" format:@"I am not connected."];
    }
    
    do
    {
        NSMutableString *methodName = [NSStringFromSelector(method) mutableCopy];
        
        NSError *error = nil;
        id uplinkObject = [self serializedObject];
        NSData *uplinkData = [NSJSONSerialization dataWithJSONObject:uplinkObject
                                                             options:0
                                                               error:&error];
        
        if (!uplinkData)
        {
            value = error;
            break;
        }
        error = nil;
        
        
        
        NSData *downlinkData = [_CGI_defaultRemoteConnection dataWithData:uplinkData
                                                               fromMethod:methodName
                                                                    error:&error];
        
        if (!downlinkData)
        {
            value = error;
            break;
        }
        error = nil;
        
        id downlinkObject = [NSJSONSerialization JSONObjectWithData:downlinkData
                                                            options:0
                                                              error:&error];
        
        if (!downlinkObject)
        {
            value = error;
            break;
        }
        error = nil;
        
        value = ([downlinkObject isKindOfClass:[NSArray class]]) ? [[NSArray alloc] initWithArray:downlinkObject classForMembers:class] : [[class alloc] initWithSerializedObject:downlinkObject];
        
    } while (0);
    
    value = objc_retainAutoreleaseReturnValue(value);
    [anInvocation setReturnValue:&value];
}

@end
