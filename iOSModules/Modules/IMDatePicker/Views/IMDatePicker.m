//
//  IMDatePicker.m
//  iOSModules
//
//  Created by 石城磊 on 29/01/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import "IMDatePicker.h"
#import "IMYearModel.h"
#import "IMMonthModel.h"

@interface IMDatePicker ()
<
    UIPickerViewDelegate,
    UIPickerViewDataSource
>

@property (nonatomic, strong)   UIView       *imDatePickerContainerView;
@property (nonatomic, strong)   UIPickerView *imDatePickerView;
@property (nonatomic, strong)   UIButton     *cancelButton;
@property (nonatomic, strong)   UIButton     *confirmButton;

@property (nonatomic, strong)   NSMutableArray *imYearsMutArray;
@property (nonatomic, strong)   NSMutableArray *imMonthsMutArray;
@property (nonatomic, strong)   NSMutableArray *imDaysMutArray;
@property (nonatomic, strong)   NSMutableArray *imHoursMutArray;
@property (nonatomic, strong)   NSMutableArray *imMinutesMuArray;

@property (nonatomic, strong)   NSCalendar      *currentCalendar;
@property (nonatomic, strong)   NSDateComponents*dateComponents;

@end

@implementation IMDatePicker


- (instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        [self setUpDateSource];
    }
    return self;
}

- (void)layoutSubviews {
    [self setUpIMDatePicker];
}

- (void)setUpDateSource {
    self.currentCalendar                =   [NSCalendar currentCalendar];
    [self.currentCalendar setLocale:[NSLocale systemLocale]];
    //
    NSCalendarUnit formatUnit           =   (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitSecond);
    self.dateComponents                 =   [self.currentCalendar components:formatUnit fromDate:[NSDate date]];
    NSInteger currentYear               =   [self.dateComponents year];
    //
    self.imYearsMutArray    =   [NSMutableArray arrayWithCapacity:100];
    for (NSInteger index = 0; index < 100; index++) {
        IMYearModel *yearModel  =   [[IMYearModel alloc] init];
        NSInteger aYear         =   currentYear + index;
        yearModel.im_Year       =   @(aYear);
        NSMutableArray *monthMutArr =   [NSMutableArray arrayWithCapacity:12];
        for (NSInteger mIndex = 1 ; mIndex <= 12; mIndex++) {
            BOOL isLeapYear =   ((aYear%4==0 && aYear%100!=0) || aYear%400==0);
            IMMonthModel *monthModel    =   [[IMMonthModel alloc] init];
            NSInteger daysInMonth       =   0;
            switch (mIndex) {
                case 1:
                case 3:
                case 5:
                case 7:
                case 8:
                case 10:
                case 12:
                    daysInMonth =   31;
                    break;
                case 4:
                case 6:
                case 9:
                case 11:
                    daysInMonth =   30;
                    break;
                case 2:
                    daysInMonth =   isLeapYear?29:28;
                    break;
                default:
                    break;
            }
            NSMutableArray *dayMutArr   =   [NSMutableArray arrayWithCapacity:daysInMonth];
            for (NSInteger dayIndex = 1; dayIndex <= daysInMonth; dayIndex++) {
                [dayMutArr addObject:@(dayIndex)];
            }
            monthModel.im_Month_Days    =   [NSArray arrayWithArray:dayMutArr];
            [monthMutArr addObject:monthModel];
        }
        yearModel.im_Year_Months    =   [NSArray arrayWithArray:monthMutArr];
        [self.imYearsMutArray addObject:yearModel];
    }
    for (NSInteger hourIndex = 0; hourIndex < 24; hourIndex++) {
        if (!self.imHoursMutArray) {
            self.imHoursMutArray    =   [NSMutableArray arrayWithCapacity:24];
        }
        [self.imHoursMutArray addObject:@(hourIndex)];
    }
    for (NSInteger minuteIndex = 0; minuteIndex < 60; minuteIndex++) {
        if (!self.imMinutesMuArray) {
            self.imMinutesMuArray    =   [NSMutableArray arrayWithCapacity:60];
        }
        [self.imMinutesMuArray addObject:@(minuteIndex)];
    }
}

- (void)setUpIMDatePicker {
    UIView *buttonsView =   [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.bounds),  CGRectGetHeight(self.bounds)/5)];
    [buttonsView setBackgroundColor:[UIColor blueColor]];
    [self addSubview:buttonsView];
    //
    self.cancelButton   =   [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelButton setFrame:CGRectMake(8.0f, 0.0f, CGRectGetWidth(buttonsView.bounds)/4, CGRectGetHeight(buttonsView.bounds))];
    [self.cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [buttonsView addSubview:self.cancelButton];
    //
    self.confirmButton  =   [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [self.confirmButton setFrame:CGRectMake(CGRectGetMaxX(buttonsView.frame)-CGRectGetWidth(buttonsView.bounds)/4-8.0f, 0.0f, CGRectGetWidth(buttonsView.bounds)/4, CGRectGetHeight(buttonsView.bounds))];
    [self.confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [buttonsView addSubview:self.confirmButton];
    //
    [self.imDatePickerView setFrame:CGRectMake(0.0f, CGRectGetHeight(self.bounds)/5, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)/5*4)];
    [self addSubview:self.imDatePickerView];
    //
    NSInteger year  =   [self.dateComponents year];
    for (IMYearModel *yearModel in self.imYearsMutArray) {
        if ([yearModel.im_Year integerValue] == year) {
            self.imMonthsMutArray   =   [NSMutableArray arrayWithArray:yearModel.im_Year_Months];
            NSInteger month =   [self.dateComponents month];
            IMMonthModel *monthModel    =   yearModel.im_Year_Months[month-1];
            if (!self.imDaysMutArray) {
                self.imDaysMutArray    =   [NSMutableArray arrayWithArray:monthModel.im_Month_Days];
            }
            [self.imDatePickerView reloadAllComponents];
        }
    }
    [self.imDatePickerView selectRow:0 inComponent:0 animated:YES];
    [self.imDatePickerView selectRow:[self.dateComponents month]-1 inComponent:1 animated:YES];
    [self.imDatePickerView selectRow:[self.dateComponents day] inComponent:2 animated:YES];
}

- (void)cancelButtonAction {
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha  =   0.0f;
    } completion:^(BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
    }];
}

- (void)confirmButtonAction {
    NSDateComponents  *dateComponents   =   [[NSDateComponents alloc] init];
    [dateComponents setCalendar:self.currentCalendar];
    NSInteger yearIndex                 =   [self.imDatePickerView selectedRowInComponent:0];
    IMYearModel *yearModel              =   self.imYearsMutArray[yearIndex];
    [dateComponents setYear:[yearModel.im_Year integerValue]];
    NSInteger monthIndex                =   [self.imDatePickerView selectedRowInComponent:1];
    [dateComponents setMonth:monthIndex+1];
    NSInteger dayIndex                  =   [self.imDatePickerView selectedRowInComponent:2];
    [dateComponents setDay:dayIndex+1];
    NSInteger hourIndex                 =   [self.imDatePickerView selectedRowInComponent:3];
    [dateComponents setHour:hourIndex];
    NSInteger minuteIndex               =   [self.imDatePickerView selectedRowInComponent:4];
    [dateComponents setMinute:minuteIndex];
    NSDate *selectedDate                =   [dateComponents date];
    //
    NSDateFormatter *dateFormatter      =   [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *selectedDateName          =   [dateFormatter stringFromDate:selectedDate];
    if (self.selectDateCompletionHandler) {
        self.selectDateCompletionHandler(@{@"Name":selectedDateName,@"Date":selectedDate});
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return self.imYearsMutArray.count;
            break;
        case 1:
            return 12;
            break;
        case 2:
            return self.imDaysMutArray.count;
            break;
        case 3:
            return self.imHoursMutArray.count;
            break;
        case 4:
            return self.imMinutesMuArray.count;
            break;
        default:
            break;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            IMYearModel *yModel =   self.imYearsMutArray[row];
            return [NSString stringWithFormat:@"%ld",(long)[yModel.im_Year integerValue]];
        }
            break;
        case 1:
        {
            return [NSString stringWithFormat:@"%ld月",(long)row+1];
        }
            break;
        case 2:
        {
            NSInteger day   =   [self.imDaysMutArray[row] integerValue];
            return [NSString stringWithFormat:@"%ld日",(long)day];
        }
            break;
        case 3:
        {
            NSInteger hour  =   [self.imHoursMutArray[row] integerValue];
            return [NSString stringWithFormat:@"%ld时",(long)hour];
        }
            break;
        case 4:
        {
            NSInteger minute  =   [self.imMinutesMuArray[row] integerValue];
            return [NSString stringWithFormat:@"%ld分",(long)minute];
        }
            break;
        default:
            break;
    }
    return @"";
}

#pragma mark - UIPIckerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            [self updatePickerViewYearDataSource];
        }
            break;
        case 1:
        {
            [self updatePickerViewMonthDataSource];
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
        default:
            break;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 75.0f;
}

#pragma mark -
- (void)updatePickerViewYearDataSource {
    NSInteger yearIndex     =   [self.imDatePickerView selectedRowInComponent:0];
    IMYearModel *yearModel  =   self.imYearsMutArray[yearIndex];
    self.imMonthsMutArray   =   [NSMutableArray arrayWithArray:yearModel.im_Year_Months];
    NSInteger monthIndex    =   [self.imDatePickerView selectedRowInComponent:1];
    IMMonthModel *monthModel=   self.imMonthsMutArray[monthIndex];
    self.imDaysMutArray     =   [NSMutableArray arrayWithArray:monthModel.im_Month_Days];
    [self.imDatePickerView reloadComponent:1];
    [self.imDatePickerView reloadComponent:2];
}

- (void)updatePickerViewMonthDataSource {
    NSInteger       monthIndex      =   [self.imDatePickerView selectedRowInComponent:1];
    IMMonthModel *monthModel        =   self.imMonthsMutArray[monthIndex];
    self.imDaysMutArray             =   [NSMutableArray arrayWithArray:monthModel.im_Month_Days];
    [self.imDatePickerView reloadComponent:2];
}

#pragma mark - Initializations
- (UIPickerView *)imDatePickerView {
    if (!_imDatePickerView) {
        _imDatePickerView           =   [[UIPickerView alloc] init];
        _imDatePickerView.delegate  =   self;
        _imDatePickerView.dataSource=   self;
    }
    return _imDatePickerView;
}

@end
