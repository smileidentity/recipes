#if RCT_NEW_ARCH_ENABLED
#import "SmartSelfieAuthenticationView.h"

#if __has_include("RnWrapperRecipe/RnWrapperRecipe-Swift.h")
#import "RnWrapperRecipe/RnWrapperRecipe-Swift.h"
#else
#import "RnWrapperRecipe-Swift.h"
#endif

#import <react/renderer/components/RnWrapViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/RnWrapViewSpec/EventEmitters.h>
#import <react/renderer/components/RnWrapViewSpec/Props.h>
#import <react/renderer/components/RnWrapViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"

#include <optional>

using namespace facebook::react;

@interface SmartSelfieAuthenticationView () <RCTSmartSelfieAuthenticationViewViewProtocol>
@end

@implementation SmartSelfieAuthenticationView {
  SmartSelfieAuthenticationViewProvider *_provider;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<SmartSelfieAuthenticationViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const SmartSelfieAuthenticationViewProps>();
    _props = defaultProps;

  _provider = [[SmartSelfieAuthenticationViewProvider alloc] init];
    self.contentView = _provider;

    __weak SmartSelfieAuthenticationView *weakSelf = self;
    _provider.onSuccess = ^(NSString *json) {
      SmartSelfieAuthenticationView *strongSelf = weakSelf; if (!strongSelf) return;
      auto emitter = std::static_pointer_cast<const SmartSelfieAuthenticationViewEventEmitter>(strongSelf->_eventEmitter);
      if (!emitter) return;
      SmartSelfieAuthenticationViewEventEmitter::OnSuccess ev{};
      ev.result = std::string([json UTF8String]);
      emitter->onSuccess(std::move(ev));
    };

    _provider.onError = ^(NSString *errorString) {
      SmartSelfieAuthenticationView *strongSelf = weakSelf; if (!strongSelf) return;
      auto emitter = std::static_pointer_cast<const SmartSelfieAuthenticationViewEventEmitter>(strongSelf->_eventEmitter);
      if (!emitter) return;
      SmartSelfieAuthenticationViewEventEmitter::OnError ev{};
      ev.error = std::string([errorString UTF8String]);
      emitter->onError(std::move(ev));
    };
  }
  return self;
}

@end
#endif
