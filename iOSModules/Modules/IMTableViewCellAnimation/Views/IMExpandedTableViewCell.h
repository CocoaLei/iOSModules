//
//  IMExpandedTableViewCell.h
//  iOSModules
//
//  Created by 石城磊 on 2018/1/13.
//  Copyright © 2018年 石城磊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^IMTableViewCellExpandBLOCK)(NSIndexPath *indexPath);

@interface IMExpandedTableViewCell : UITableViewCell

@property (nonatomic, strong)   NSIndexPath                 *indexPath;
@property (nonatomic, copy  )   IMTableViewCellExpandBLOCK  expandBlock;

@end
