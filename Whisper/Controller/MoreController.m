//
//  MoreController.m
//  Whisper
//
//  Created by kino on 14-10-16.
//
//

#import "MoreController.h"

#import "HIMenuItem.h"

@interface MoreController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

KOArray memuItems;

@end

@implementation MoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"Cell"];
    
    self.memuItems = @[[HIMenuItem itemWithIndent:@"消息中心" contentView:nil info:nil],
                       [HIMenuItem itemWithIndent:@"" contentView:nil info:nil],
                       [HIMenuItem itemWithIndent:@"各种设置" contentView:nil info:nil],
                       [HIMenuItem itemWithIndent:@"" contentView:nil info:nil],
                       [HIMenuItem itemWithIndent:@"关于应用" contentView:nil info:nil]];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma maek - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.memuItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HIMenuItem *item = _memuItems[indexPath.row];
    if([item.cellIndent isEqualToString:@""]) return 20;
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                            forIndexPath:indexPath];
    HIMenuItem *item = _memuItems[indexPath.row];
    cell.textLabel.text = item.cellIndent;
    
    if([item.cellIndent isEqualToString:@""]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
