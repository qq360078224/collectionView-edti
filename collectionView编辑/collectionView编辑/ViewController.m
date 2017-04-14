//
//  ViewController.m
//  collectionView编辑
//
//  Created by admin on 2017/4/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UICollectionViewCell *cell;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view, typically from a nib.
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    //此处给其增加长按手势，用此手势触发cell移动效果
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    [_collectionView addGestureRecognizer:longGesture];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.dataSource = [NSMutableArray array];
    for (NSInteger i = 0; i < 8; i ++) {
        [self.dataSource addObject:[NSNumber numberWithInteger:i]];
    }
    [self.collectionView reloadData];
    
    
}
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            
            if (indexPath == nil ) {
                break;
            }
            //在路径上则开始移动该路径上的cell
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            //移动过程当中随时更新cell位置

            [self.collectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collectionView]];

            
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            //移动结束后关闭cell移动
            [self.collectionView endInteractiveMovement];
            
            if (self.dataSource.count < 9) {
                
                NSIndexPath *temp = [self.collectionView indexPathForCell:self.cell];
                NSIndexPath *end = [NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0];
                if (temp.row != end.row) {
                    [self.collectionView moveItemAtIndexPath:temp toIndexPath:end];
                }
            }
        }
            break;
        default:
        {
            [self.collectionView cancelInteractiveMovement];
        }
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 80);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.userInteractionEnabled = YES;
    cell.multipleTouchEnabled = YES;
    cell.backgroundColor = [UIColor greenColor];
    
    
    UILabel *la = [[UILabel alloc] init];
    la.frame = CGRectMake(0, 0, 30, 30);
    la.textColor = [UIColor redColor];
    la.text = [NSString stringWithFormat:@"%@", self.dataSource[indexPath.row]];
    [cell.contentView addSubview:la];
    if (indexPath.row == self.dataSource.count - 1) {
        self.cell  = cell;
    }
    return cell;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canFocusItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    //返回YES允许其item移动
    if (indexPath.row == self.dataSource.count - 1 && self.dataSource.count < 9) {
        return NO;
    }    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSNumber *num = self.dataSource[sourceIndexPath.item];
    if (destinationIndexPath.row != self.dataSource.count - 1) {
        [self.dataSource removeObjectAtIndex:sourceIndexPath.item];
        [self.dataSource insertObject:num atIndex:destinationIndexPath.item];
    }
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
