//
//  NSDate+CGIJSONSerializable.h
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/21/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MSBooster/MSBooster.h>

typedef NS_ENUM(NSUInteger, CGIDateEmitDataType)
{
    CGIDateEmitString,
    CGIDateEmitNumber,
};

@interface NSDate (CGIJSONSerializableEmittingType)

+ (CGIDateEmitDataType)emitDataType;
+ (void)setEmitDataType:(CGIDateEmitDataType)dataType;

@end
