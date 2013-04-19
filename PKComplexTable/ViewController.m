//
//  ViewController.m
//  PKComplexTable
//
//  Created by Philipp Koulen on 19.04.13.
//  Copyright (c) 2013 Philipp Koulen. All rights reserved.
//

#import "ViewController.h"

#define LETTERS @" abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"


@interface ViewController (){
    NSMutableArray *tableContent;
}

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];

    //init my table datasource
    tableContent = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < 30; i++) {
        NSMutableArray *sectionContent = [[NSMutableArray alloc] init];

        int maxArrayLength = 10;
        int rndArrayLength =  arc4random() % (maxArrayLength );
        int maxStringLength = 500;
        int rndStringLength =  arc4random() % (maxStringLength );

        for (unsigned k = 0; k < rndArrayLength; k++) {
            [sectionContent addObject:[self genRandStringLength:rndStringLength]];
        }
        [tableContent addObject:sectionContent];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIScrollView *containerSV = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    containerSV.backgroundColor = [UIColor clearColor];

    [self.view addSubview:containerSV];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    //calculate the max width of the table content
    CGFloat maxWidth = 0;
    for (NSMutableArray *array in tableContent) {
        for (NSString *text in array) {
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(9999, 30) lineBreakMode:NSLineBreakByTruncatingTail];
            if (size.width > maxWidth) {
                maxWidth = size.width;
            }
        }
    }
    
    //set the frame appropriate
    tableView.frame = CGRectMake(0, 0, maxWidth, self.view.bounds.size.height);
    
    //set the scrollviewContentSize
    containerSV.contentSize = CGSizeMake(maxWidth, self.view.bounds.size.height);
    
    //add the table
    [containerSV addSubview: tableView];
    
}

#pragma mark - Method for random String with certain length -
- (NSString *) genRandStringLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [LETTERS characterAtIndex: arc4random() % [LETTERS length]]];
    }
    
    return randomString;
}


#pragma mark - UITableView dataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [tableContent count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[tableContent objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self genRandStringLength:100];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.text = [[tableContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSLog(@"cell.font: %@", cell.textLabel.font);
    }
    return cell;
}

#pragma mark - UITableView delegate -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
