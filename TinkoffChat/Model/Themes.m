//
//  Themes.m
//  TinkoffChat
//
//  Created by MacBookPro on 04/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

#import "Themes.h"

@implementation Themes

-(id)initWithColors: (UIColor*)color1 :(UIColor*)color2 :(UIColor*)color3  {
    if (self = [super init])  {
        self.theme1 = color1;
        self.theme2 = color2;
        self.theme3 = color3;
    }
    return self;
}

- (void)dealloc {
    [_theme1 release];
    [_theme2 release];
    [_theme3 release];
    printf("dealloc in Themes\n");
    [super dealloc];
}

@synthesize theme1 = _theme1;
- (UIColor*)theme1 {
    return _theme1;
}
- (void)setTheme1:(UIColor *)newTheme1 {
    [newTheme1 retain];
    [_theme1 release];
    _theme1 = newTheme1;
}

@synthesize theme2 = _theme2;
- (UIColor*)theme2 {
    return _theme2;
}
- (void)setTheme2:(UIColor *)newTheme2 {
    [newTheme2 retain];
    [_theme2 release];
    _theme2 = newTheme2;
}

@synthesize theme3 = _theme3;
- (UIColor*)theme3 {
    return _theme3;
}
- (void)setTheme3:(UIColor *)newTheme3 {
    [newTheme3 retain];
    [_theme3 release];
    _theme3 = newTheme3;}

@end
