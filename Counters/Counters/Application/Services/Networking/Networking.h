
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


// MARK: - Completion Handler
typedef void (^JSONCompletionHandler) (id _Nullable object, NSError * _Nullable error);
typedef void (^DataCompletionHandler) (id _Nullable object, NSError * _Nullable error);

// MARK: - Error
extern NSErrorDomain const CountersErrorDomain;

typedef NS_ENUM(NSInteger, CountersErrorCode) {
    CountersErrorCodeNoData = -777
};

// MARK: - Networking
@interface Networking : NSObject
- (NSURLSessionTask *)jsonRequestURL:(NSURL *)url
                          HTTPMethod:(NSString *)method
                          parameters:(NSDictionary<NSString*, NSString*>*)parameters
                   completionHandler:(JSONCompletionHandler)completion;

- (NSURLSessionTask *)dataRequestURL:(NSURL *)url
                      HTTPMethod:(NSString *)method
                      parameters:(NSDictionary<NSString*, NSString*>* _Nullable)parameters
                   completionHandler:(DataCompletionHandler)completion;

@end

NS_ASSUME_NONNULL_END
