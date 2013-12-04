//
//  NSObject+CGIJSONSerializable.h
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/15/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@compatibility_alias CGIPersistantObject NSObject;

/**
 @def       CGIClassForKey
 
 This macro defines a method that tags the class of the key.
 
 @param     __key    Name of property that requires its class identified.
 @param     __class  Type of the value of the object.
 @note      A nonexist class will cause the key being ignored.
 */
#define CGIClassForKey(__key, __class) \
- (Class)classForKey ##__key { return objc_lookUpClass(#__class); }

/**
 @def       CGINoSerializeKey
 
 This macro defines a method that prevents a key from being serialized.
 
 @param     __key    Name of property that requires its class identified.
 @param     __class  Type of the value of the object.
 */
#define CGINoSerializeKey(__key) \
- (Class)classForKey ##__key { return Nil; }

/**
 @def       CGIIdentifierProperty
 
 This macro declares an identifier property, ID.
 
 @note      When serializing, this property will have the key "id".
 */
#define CGIIdentifierProperty @property id ID

@interface NSObject (CGIJSONSerializable)

/**
 Initialize an object from its serialized object.
 */
- (id)initWithSerializedObject:(id)serializedObject;

/**
 Return the serialized form of the current object.
 */
- (id)serializedObject;

/**
 Set the current object's state to the serialized form.
 */
- (BOOL)setSerializedObject:(id)serializedObject;

/**
 Get a list of all keys available.
 */
- (NSArray *)allKeys;

/**
 Get the class of the key.
 */
- (Class)classForKey:(NSString *)key;

/**
 Get the class for a property.
 */
- (Class)classForProperty:(NSString *)key;

/**
 Get the serialized name of a key.
 */
- (NSString *)serializationKeyForKey:(NSString *)key;

@end
