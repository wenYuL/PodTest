//
//  Util_ScrollViewButton.h
//  ScrollTag
//
//  Created by 刘文裕 on 2019/11/27.
//  Copyright © 2019 wenYuL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class Util_ScrollViewButton;
typedef void(^TagClick)(NSInteger idx, Util_ScrollViewButton *sender);

@interface Util_ScrollViewButton : UIView

+ (instancetype)shareInstanceTagButton;

// 当前选中的tag index
@property(nonatomic, assign)NSInteger idx;
// 点击tag回调事件
@property(nonatomic, copy)TagClick click;
// Title Label
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
// Title
@property(nonatomic, copy)NSString *title;

@end

NS_ASSUME_NONNULL_END
