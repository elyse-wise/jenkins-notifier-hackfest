//
//  main.m
//  hack
//
//  Created by Elyse Wise on 6/13/13.
//  Copyright (c) 2013 Elyse Wise. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
    return macruby_main("rb_main.rb", argc, argv);
}
