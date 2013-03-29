#import <Foundation/Foundation.h>

@interface OAI_ColorManager : NSObject {
    
}

+(OAI_ColorManager* )sharedColorManager;

- (UIColor* ) setColor : (float) red : (float) green : (float) blue;

@end
