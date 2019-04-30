#import "RequestButton.h"

@interface RequestButton()

  @property (strong, nonatomic) IBOutlet UIView *contentView;
  @property (strong, nonatomic) NSMutableDictionary *bloomRequestData;
  @property (strong, nonatomic) NSString *buttonCallbackUrl;
- (IBAction)bloomButtonTapped:(id)sender;

@end

@interface NSString (NSString_Extended)

- (NSString *_Nonnull)bloomEncodeURL;

@end


@implementation RequestButton

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) [self setup];
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) [self setup];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) [self setup];
    return self;
}

- (void)setup {
    NSString *frameworkBundleId = @"com.bloom.sharekit";
    NSBundle *resourcesBundle = [NSBundle bundleWithIdentifier:frameworkBundleId];
    [resourcesBundle loadNibNamed:@"RequestButton" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
}

- (void)setRequestData:(NSMutableDictionary *)requestData withCallbackUrl:(NSString *)callbackUrl {
    // append the share-kit-from=button query url
    if([requestData objectForKey:@"url"] != nil){
        NSMutableString *newUrl = [NSMutableString string];
        [newUrl appendString:[requestData objectForKey:@"url"]];
        [newUrl appendString:@"?share-kit-from=button"];
        [requestData setObject:newUrl forKey:@"url"];
    }
    _bloomRequestData = requestData;
    _buttonCallbackUrl = callbackUrl;
}

- (NSString *)getBloomLink {
    
    NSError *err;
    // get the json data from the dictionary
    NSData *jsonRequestData = [NSJSONSerialization dataWithJSONObject:_bloomRequestData options:NSJSONWritingPrettyPrinted error:&err];
    //stringify it
    NSString *stringifiedRequestData = [[NSString alloc] initWithData:jsonRequestData encoding:NSUTF8StringEncoding];
    // then base64 encode it
    NSString *base64EncodedRequestData = [[stringifiedRequestData dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    // init the link string
    NSMutableString *link = [NSMutableString string];
    // then encode the callback url
    NSString *encodedCallbackUrl = [_buttonCallbackUrl bloomEncodeURL];
    // setup the url with the base64 encoded string
    [link appendString:@"https://bloom.co/download?request="];
    [link appendString:base64EncodedRequestData];
    // append the callback url
    [link appendString:@"&callback-url="];
    [link appendString:encodedCallbackUrl];
    // then return it
    return link;
}

- (IBAction)bloomButtonTapped:(id)sender {
    // generate the bloom link
    NSString *bloomLink = [self getBloomLink];
    // open the link in the app
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: bloomLink]];
}

@end

@implementation NSString (NSString_Extended)

- (NSString *_Nonnull)bloomEncodeURL {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    NSUInteger sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

@end
