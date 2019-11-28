//
//  Util_ScrollTagView.h
//  ScrollTag
//
//  Created by 刘文裕 on 2019/11/27.
//  Copyright © 2019 wenYuL. All rights reserved.
//

#import <UIKit/UIKit.h>

#define cOff  [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]
#define cOn   [UIColor colorWithRed:255/255.0 green:51/255.0 blue:0 alpha:1]
#define dxSpan 10
#define dySpan 5

typedef void(^TagOnClick)(NSInteger index);

@interface Util_ScrollTagView : UIView
@property (strong,nonatomic) UIScrollView *scrollview;
@property(nonatomic, retain)NSArray *titles;                 // 所有要显示tag的title
@property(nonatomic, retain)NSMutableArray *buttons;                // 保存所有tag
@property(nonatomic, assign)NSInteger defaultIndex;                 // 当前默认选择的index
@property(nonatomic, assign)NSInteger currentIndex;                 // 当期选择的index
@property (assign,nonatomic) CGFloat xSpan;                         // 按钮与按钮之间间距 #-span-#
@property (assign,nonatomic) CGFloat ySpan;                         // 下划线与字的间距
@property(nonatomic, copy)TagOnClick tagCallBack;
/**
 初始化参数

 @param titles 一个array，里面放你想要展示的标题
 @param index 默认点亮位置，如 pos = 0 默认选第一个按钮， pos = 1 ，默认选第二个按钮
 */
- (void)setUpByTitles:(NSMutableArray *)titles defaultIndex:(NSInteger)index;

/**
 点亮某个按钮

 @param index 为位置，从 0开始
 */
- (void)selectIndex:(NSInteger)index;
/// 刷新view
- (void)refreshTagSrollView;

@end

