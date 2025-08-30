#if RCT_NEW_ARCH_ENABLED
#import "DocumentVerificationView.h"


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

@interface DocumentVerificationView () <RCTDocumentVerificationViewViewProtocol>

@end

// Declare Swift-exposed callback properties to the compiler
@interface DocumentVerificationViewProvider (Callbacks)
@property (nonatomic, copy, nullable) void (^onSuccess)(NSDictionary *payload);
@property (nonatomic, copy, nullable) void (^onError)(NSString *message, NSString * _Nullable code);
@end

@implementation DocumentVerificationView {
DocumentVerificationViewProvider* _view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
return concreteComponentDescriptorProvider<DocumentVerificationViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
if (self = [super initWithFrame:frame]) {
static const auto defaultProps = std::make_shared<const DocumentVerificationViewProps>();
_props = defaultProps;

_view = [[DocumentVerificationViewProvider alloc] init];

self.contentView = _view;

	__weak DocumentVerificationView *weakSelf = self;
	_view.onSuccess = ^(NSDictionary *payload) {
		DocumentVerificationView *strongSelf = weakSelf;
		if (strongSelf == nil) { return; }
		auto eventEmitter = std::static_pointer_cast<const DocumentVerificationViewEventEmitter>(strongSelf->_eventEmitter);
		if (!eventEmitter) { return; }
		// Map NSDictionary to typed event
		std::string selfie = "";
		std::string front = "";
		std::optional<std::string> back;
		bool submitted = false;
		id v;
		if ((v = payload[@"selfie"])) { selfie = [((NSString *)v) UTF8String]; }
		if ((v = payload[@"documentFrontFile"])) { front = [((NSString *)v) UTF8String]; }
		if ((v = payload[@"documentBackFile"])) { back = std::optional<std::string>([((NSString *)v) UTF8String]); }
		if ((v = payload[@"didSubmitDocumentVerificationJob"])) { submitted = [((NSNumber *)v) boolValue]; }

			// Build event without designated initializers
			DocumentVerificationViewEventEmitter::OnSuccess event{};
			event.selfie = selfie;
			event.documentFrontFile = front;
			if (back.has_value()) {
				event.documentBackFile = back.value();
			}
			event.didSubmitDocumentVerificationJob = submitted;
			eventEmitter->onSuccess(std::move(event));
	};

	_view.onError = ^(NSString *message, NSString *code) {
		DocumentVerificationView *strongSelf = weakSelf;
		if (strongSelf == nil) { return; }
		auto eventEmitter = std::static_pointer_cast<const DocumentVerificationViewEventEmitter>(strongSelf->_eventEmitter);
		if (!eventEmitter) { return; }
			std::optional<std::string> codeOpt;
			if (code != nil) { codeOpt = std::optional<std::string>([code UTF8String]); }
			DocumentVerificationViewEventEmitter::OnError event{};
			event.message = std::string([message UTF8String]);
			if (codeOpt.has_value()) {
				event.code = codeOpt.value();
			}
		eventEmitter->onError(std::move(event));
	};
}

return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
const auto &oldViewProps = *std::static_pointer_cast<DocumentVerificationViewProps const>(_props);
const auto &newViewProps = *std::static_pointer_cast<DocumentVerificationViewProps const>(props);

[super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> DocumentVerificationViewCls(void)
{
return DocumentVerificationView.class;
}

@end
#endif
