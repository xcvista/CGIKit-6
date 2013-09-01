//
//  CGIResponder.h
//  WebUIKit
//
//  Created by Maxthon Chan on 9/1/13.
//
//

#import <Foundation/Foundation.h>

@class CGIEvent;

@interface CGIResponder : NSObject

- (void)handleEvent:(CGIEvent *)event;
- (CGIResponder *)nextResponder;

@end
