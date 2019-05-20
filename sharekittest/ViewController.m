#import "ViewController.h"
#import "ShareKit/RequestButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // initialize the button at a particular position in your screen
    CGRect frame = CGRectMake(20, 90, 300, 90);
    RequestButton *bloomButton = [[RequestButton alloc] initWithFrame:frame];
    
    //set the request data
    NSMutableDictionary *requestData =  [NSMutableDictionary dictionary];
    [requestData setObject:action_attestation forKey:@"action"];
    [requestData setObject:@"0x8f31e48a585fd12ba58e70e03292cac712cbae39bc7eb980ec189aa88e24d043" forKey:@"token"];
    [requestData setObject:@"https://receive-kit.bloom.co/api/receive" forKey:@"url"];
    [requestData setObject:@"https://bloom.co/images/notif/bloom-logo.png" forKey:@"org_logo_url"];
    [requestData setObject:@"Bloom" forKey:@"org_name"];
    [requestData setObject:@"https://bloom.co/legal/terms" forKey:@"org_usage_policy_url"];
    [requestData setObject:@"https://bloom.co/legal/privacy" forKey:@"org_privacy_policy_url"];
    // and the attestation types
    NSArray *attestationTypes = @[@"full-name",@"phone",@"email"];
    [requestData setObject:attestationTypes forKey:@"types"];
    
    //and callback url for your app
    NSString *callBackUrl = @"https://google.com";
    
    // then set the request data
    [bloomButton setRequestData:requestData withCallbackUrl:callBackUrl];
    
    //finally add the button to your view
    [self.view addSubview:bloomButton];
}


@end

