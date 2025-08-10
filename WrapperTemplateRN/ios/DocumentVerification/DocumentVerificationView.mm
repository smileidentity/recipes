//
//  DocumentVerificationView.mm
//  WrapperTemplateRN
//
//  Created by Harun Wangereka on 08/08/2025.
//

#import "DocumentVerificationView.h"
#import "WrapperTemplateRN-Swift.h"

#import <react/renderer/components/RNFabricDeclarativeViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNFabricDeclarativeViewSpec/EventEmitters.h>
#import <react/renderer/components/RNFabricDeclarativeViewSpec/Props.h>
#import <react/renderer/components/RNFabricDeclarativeViewSpec/RCTComponentViewHelpers.h>

using namespace facebook::react;

@interface DocumentVerificationView ()
@property (nonatomic, strong) DocumentVerificationSwiftUIWrapper *swiftUIWrapper;
@property (nonatomic, strong) UIViewController *hostingController;
@end

@implementation DocumentVerificationView

- (instancetype)init
{
    if (self = [super init]) {
        [self setupSwiftUIView];
    }
    return self;
}

- (void)setupSwiftUIView
{
    __weak typeof(self) weakSelf = self;
    
    self.swiftUIWrapper = [[DocumentVerificationSwiftUIWrapper alloc] init];
    self.hostingController = [self.swiftUIWrapper createHostingControllerWithOnButtonTap:^{
        [weakSelf buttonTapped];
    }];
    
    self.hostingController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.hostingController.view];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.hostingController.view.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.hostingController.view.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.hostingController.view.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.hostingController.view.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

- (void)buttonTapped
{
    NSLog(@"Document verification button tapped from SwiftUI!");
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
// Props can still be handled here if needed
[super updateProps:props oldProps:oldProps];
}

- (void)layoutSubviews
{
[super layoutSubviews];
// Layout custom subviews if you add any later
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
return concreteComponentDescriptorProvider<DocumentVerificationViewComponentDescriptor>();
}

@end
