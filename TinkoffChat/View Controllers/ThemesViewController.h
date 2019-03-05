//
//  ThemesViewController.h
//  TinkoffChat
//
//  Created by MacBookPro on 04/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Themes.h"
#import "ThemesViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThemesViewController : UIViewController

@property (weak, nonatomic) id<ThemesViewControllerDelegate> delegate;
@property (strong, nonatomic) Themes *model;

@property (retain, nonatomic) IBOutlet UIButton *themeButton1;
@property (retain, nonatomic) IBOutlet UIButton *themeButton2;
@property (retain, nonatomic) IBOutlet UIButton *themeButton3;

@end


NS_ASSUME_NONNULL_END
