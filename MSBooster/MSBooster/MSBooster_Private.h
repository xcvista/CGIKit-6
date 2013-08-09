//
//  MSBooster_Private.h
//  MSBooster
//
//  Created by Maxthon Chan on 7/31/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#ifndef MSBooster_MSBooster_Private_h
#define MSBooster_MSBooster_Private_h

#include <MSBooster/MSCommon.h>

#ifdef MSConstantString
#undef MSConstantString
#endif
#define MSConstantString(_name, _value) NSString *const _name = @ #_value

#endif
