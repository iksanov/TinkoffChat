//
//  ThemesViewController.m
//  TinkoffChat
//
//  Created by MacBookPro on 04/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

#import "ThemesViewController.h"

@implementation ThemesViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [[Themes alloc] initWithColors: UIColor.blueColor :UIColor.redColor :UIColor.purpleColor];
    self.themeButton1.layer.cornerRadius = 8;
    self.themeButton2.layer.cornerRadius = 8;
    self.themeButton3.layer.cornerRadius = 8;
}

- (IBAction)setTheme1:(id)sender {
    self.view.backgroundColor = self.model.theme1;
    [self.delegate themesViewController:self didSelectTheme:self.model.theme1];
}

- (IBAction)setTheme2:(id)sender {
    self.view.backgroundColor = self.model.theme2;
    [self.delegate themesViewController:self didSelectTheme:self.model.theme2];
}

- (IBAction)setTheme3:(id)sender {
    self.view.backgroundColor = self.model.theme3;
    [self.delegate themesViewController:self didSelectTheme:self.model.theme3];
}

- (IBAction)closeThemeChooser:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [_themeButton1 release];
    [_themeButton2 release];
    [_themeButton3 release];
    [_model dealloc];  // почему недостаточно вызвать release?
    printf("dealloc in ThemesViewController\n");
    [super dealloc];
}

@synthesize delegate = _delegate;
- (id<ThemesViewControllerDelegate>)delegate {
    return _delegate;
}
- (void)setDelegate:(id<ThemesViewControllerDelegate>)delegate {
    _delegate = delegate;  // don't retain/release anything because it is weak.
}

@synthesize model = _model;
- (Themes *)model {
    return _model;
}
- (void)setModel:(Themes *)model {
    [model retain];
    [_model release];
    _model = model;}

@synthesize themeButton1 = _themeButton1;
- (UIButton*)themeButton1 {
    return _themeButton1;
}
- (void)setThemeButton1:(UIButton *)themeButton1 {
    [themeButton1 retain];
    [_themeButton1 release];
    _themeButton1 = themeButton1;
}

@synthesize themeButton2 = _themeButton2;
- (UIButton*)themeButton2 {
    return _themeButton2;
}
- (void)setThemeButton2:(UIButton *)themeButton2 {
    [themeButton2 retain];
    [_themeButton2 release];
    _themeButton2 = themeButton2;
}

@synthesize themeButton3 = _themeButton3;
- (UIButton*)themeButton3 {
    return _themeButton3;
}
- (void)setThemeButton3:(UIButton *)themeButton3 {
    [themeButton3 retain];
    [_themeButton3 release];
    _themeButton3 = themeButton3;
}

@end
