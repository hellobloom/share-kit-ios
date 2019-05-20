#import <UIKit/UIKit.h>

const NSString *action_attestation = @"request_attestation_data";

IB_DESIGNABLE
@interface RequestButton : UIView

-(void)setRequestData:(NSMutableDictionary *)requestData withCallbackUrl:(NSString *)callbackUrl;

@end
