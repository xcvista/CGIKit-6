//
//  NSOrderedSet+MSCollectionProtocols.h
//  MSBooster
//
//  Created by Maxthon Chan on 10/21/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MSBooster/NSArray+MSOrderedCollection.h>
#import <MSBooster/NSSet+MSUniqueCollection.h>

@interface NSOrderedSet (MSCollectionProtocols) <MSOrderedCollection, MSUniqueCollection>

@end

@interface NSMutableOrderedSet (MSCollectionProtocols) <MSMutableOrderedCollection, MSMutableUniqueCollection>

@end
