#if RCT_NEW_ARCH_ENABLED
#import "SmartSelfieEnrollmentView.h"

#if __has_include("RnWrap/RnWrap-Swift.h")
#import "RnWrap/RnWrap-Swift.h"
#else
#import "RnWrap-Swift.h"
#endif

#import <react/renderer/components/RnWrapViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/RnWrapViewSpec/EventEmitters.h>
#import <react/renderer/components/RnWrapViewSpec/Props.h>
#import <react/renderer/components/RnWrapViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"

#include <optional>

using namespace facebook::react;

@interface SmartSelfieEnrollmentView () <RCTSmartSelfieEnrollmentViewViewProtocol>
@end

@implementation SmartSelfieEnrollmentView {
  SmartSelfieEnrollmentViewProvider *_provider;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<SmartSelfieEnrollmentViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const SmartSelfieEnrollmentViewProps>();
    _props = defaultProps;

    _provider = [[SmartSelfieEnrollmentViewProvider alloc] init];
    self.contentView = _provider;

    __weak SmartSelfieEnrollmentView *weakSelf = self;
    _provider.onSuccess = ^(NSString *json) {
      SmartSelfieEnrollmentView *strongSelf = weakSelf; if (!strongSelf) return;
      auto emitter = std::static_pointer_cast<const SmartSelfieEnrollmentViewEventEmitter>(strongSelf->_eventEmitter);
      if (!emitter) return;
      SmartSelfieEnrollmentViewEventEmitter::OnSuccess ev{};
      ev.result = std::string([json UTF8String]);
      emitter->onSuccess(std::move(ev));
    };

    _provider.onError = ^(NSString *errorString) {
      SmartSelfieEnrollmentView *strongSelf = weakSelf; if (!strongSelf) return;
      auto emitter = std::static_pointer_cast<const SmartSelfieEnrollmentViewEventEmitter>(strongSelf->_eventEmitter);
      if (!emitter) return;
      SmartSelfieEnrollmentViewEventEmitter::OnError ev{};
      ev.error = std::string([errorString UTF8String]);
      emitter->onError(std::move(ev));
    };
  }
  return self;
}

@end
#endif
