//
//  main.m
//  time.fcgi
//
//  Created by Maxthon Chan on 8/16/13.
//
//

#include <CGIKit/CGIKit.h>

int main(int argc, const char **argv)
{
    CGIApplicationMain(argc, argv, CGIApplicationName, (id)CFSTR("TimeAppDelegate"));
}
