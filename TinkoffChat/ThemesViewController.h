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

@property (nonatomic, strong) id<ThemesViewControllerDelegate> delegate;  // TODO: choose correct attributes
@property (nonatomic, strong) Themes *model;

@end


NS_ASSUME_NONNULL_END
