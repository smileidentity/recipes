#if RCT_NEW_ARCH_ENABLED
#import "DocumentVerificationView.h"


#if __has_include("RnWrapperRecipe/RnWrapperRecipe-Swift.h")
#import "RnWrapperRecipe/RnWrapperRecipe-Swift.h"
#else
#import "RnWrapperRecipe-Swift.h"
#endif

#import <react/renderer/components/RnWrapperRecipeViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/RnWrapperRecipeViewSpec/EventEmitters.h>
#import <react/renderer/components/RnWrapperRecipeViewSpec/Props.h>
#import <react/renderer/components/RnWrapperRecipeViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"


using namespace facebook::react;

@interface DocumentVerificationView () <RCTDocumentVerificationViewViewProtocol>

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
