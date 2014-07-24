#include <vector>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Preparing delegate

typedef void (*OnUrlChangingFunctionType)(NSString *);
typedef void (*OnCloseClickedFunctionType)();

@interface OpenFLWebViewDelegate : NSObject <UIWebViewDelegate>
@property (nonatomic) OnUrlChangingFunctionType onUrlChanging;
@property (nonatomic) OnCloseClickedFunctionType onCloseClicked;
@end

@implementation OpenFLWebViewDelegate
@synthesize onUrlChanging;
@synthesize onCloseClicked;
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    onUrlChanging([[request URL] absoluteString]);
    return YES;
}
- (void) onCloseButtonClicked:(UIButton *)closeButton {
    onCloseClicked();
}
@end

// webview
// declaration

@interface OpenFLWebView : UIWebView
@property (assign) int mId;
@property (assign) int mWidth;
@property (assign) int mHeight;

+ (int)lastWebViewId;
- (id)initWithUrlAndFrame: (NSString*)url width: (int)width height: (int)height;
- (int)getId;
@end

// implementation

@implementation OpenFLWebView

@synthesize mId;
@synthesize mWidth;
@synthesize mHeight;

static int mLastWebViewId;

- (id)initWithUrlAndFrame: (NSString*)url width: (int)width height: (int)height{
    mId = mLastWebViewId;
    ++mLastWebViewId;
    NSURL* _url = [[NSURL alloc] initWithString:url];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:_url];
    self = [self initWithFrame: CGRectMake( 0, 0, width, height)];
    [self loadRequest:req];
    return self;
}

- (int)getId {
    return mId;
}

+ (int)lastWebViewId {
    return mLastWebViewId;
}
@end

// used from external interface
// ??? can mix objective c and c++ in the same file / function ?

namespace openflwebview {
    
    void test(){
        NSLog(@"Hello world!");
        
        OpenFLWebViewDelegate* webView = [[OpenFLWebViewDelegate alloc] init];
        
        CGRect screen = [[UIScreen mainScreen] bounds];
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        
        CGRect dim = CGRectMake(100, 100, 200, 200);
        
        UIWebView* instance = [[UIWebView alloc] initWithFrame:dim];
        instance.opaque = NO;
        instance.backgroundColor = [UIColor clearColor];
        [[[UIApplication sharedApplication] keyWindow] addSubview:instance];
        
        NSURL *_url = [[NSURL alloc] initWithString:@"http://www.baudon.me"];
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:_url];
        [instance loadRequest:req];
        
    }
    
    static std::vector<OpenFLWebView*> webViews;
    
    /**
     * Create a WebView
     * @param url default url to load
     * @param width webview width
     * @param height webview height
     */
    int create(const char* url, int width, int height){
        NSString* defaultUrl = [[NSString alloc] initWithUTF8String:url];
        OpenFLWebView* webView = [[OpenFLWebView alloc] initWithUrlAndFrame:defaultUrl width:width height:height];
        webViews.push_back(webView);
        return [webView getId];
    }
    
    /**
     * get the webView with corresponding id
     * @param id
     **/
    OpenFLWebView* getWebView(int id){
        std::vector<OpenFLWebView*>::iterator iter = webViews.begin();
        while(iter != webViews.end()){
            OpenFLWebView* current = *iter;
            if([current getId] == id)
                return current;
        }
        return NULL;
    }
    
    void onAdded(int id){
        OpenFLWebView* webView = getWebView(id);
        [[[UIApplication sharedApplication] keyWindow] addSubview: webView];
    }
    
    void onRemoved(int id){
        OpenFLWebView* webView = getWebView(id);
        [webView removeFromSuperview];
    }
    
}