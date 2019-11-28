//
//  Util_ScrollViewButton.m
//  ScrollTag
//
//  Created by 刘文裕 on 2019/11/27.
//  Copyright © 2019 wenYuL. All rights reserved.
//

#import "Util_ScrollViewButton.h"

@implementation Util_ScrollViewButton

+ (instancetype)shareInstanceTagButton {
    return [[NSBundle mainBundle] loadNibNamed:@"Util_ScrollViewButton" owner:nil options:nil].firstObject;
}

- (IBAction)tapSelf:(id)sender {
    NSLog(@"点击tag");
    if (self.click) {
        self.click(self.idx, self);
    }
}

@end
