//
//  ThemesViewController.m
//  TinkoffChat
//
//  Created by MacBookPro on 04/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

#import "ThemesViewController.h"

@interface ThemesViewController ()

@end

@implementation ThemesViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [[Themes alloc] init];  // release
}

- (IBAction)setTheme1:(id)sender {
    self.view.backgroundColor = self.model.theme1;
    [self.delegate themesViewController:self didSelectTheme:self.model.theme1];  // TODO: print colors correctly
}

- (IBAction)setTheme2:(id)sender {
    self.view.backgroundColor = self.model.theme2;
    [self.delegate themesViewController:self didSelectTheme:self.model.theme2];
}

- (IBAction)setTheme3:(id)sender {
    self.view.backgroundColor = self.model.theme3;
    [self.delegate themesViewController:self didSelectTheme:self.model.theme3];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
