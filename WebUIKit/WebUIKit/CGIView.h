//
//  CGIView.h
//  WebUIKit
//
//  Created by Maxthon Chan on 9/1/13.
//
//

#import <WebUIKit/CGIResponder.h>

@interface CGIView : CGIResponder

@property NSString *ID;
@property NSArray *classes;
@property NSDictionary *style;

- (CGIView *)superview;
- (NSArray *)subviews;
- (void)addSubview:(CGIView *)view;
- (void)insertSubview:(CGIView *)subview atIndex:(NSUInteger)index;
- (void)insertSubview:(CGIView *)subview beforeView:(CGIView *)view;
- (void)insertSubview:(CGIView *)subview afterView:(CGIView *)view;
- (void)removeFromSuperview;

- (NSString *)HTMLRepresentation;

@end
