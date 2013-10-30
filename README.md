# CGIKit

*   Version:    6.1 (6B24)
*   Author:     Maxthon T. Chan, et al.

## Introduction

### CGIKit

This is the latest iteration of CGIKit, the Objective-C FastCGI Web development
framework. It is modeled after Cocoa applications, and borrowed design paradigms
from ASP.net and Java EE.

CGIKit is designed to be easilt portable among different server systems. It is
programmed and extensively tested under OS X, while the same set of tests are
carried out under Linux (using GNUstep) too.

CGIKit 6 now comes with WebUIKit, the Objective-C Web page framework.

### CGIJSONObject

This is the latest iteration of CGIJSONObject, a reflective JSON-based object
persistance and cross-platform exchange framework for Objective-C. It is part of
the larger CGIKit project, hence the CGI class prefix, while it is still useable
as a standalone library for multiple platforms.

CGIJSONObject is designed to be easily portable. It can be built under Mac OS X
and Linux with GNUstep, and partially built under iOS (no CGIServerObject, which
requires the rest of CGIKit which does not support iOS)

## What's New

*   The old "boilerplate" is now a seperate project, MSBooster.
    
    This allows better intergration among projects.

*   Call handling is now multi-threaded.

    It was single-threaded in previous versions that prevented the server from
    handling multiple threads in the same time. It was considered a bug.

*   Deeper intergration of CGIJSONObject and CGIKit for better program state
    management.
    
    Now the App Delegate is required to conform to NSCoding so that the program
    state can be properly retained between calls, even for CGI methods. However
    this would require write permissions on the server and some code enabling
    it.

*   Removed CGIFastApplication class.
    
    Now CGIApplication class itself is implemented on top of libfcgi, providing
    CGI and FastCGI functionalities simultaeniously. CGI-styled accessing is now
    managed using libdispatch (GCD).

## Using CGIJSONObject

CGIJSONObject have a minimal overhead on programming. With Xcode 4.5 and up, you
simply declare Objective-C properties in the class definition and generally you
are good to go. If you have NSArray objects (or its decendents) or your sessions
of debugging tell you that this library is getting the class of your objecth ts
wrong, there is a CGIKeyClass macro that can be used to override automatic class
detection.