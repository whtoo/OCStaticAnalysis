@interface OurClass

@property (nonatomic,assign) CGFloat pa;
@property (nonatomic,assign) CGFloat pb;

@end

@implementation OurClass

- (void)run {
    CGFloat ta = 4.3;
    pb = 13.3;
    pa = pb * 2 - ta + (2 + 3)
}

@end
