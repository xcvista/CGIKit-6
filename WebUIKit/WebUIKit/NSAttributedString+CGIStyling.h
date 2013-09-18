//
//  NSAttributedString+CGIStyling.h
//  WebUIKit
//
//  Created by Maxthon Chan on 9/2/13.
//
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (CGIStyling)

- (id)initWithHTMLString:(NSString *)HTMLstring;
- (NSString *)HTMLString;

@end
