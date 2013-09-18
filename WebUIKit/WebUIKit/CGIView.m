//
//  CGIView.m
//  WebUIKit
//
//  Created by Maxthon Chan on 9/1/13.
//
//

#import "CGIView.h"

@implementation CGIView
{
    id __weak _superview;
    NSMutableArray *_subviews;
}

- (id)init
{
    if (self = [super init])
    {
        _subviews = [NSMutableArray array];
    }
    return self;
}

- (id)superview
{
    return _superview;
}

- (NSArray *)subviews
{
    return [NSArray arrayWithArray:_subviews];
}

- (void)addSubview:(CGIView *)view
{
    [_subviews addObject:view];
    view->_superview = self;
}

- (void)insertSubview:(CGIView *)subview atIndex:(NSUInteger)index
{
    [_subviews insertObject:subview atIndex:index];
    subview->_superview = self;
}

- (void)insertSubview:(CGIView *)subview beforeView:(CGIView *)view
{
    NSUInteger idx = [_subviews indexOfObject:view];
    if (idx != NSNotFound)
    {
        [self insertSubview:subview atIndex:idx - 1];
    }
}

- (void)insertSubview:(CGIView *)subview afterView:(CGIView *)view
{
    NSUInteger idx = [_subviews indexOfObject:view];
    if (idx != NSNotFound)
    {
        [self insertSubview:subview atIndex:idx + 1];
    }
}

- (void)removeFromSuperview
{
    CGIView *superview = [self superview];
    [superview->_subviews removeObject:self];
    self->_superview = nil;
}

- (NSString *)HTMLRepresentation
{
    NSMutableString *session = [NSMutableString stringWithFormat:@"<div"];
    
    if ([self.ID length])
        [session appendFormat:@" id=\"%@\"", self.ID];
    if ([self.classes count])
        [session appendFormat:@" class=\"%@\"", [self.classes componentsJoinedByString:@" "]];
    if ([self.style count])
        ;
    [session appendString:@">\n"];
    
    for (CGIView *subview in _subviews)
    {
        [session appendString:[subview HTMLRepresentation]];
    }
    
    [session appendString:@"</div>\n"];
    
    return [NSString stringWithString:session];
}

@end
