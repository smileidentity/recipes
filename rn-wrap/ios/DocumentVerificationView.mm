#if RCT_NEW_ARCH_ENABLED
#import "DocumentVerificationView.h"


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
#include <math.h>


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
- (void)updateProps:(Props::Shared const &)props
					oldProps:(Props::Shared const &)oldProps
{
	const auto &oldViewProps = *std::static_pointer_cast<DocumentVerificationViewProps const>(_props);
	const auto &newViewProps = *std::static_pointer_cast<DocumentVerificationViewProps const>(props);

	[super updateProps:props oldProps:oldProps];

		__block BOOL needsUpdate = NO;

		// Non-optional generated strings: empty string means 'unset'
		auto assignStringIfChanged = ^(const std::string &src, NSString **storage){
			if (storage == nil) { return; }
			if (src.empty()) {
				if (*storage != nil) { *storage = nil; needsUpdate = YES; }
			} else {
				NSString *val = [NSString stringWithUTF8String:src.c_str()];
				if (*storage == nil || ![(*storage) isEqualToString:val]) { *storage = val; needsUpdate = YES; }
			}
		};

		// countryCode required (never empty ideally)
		NSString *country = [NSString stringWithUTF8String:newViewProps.countryCode.c_str()];
		if (![_view.countryCode isEqualToString:country]) { _view.countryCode = country; needsUpdate = YES; }

		// Copy current values to locals so we don't take the address of Objective-C properties (disallowed)
		NSString *curUserId = _view.userId;
		NSString *curJobId = _view.jobId;
		NSString *curDocumentType = _view.documentType;
		NSString *curBypassFile = _view.bypassSelfieCaptureWithFile;
		assignStringIfChanged(newViewProps.userId, &curUserId);
		assignStringIfChanged(newViewProps.jobId, &curJobId);
		assignStringIfChanged(newViewProps.documentType, &curDocumentType);
		assignStringIfChanged(newViewProps.bypassSelfieCaptureWithFile, &curBypassFile);
		if (_view.userId != curUserId) { _view.userId = curUserId; }
		if (_view.jobId != curJobId) { _view.jobId = curJobId; }
		if (_view.documentType != curDocumentType) { _view.documentType = curDocumentType; }
		if (_view.bypassSelfieCaptureWithFile != curBypassFile) { _view.bypassSelfieCaptureWithFile = curBypassFile; }

		// Enum autoCapture -> string mapping
		NSString *newMode = nil;
		switch (newViewProps.autoCapture) {
			case DocumentVerificationViewAutoCapture::AutoCapture: newMode = @"AutoCapture"; break;
			case DocumentVerificationViewAutoCapture::AutoCaptureOnly: newMode = @"AutoCaptureOnly"; break;
			case DocumentVerificationViewAutoCapture::ManualCaptureOnly: newMode = @"ManualCaptureOnly"; break;
		}
		if ((newMode != nil && ![_view.autoCapture isEqualToString:newMode]) || (newMode == nil && _view.autoCapture != nil)) {
			_view.autoCapture = newMode;
			needsUpdate = YES;
		}

		// Booleans: use local copies to avoid taking address of properties
		// Booleans: manual diff one by one (simplest, explicit)
		if (_view.captureBothSides.boolValue != newViewProps.captureBothSides) { _view.captureBothSides = @(newViewProps.captureBothSides); needsUpdate = YES; }
		if (_view.allowNewEnroll.boolValue != newViewProps.allowNewEnroll) { _view.allowNewEnroll = @(newViewProps.allowNewEnroll); needsUpdate = YES; }
		if (_view.allowAgentMode.boolValue != newViewProps.allowAgentMode) { _view.allowAgentMode = @(newViewProps.allowAgentMode); needsUpdate = YES; }
		if (_view.allowGalleryUpload.boolValue != newViewProps.allowGalleryUpload) { _view.allowGalleryUpload = @(newViewProps.allowGalleryUpload); needsUpdate = YES; }
		if (_view.showInstructions.boolValue != newViewProps.showInstructions) { _view.showInstructions = @(newViewProps.showInstructions); needsUpdate = YES; }
		if (_view.showAttribution.boolValue != newViewProps.showAttribution) { _view.showAttribution = @(newViewProps.showAttribution); needsUpdate = YES; }
		if (_view.skipApiSubmission.boolValue != newViewProps.skipApiSubmission) { _view.skipApiSubmission = @(newViewProps.skipApiSubmission); needsUpdate = YES; }
		if (_view.useStrictMode.boolValue != newViewProps.useStrictMode) { _view.useStrictMode = @(newViewProps.useStrictMode); needsUpdate = YES; }

		// idAspectRatio: 0.0 used as sentinel for 'unset'
		if (newViewProps.idAspectRatio != 0.0f) {
			double v = (double)newViewProps.idAspectRatio;
			if (_view.idAspectRatio == nil || fabs(_view.idAspectRatio.doubleValue - v) > 0.0001) { _view.idAspectRatio = @(v); needsUpdate = YES; }
		} else if (_view.idAspectRatio != nil) { _view.idAspectRatio = nil; needsUpdate = YES; }

		if (_view.autoCaptureTimeout.intValue != newViewProps.autoCaptureTimeout) {
			_view.autoCaptureTimeout = @(newViewProps.autoCaptureTimeout);
			needsUpdate = YES;
		}

		// extraPartnerParams vector (copy then assign)
		if (!newViewProps.extraPartnerParams.empty()) {
			NSMutableArray *newParams = [NSMutableArray arrayWithCapacity:newViewProps.extraPartnerParams.size()];
			for (const auto &entry : newViewProps.extraPartnerParams) {
				NSDictionary *d = @{ @"key": [NSString stringWithUTF8String:entry.key.c_str()],
									 @"value": [NSString stringWithUTF8String:entry.value.c_str()] };
				[newParams addObject:d];
			}
			if (![_view.extraPartnerParams isEqualToArray:newParams]) { _view.extraPartnerParams = newParams; needsUpdate = YES; }
		} else if (_view.extraPartnerParams != nil) { _view.extraPartnerParams = nil; needsUpdate = YES; }

		if (needsUpdate) { [_view updateParams]; }
}

Class<RCTComponentViewProtocol> DocumentVerificationViewCls(void)
{
return DocumentVerificationView.class;
}

@end
#endif
