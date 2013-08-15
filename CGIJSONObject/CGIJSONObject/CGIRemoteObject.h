//
//  CGIRemoteObject.h
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/15/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @def       CGIRemoteMethodClass
 
 此宏定义一个远程方法返回类型的私有方法。方法反射无法获知其返回值。
 
 @param     __key    需要制定类型的属性名。
 @param     __class  属性值的类型。
 @note      宏定义展开后包括一个对指定类的方法调用，因此需要导入该类的头文件。
 */
#define CGIRemoteMethodClass(__method, __class) \
- (Class)classForMethod ##__method { return [__class class]; }

#define CGINotRemoteMethod(__method) \
- (Class)classForMethod ##__method { return Nil; }

@class CGIRemoteConnection;

@interface CGIRemoteObject : NSObject

- (Class)classForSelector:(SEL)selector;

@end
