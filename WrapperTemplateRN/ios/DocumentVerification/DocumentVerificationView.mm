//
//  DocumentVerificationView.mm
//  WrapperTemplateRN
//
//  Created by Harun Wangereka on 08/08/2025.
//

#import "DocumentVerificationView.h"

#import <react/renderer/components/RNFabricDeclarativeViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNFabricDeclarativeViewSpec/EventEmitters.h>
#import <react/renderer/components/RNFabricDeclarativeViewSpec/Props.h>
#import <react/renderer/components/RNFabricDeclarativeViewSpec/RCTComponentViewHelpers.h>

using namespace facebook::react;

@interface DocumentVerificationView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UIImageView *iconImageView;
@end

@implementation DocumentVerificationView

- (instancetype)init
{
if (self = [super init]) {
    [self setupNativeView];
}
return self;
}

- (void)setupNativeView
{
    // Set background color
    self.backgroundColor = [UIColor systemBackgroundColor];
    
    // Create icon image view
    self.iconImageView = [[UIImageView alloc] init];
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:80 weight:UIImageSymbolWeightRegular scale:UIImageSymbolScaleLarge];
    UIImage *docImage = [UIImage systemImageNamed:@"doc.text.viewfinder" withConfiguration:config];
    self.iconImageView.image = docImage;
    self.iconImageView.tintColor = [UIColor systemBlueColor];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Create title label
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"Document Verification";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    self.titleLabel.textColor = [UIColor labelColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Create subtitle label
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.text = @"Native iOS UIKit View";
    self.subtitleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    self.subtitleLabel.textColor = [UIColor secondaryLabelColor];
    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Create description label
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.text = @"This is a native UIKit component rendered inside React Native using Fabric.";
    self.descriptionLabel.font = [UIFont systemFontOfSize:16];
    self.descriptionLabel.textColor = [UIColor secondaryLabelColor];
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Create action button
    self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.actionButton setTitle:@"📷 Start Verification is this working" forState:UIControlStateNormal];
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.actionButton.backgroundColor = [UIColor systemBlueColor];
    self.actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.actionButton.layer.cornerRadius = 10;
    self.actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.actionButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // Add subviews
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
    [self addSubview:self.descriptionLabel];
    [self addSubview:self.actionButton];
    
    // Set up constraints
    [NSLayoutConstraint activateConstraints:@[
        // Icon constraints
        [self.iconImageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.iconImageView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:60],
        [self.iconImageView.widthAnchor constraintEqualToConstant:80],
        [self.iconImageView.heightAnchor constraintEqualToConstant:80],
        
        // Title constraints
        [self.titleLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.iconImageView.bottomAnchor constant:20],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20],
        
        // Subtitle constraints
        [self.subtitleLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.subtitleLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:10],
        [self.subtitleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20],
        [self.subtitleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20],
        
        // Description constraints
        [self.descriptionLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.descriptionLabel.topAnchor constraintEqualToAnchor:self.subtitleLabel.bottomAnchor constant:20],
        [self.descriptionLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20],
        [self.descriptionLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20],
        
        // Button constraints
        [self.actionButton.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.actionButton.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor constant:-60],
        [self.actionButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20],
        [self.actionButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20],
        [self.actionButton.heightAnchor constraintEqualToConstant:50]
    ]];
}

- (void)buttonTapped:(UIButton *)sender
{
    NSLog(@"Document verification button tapped!");
    // You can add more functionality here
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
