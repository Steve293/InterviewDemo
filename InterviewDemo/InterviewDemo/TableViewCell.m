//
//  TableViewCell.m
//  InterviewDemo
//
//  Created by stave on 2017/5/17.
//  Copyright © 2017年 stave. All rights reserved.
//

#import "TableViewCell.h"


@interface TableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImge;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *language;

@end

@implementation TableViewCell

-(void)setMode:(CellMode *)mode{
    [_headImge sd_setImageWithURL:[NSURL URLWithString:mode.url] placeholderImage:[UIImage imageNamed:@"timg"]];
    _name.text=[NSString stringWithFormat:@"用户名：%@",mode.name];
    _language.text=[NSString stringWithFormat:@"常用语：%@",mode.language];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
