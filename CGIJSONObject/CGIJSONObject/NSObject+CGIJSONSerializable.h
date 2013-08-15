//
//  NSObject+CGIJSONSerializable.h
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/15/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @def       CGIClassForKey
 
 此宏定义一个持久化对象类型的私有方法。此方法用于化解某些通过属性反射无法解析的
 属性类型，包括指定数组成员。
 
 @param     __key    需要制定类型的属性名。
 @param     __class  属性值的类型。
 @note      宏定义展开后包括一个对指定类的方法调用，因此需要导入该类的头文件。
 */
#define CGIClassForKey(__key, __class) \
- (Class)classForKey ##__key { return [__class class]; }

#define CGINoSerializeKey(__key) \
- (Class)classForKey ##__key { return Nil; }

/**
 @def       CGIIdentifierProperty
 
 定义对象标识符属性的方便宏。
 
 @note      在 Objective-C 中，你不能直接定义名为 \c id 的属性。因此这一宏定义试
 图通过一种不冒犯 Objective-C 编译器的方式来解决这一问题。
 */
#define CGIIdentifierProperty @property id ID

/**
 @def       CGIType
 
 返回一个包含对象类型编码的字符串对象。
 
 @param     type    被编码的类型。
 @note      此宏定义几乎只在 \c CGIJSONObjects 库内部使用。
 */
#define CGIType(type) @(@encode(type))

@interface NSObject (CGIJSONSerializable)

- (id)initWithSerializedObject:(id)serializedObject;
- (id)serializedObject;
- (NSArray *)allKeys;
- (Class)classForKey:(NSString *)key;

@end
