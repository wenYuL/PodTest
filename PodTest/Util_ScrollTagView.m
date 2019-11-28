//
//  Util_ScrollTagView.m
//  ScrollTag
//
//  Created by 刘文裕 on 2019/11/27.
//  Copyright © 2019 wenYuL. All rights reserved.
//

#import "Util_ScrollTagView.h"
#import "Util_ScrollViewButton.h"
#import <Masonry.h>

@interface Util_ScrollTagView ()<UIScrollViewDelegate>

@property (strong,nonatomic) UIView *movLine;
@property(nonatomic, strong)Util_ScrollViewButton *currentSelectButton;

@end

@implementation Util_ScrollTagView

/**
    初始化方法，纯代码创建会调用这个方法。
 */
- (instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if( self ) {
        [self initSelfSetting];
        [self initSubViews];
        [self initSubViewAutoLayout];
    }
    return self;
}

/**
    初始化方法，xib创建会调用这个方法。
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if( self ) {
        [self initSelfSetting];
        [self initSubViews];
        [self initSubViewAutoLayout];
    }
    return self;
}

- (void)setUpByTitles:(NSMutableArray *)titles defaultIndex:(NSInteger)index {
    self.titles = titles;
    self.defaultIndex = index;
}

- (void)selectIndex:(NSInteger)index {
    NSAssert(index >=0 && index< self.buttons.count, @"#Pos 错误，Pos 的范围是否在 [0,titles.count-1] 中");
    [self layoutIfNeeded];
    Util_ScrollViewButton *hbtn = _buttons[index];
    hbtn.click(hbtn.idx, hbtn);
}

/// 刷新view
- (void)refreshTagSrollView {
    [self resetButtons];
    [self makeButtonsByTitles];
    [self buttonsEventSetting];
    NSAssert(self.defaultIndex >=0 && self.defaultIndex< self.buttons.count, @"#defaultButtonPos 错误，defaultButtonPos 的范围是否在 [0,titles.count-1] 中");
    [self layoutIfNeeded];
    [self selectIndex:self.defaultIndex]; // 选择默认的按钮
}

- (void)buttonsEventSetting {
    __weak typeof (self)wsf = self;
    for(Util_ScrollViewButton *button_i in self.buttons ) {
        //设置第i个button的tap事件
        button_i.click = ^(NSInteger idx, Util_ScrollViewButton * _Nonnull sender) {
            [wsf buttonMoveToIndex:idx sender:sender needNotify:YES];
        };
    }
}

- (void)buttonMoveToIndex:(NSInteger)index sender:(Util_ScrollViewButton *)sender needNotify:(BOOL)needNotify {
    self.currentIndex = index;
    if( self.tagCallBack && needNotify ) {
        // 位置放生改变，通知外部
        self.tagCallBack(index);
    }
    self.currentSelectButton.titleLabel.textColor = cOff;
    self.currentSelectButton = sender;
    self.currentSelectButton.titleLabel.textColor = cOn;
    if( self.scrollview.contentSize.width > self.scrollview.frame.size.width ) {
        [self moveToButtonWithAnimate:sender];
    }else{
        [self updateUnderLinePos];
    }
}

- (void)moveToButtonWithAnimate:(Util_ScrollViewButton *)sender {
    CGFloat shouldX = sender.frame.origin.x - self.scrollview.frame.size.width / 2.0 + sender.frame.size.width / 2.0;
    // 右侧的补偿x，offsetRight意味着 scrollview右侧被隐藏部分的宽度。
    CGFloat offsetRight = self.scrollview.contentSize.width - self.scrollview.frame.size.width - shouldX;
    CGPoint shouldPoint = CGPointMake(0, 0);
    if( shouldX > 0 && offsetRight >0) {
        shouldPoint = CGPointMake(shouldX, 0);
    }else {
        if( shouldX <=0 )
            shouldPoint = CGPointMake(0, 0);
        if( offsetRight <=0 )
            shouldPoint = CGPointMake(self.scrollview.contentSize.width - self.scrollview.frame.size.width, 0);
    }
    [self updateUnderLinePos];
    [self.scrollview setContentOffset:shouldPoint animated:YES];
}
/**
    更新下滑线的位置
 */
- (void)updateUnderLinePos {
    if( self.currentSelectButton) {
        self.movLine.hidden = NO;
        CGFloat lWidth = self.currentSelectButton.titleLabel.frame.size.width;
        CGPoint curBtnCenter = CGPointMake(self.currentSelectButton.frame.size.width / 2.0, CGRectGetMaxY(self.currentSelectButton.titleLabel.frame ) + self.ySpan);
        CGPoint desPt = [self.currentSelectButton convertPoint:curBtnCenter toView:self];
        [UIView animateWithDuration:0.3 animations:^{
            [self.movLine setFrame:CGRectMake(CGRectGetMinX(self.movLine.frame), CGRectGetMinY(self.movLine.frame), lWidth, CGRectGetHeight(self.movLine.frame))];
            [self.movLine setCenter:desPt];
        } completion:^(BOOL finished) {
        }];
    }
}

/**
    根据标题数组 重新制作按钮
 */
- (void)makeButtonsByTitles {
    __weak typeof (self)wsf = self;
    UIView *zeroView = [[UIView alloc]init];
    [self.scrollview addSubview:zeroView];
    [zeroView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0);
        make.height.equalTo(@0);
        make.leading.top.equalTo(@0);
    }];
    UIView *lastView = zeroView;
    int pos = 0 ;
    for( NSString *title in _titles ) {
        Util_ScrollViewButton *btn =[Util_ScrollViewButton shareInstanceTagButton];
        btn.idx = pos++;
        [btn.titleLabel setText:title];
        [self.scrollview addSubview:btn]; //加入到scrollview
        [self.buttons addObject:btn]; // 将按钮保存起来，以便之后做清理工作
        [btn.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            // titlelabel ～ 标题标签的约束
            make.leading.equalTo(btn).with.offset(self.xSpan / 2.0);
            make.trailing.equalTo(btn).with.offset(-self.xSpan / 2.0);
            make.centerY.equalTo(btn);
        }];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            //按钮的约束 ，尚未设置width ，由titlelabel 内容撑开
            make.leading.equalTo(lastView.mas_trailing).with.offset(0);
            make.top.equalTo(wsf.scrollview);
            make.height.equalTo(wsf.scrollview);
        }];
        lastView = btn;
    }
    // 为了设置contentsize
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@0);
    }];
}

/**
    重置按钮,清空按钮
    1. 将所有按钮视图remove
    2. 初始化buttons
 */
- (void)resetButtons {
    for( UIView *view in self.buttons ) {
        [view removeFromSuperview];
    }
    _buttons = [[NSMutableArray alloc]init];
}

#pragma mark Init
- (void)initSelfSetting {
    self.clipsToBounds = YES;
    self.xSpan = dxSpan;
    self.ySpan = dySpan;
}

- (void)initSubViews {
    [self addSubview:self.scrollview];
    [self addSubview:self.movLine];
    self.scrollview.delegate = self;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.showsVerticalScrollIndicator = NO;
    [self.movLine setBackgroundColor:[UIColor colorWithRed:1.0 green:51/255.0 blue:0 alpha:1]];
}

- (void)initSubViewAutoLayout {
    __weak typeof (self)wsf = self;
    [self.scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(wsf);
        make.top.equalTo(wsf);
        make.width.equalTo(wsf);
        make.height.equalTo(wsf);
    }];
}

#pragma mark scrollView delegates
/**
    scrollview 发送滚动时系统会调用此方法
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateUnderLinePosNoScroll];
}

- (void)updateUnderLinePosNoScroll {
    if( self.currentSelectButton ) {
        self.movLine.hidden = NO;
        CGFloat lWidth = self.currentSelectButton.titleLabel.frame.size.width;

        CGPoint curBtnCenter = CGPointMake(self.currentSelectButton.frame.size.width / 2.0, CGRectGetMaxY(self.currentSelectButton.titleLabel.frame ) + self.ySpan) ;
        CGPoint desPt = [self.currentSelectButton convertPoint:curBtnCenter toView:self];
        
        [self.movLine setFrame:CGRectMake(CGRectGetMinX(self.movLine.frame), CGRectGetMinY(self.movLine.frame), lWidth, CGRectGetHeight(self.movLine.frame))];
        [self.movLine setCenter:desPt];
    }

}

#pragma mark lazyLoad
- (UIScrollView *)scrollview {
    if( !_scrollview ) {
         _scrollview =  [[UIScrollView alloc]init];
    }
    return _scrollview;
}

- (NSMutableArray *)buttons {
    if( !_buttons ) {
        _buttons = [[NSMutableArray alloc]init];
    }
    return _buttons;
}
- (UIView *)movLine {
    if( !_movLine ) {
        _movLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 23, 2)];
    }
    return _movLine;
}

@end
