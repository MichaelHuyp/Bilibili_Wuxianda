//
//  YPUIDynamicDemoController.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/13.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPUIDynamicDemoController.h"

@interface YPUIDynamicDemoController ()

@property (weak, nonatomic) IBOutlet UIView *blueView;

@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segView;

@end

@implementation YPUIDynamicDemoController

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        // 1.创建物理仿真器(ReferenceView(参照视图，其实就是设置仿真范围))
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 获得触摸点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    // 创建吸附\捕捉行为
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.blueView snapToPoint:point];
    // 防抖系数(值越小, 越抖)
    snap.damping = 1.0;
    
    // 添加行为
    [self.animator removeAllBehaviors];
    [self.animator addBehavior:snap];

    
}

- (void)testCollision
{
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];
    [gravity addItem:self.blueView];
    
    // 2.创建 碰撞行为
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] init];
    // 让参照视图的bounds变为碰撞检测的边框
//    collision.translatesReferenceBoundsIntoBoundary = YES;
    
    // 添加边界
    //    CGFloat startX = 0;
    //    CGFloat startY = self.view.frame.size.height * 0.5;
    //    CGFloat endX = self.view.frame.size.width;
    //    CGFloat endY = self.view.frame.size.height;
    //    [collision addBoundaryWithIdentifier:@"line1" fromPoint:CGPointMake(startX, startY) toPoint:CGPointMake(endX, endY)];
    //    [collision addBoundaryWithIdentifier:@"line2" fromPoint:CGPointMake(endX, 0) toPoint:CGPointMake(endX, endY)];
    
    CGFloat width = self.view.frame.size.width;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, width, width)];
    [collision addBoundaryWithIdentifier:@"circle" forPath:path];
    
    
    [collision addItem:self.blueView];
    [collision addItem:self.segView];
    
    // 3.添加行为
    [self.animator addBehavior:collision];
    [self.animator addBehavior:gravity];
}

/**
 *  重力行为
 */
- (void)testGravity
{
    // 2.创建物理仿真行为 - 重力行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];
    [gravity addItem:self.blueView];
    // 重力方向
    gravity.gravityDirection = CGVectorMake(1, 1);
    
    // 重力加速度 (移动的距离 = 1 / 2 * magnitude * 时间²)
    gravity.magnitude = 100;
    
    // 3.添加物理仿真行为到物理仿真器中，开始物理仿真
    [self.animator addBehavior:gravity];
}

@end






















































