//
//  Themes.h
//  TinkoffChat
//
//  Created by MacBookPro on 04/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Themes : NSObject

@property (strong, nonatomic) UIColor *theme1;
@property (strong, nonatomic) UIColor *theme2;
@property (strong, nonatomic) UIColor *theme3;

-(id)initWithColors: (UIColor*)color1 :(UIColor*)color2 :(UIColor*)color3;

@end

NS_ASSUME_NONNULL_END
