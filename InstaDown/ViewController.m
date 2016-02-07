//
//  ViewController.m
//  InstaDown
//
//  Created by Amir Farsad on 2/5/16.
//  Copyright © 2016 Emersad. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_wView setBackgroundColor:[UIColor clearColor]];
    [_wView setOpaque:NO];
  /*  NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"help" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [_wView loadHTMLString:htmlString baseURL:nil];*/
    NSString *fileName = @"help";
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"html" subdirectory:nil];
    [self.wView loadRequest:[NSURLRequest requestWithURL:fileURL]];

}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)DownloadVideo
{
        NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *filePath = [docPath stringByAppendingPathComponent:@"temp.mp4"];
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *urlToDownload = [prefs stringForKey:@"URLToSave"];
        NSLog(@"Downloading Started");
        NSURL *url = [NSURL URLWithString:urlToDownload];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        if ( urlData )
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"temp.mp4"];
                [urlData writeToFile:filePath atomically:YES];
                NSLog(@"File Saved !");
            NSURL *movieURL = [NSURL fileURLWithPath:filePath];
            UISaveVideoAtPathToSavedPhotosAlbum(filePath,nil,nil,nil);
            NSLog(@"Check Gallery");

        }
}

- (IBAction)pasteBtn:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"در حال دریافت";
    [_instagramURL resignFirstResponder];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        if ([pasteboard.string containsString:@"instagram"]) {
            NSString *urlToDownload = _instagramURL.text;
            /*@"https://www.instagram.com/p/BBQdVvqSMgi/";*/
            
            NSURL *strToURL = [NSURL URLWithString:urlToDownload];
            NSString *resultStr = [NSString stringWithContentsOfURL:strToURL encoding:NSUTF8StringEncoding error:nil];
            
            NSString *url = nil;
            NSScanner *theScanner = [NSScanner scannerWithString:resultStr];
            [theScanner scanUpToString:@"<meta property=\"og:type\"" intoString:nil];
            if (![theScanner isAtEnd]) {
                [theScanner scanUpToString:@"content" intoString:nil];
                NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"\"'"];
                [theScanner scanUpToCharactersFromSet:charset intoString:nil];
                [theScanner scanCharactersFromSet:charset intoString:nil];
                [theScanner scanUpToCharactersFromSet:charset intoString:&url];
                if ([url isEqualToString:@"video"]) {
                    NSString *url = nil;
                    NSScanner *theScanner = [NSScanner scannerWithString:resultStr];
                    [theScanner scanUpToString:@"<meta property=\"og:video\"" intoString:nil];
                    if (![theScanner isAtEnd]) {
                        [theScanner scanUpToString:@"content" intoString:nil];
                        NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"\"'"];
                        [theScanner scanUpToCharactersFromSet:charset intoString:nil];
                        [theScanner scanCharactersFromSet:charset intoString:nil];
                        [theScanner scanUpToCharactersFromSet:charset intoString:&url];
                        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                        [prefs setObject:url forKey:@"URLToSave"];
                        [self DownloadVideo];
                        
                    }
                    
                }
                else {
                    NSString *url = nil;
                    NSScanner *theScanner = [NSScanner scannerWithString:resultStr];
                    [theScanner scanUpToString:@"<meta property=\"og:image\"" intoString:nil];
                    if (![theScanner isAtEnd]) {
                        [theScanner scanUpToString:@"content" intoString:nil];
                        NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"\"'"];
                        [theScanner scanUpToCharactersFromSet:charset intoString:nil];
                        [theScanner scanCharactersFromSet:charset intoString:nil];
                        [theScanner scanUpToCharactersFromSet:charset intoString:&url];
                        UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]], nil, nil, nil);
                    }
                    else {
                        NSLog(@"Wrong:)");
                    }
                    
                }
            }
            else {
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_instagramURL resignFirstResponder];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        });
        
        
    });
}

@end
