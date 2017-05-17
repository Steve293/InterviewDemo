//
//  ViewController.m
//  InterviewDemo
//
//  Created by stave on 2017/5/16.
//  Copyright © 2017年 stave. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate>
@property(strong,nonatomic)UITableView *myTableView;
@property(strong,nonatomic)NSMutableArray *visableArr;
@property(strong,nonatomic)UISearchBar *searchBar;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMytableView];
    self.title=@"购物车";
    //设置导航条颜色
///    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNa] forBarMetrics:UIBarMetricsDefault];
    
    //设置状态栏字体颜色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)initMytableView{
    self.searchBar=[[UISearchBar alloc]init];
    self.navigationItem.titleView=self.searchBar;
    self.searchBar.delegate=self;
    self.searchBar.placeholder=@"请输入要搜索的用户名";
    [self.searchBar sizeToFit];
    for (UIView *v in self.searchBar.subviews)
    {
        if ([v isKindOfClass:[UIButton class]])
        {
            [(UIButton *)v setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
    
    self.myTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.myTableView.dataSource=self;
    self.myTableView.delegate=self;
    [self.view addSubview:self.myTableView];
    
    
}


-(void)setwork{
    [MHNetworkManager getRequstWithURL:API_SEARCH params:@{@"q": _searchBar.text} successBlock:^(id returnData, int code, NSString *msg) {
        if (returnData[@"items"]) {
            _visableArr=nil;
            _visableArr=[NSMutableArray array];
            for (NSDictionary *dic in returnData[@"items"]) {
                [self dataSoure:@{@"name": dic[@"login"],@"avatar_url":dic[@"avatar_url"]}];
            }
        }
        
        
    } failureBlock:^(NSError *error, int errorCode) {
        
    } showHUD:YES];
    
}

-(void)dataSoure:(NSDictionary *)dic{
    [MHNetworkManager getRequstWithURL:API_REPOS(dic[@"name"]) params:nil successBlock:^(id returnData, int code, NSString *msg) {
        if ([returnData isKindOfClass:[NSArray class]]) {
            NSMutableArray *lagulageArr=[NSMutableArray array];
            for (NSDictionary *dic1 in returnData) {
                if ([dic1[@"language"] isKindOfClass:[NSString class]]) {
                    [lagulageArr addObject:dic1[@"language"]];
                }else{
                  //  [lagulageArr addObject:@"A"];
                }
            }
            
            NSUInteger temp2 = 0;
            NSUInteger index = 0;
            for (int i = 0; i<lagulageArr.count; i++) {
                NSUInteger temp1 = 0;
                for (int j = 0; j<lagulageArr.count; j++) {
                    if ([lagulageArr[j] isEqual:lagulageArr[i]]) {
                        temp1++;
                    }
                }
                if (temp1>temp2) {
                    temp2 = temp1;
                    index = i;
                }
            }
            CellMode *mode=[[CellMode alloc]init];
            mode.name=[NSString stringWithString:dic[@"name"]];
            mode.url=[NSString stringWithString:dic[@"avatar_url"]];
            if (lagulageArr.count!=0) {
                mode.language=[NSString stringWithString:lagulageArr[index]];
                NSLog(@"woshiwo::%@",lagulageArr[index]);
            }else{
                mode.language=@"无";
            }
            [_visableArr addObject:mode];
            [_myTableView reloadData];
            
        }
    } failureBlock:^(NSError *error, int errorCode) {
        
    } showHUD:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_visableArr) {
        return _visableArr.count;
    }
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    if (!cell) {
        cell=[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil].lastObject;
    }
    cell.mode=_visableArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_searchBar resignFirstResponder];
}


//searchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    //    NSLog(@"%i",[_dataList count]);
   
    
}

-(BOOL)isSearchStr:(NSString *)searchText andSearchModeStr:(NSString *)str{
    BOOL isSearch=YES;
    for (NSString *tempStr in [searchText componentsSeparatedByString:@" "]) {
        NSString *strw=[tempStr  stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (strw.length>0) {
            if (!([str rangeOfString:strw options:NSCaseInsensitiveSearch].length >0)) {
                isSearch=NO;
            }
        }
    }
    
    
    return isSearch;
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [_searchBar resignFirstResponder];
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    if (searchBar.text.length==0||[searchBar.text isEqual:@""]) {
        
    }else{
        [self setwork];
    }
    return YES;
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
