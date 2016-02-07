//
//  ViewController.h
//  InstaDown
//
//  Created by Amir Farsad on 2/5/16.
//  Copyright © 2016 Emersad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *instagramURL;
- (IBAction)pasteBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *wView;

@end

