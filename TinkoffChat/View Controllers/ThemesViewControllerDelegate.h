//
//  ThemesViewControllerDelegate.h
//  TinkoffChat
//
//  Created by MacBookPro on 04/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ThemesViewController;

@protocol ThemesViewControllerDelegate <NSObject>
- (void) themesViewController: (ThemesViewController *) controller didSelectTheme: (UIColor *) selectedTheme;
@end

NS_ASSUME_NONNULL_END
