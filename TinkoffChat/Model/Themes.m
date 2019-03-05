//
//  Themes.m
//  TinkoffChat
//
//  Created by MacBookPro on 04/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

#import "Themes.h"

@implementation Themes
-(id)init {
    if (self = [super init])  {
        self.theme1 = UIColor.blueColor;
        self.theme2 = UIColor.purpleColor;
        self.theme3 = UIColor.redColor;
    }
    return self;
}
@end
