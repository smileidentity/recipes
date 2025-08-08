# Creating Your own React Native Wrapper for SmileID SDKs

This doc provides a guide on how to create your own React Native wrapper for the SmileID SDKs. This is useful if you want to integrate the SmileID functionality into your React Native application.

If you're using Expo, we already have the [react-native-expo](https://github.com/smileidentity/react-native-expo) sdk that you should use or if you're using react native version 0.74.2 and below you can use the [react-native sdk](https://github.com/smileidentity/react-native).

This guide is for developers who are on new architecture and want to create a custom wrapper for the SmileID SDKs.


# Overview

In the old architecture of React Native, you would have used [Native Modules](https://reactnative.dev/docs/legacy/native-modules-intro) & Native Components to access native functionality. However, in the new architecture, you will use the [Turbo Modules](https://reactnative.dev/docs/turbo-modules) and [Fabric Native Components](https://reactnative.dev/docs/fabric) to create your own wrapper. Turbo Modules are optimized  for native module management and Fabric allows for a faster and flexible rendering of native components.


# Android
// Add smileid sdk to your project - 
    // explain about kotlin versions and forcing it to use the react native kotlin version
    // compose setup
// Create a view
// Create a View Manager
// Add viewmanager to the package
// create a js view for your view for code gen
// configure code gen


# iOS

Summary of Issues & Solutions

Here's a comprehensive guide of all the issues we encountered and how to
fix them when implementing Fabric native components in a React Native app
(not a library):

Issues Encountered & Solutions

1. Filename Typo

Issue: TypeScript spec file was named
DcoumentVerificationNativeComponent.ts (missing "u")
Solution:
- Rename to DocumentVerificationNativeComponent.ts
- Update import path in App.tsx

2. Wrong Component Descriptor Reference

Issue: DocumentVerificationView.mm was using
CustomWebViewComponentDescriptor instead of the correct one
Solution:
+ (ComponentDescriptorProvider)componentDescriptorProvider
  {
  return concreteComponentDescriptorProvider<DocumentVerificationViewCompon
  entDescriptor>();
  }

3. Incorrect CodeGen Import Paths

Issue: DocumentVerificationView.mm had wrong import paths (AppSpec
instead of RNFabricDeclarativeViewSpec)
Solution:
#import <react/renderer/components/RNFabricDeclarativeViewSpec/ComponentD
escriptors.h>
#import
<react/renderer/components/RNFabricDeclarativeViewSpec/EventEmitters.h>
#import <react/renderer/components/RNFabricDeclarativeViewSpec/Props.h>
#import <react/renderer/components/RNFabricDeclarativeViewSpec/RCTCompone
ntViewHelpers.h>

4. Xcode Project File References

Issue: project.pbxproj referenced .m file instead of .mm file
Solution: Update all references:
- DocumentVerificationView.m → DocumentVerificationView.mm
- sourcecode.c.objc → sourcecode.cpp.objcpp

5. Missing Component Registration

Issue: The most critical issue - RCTThirdPartyComponentsProvider.mm was
empty and not registering our component
Root Cause: CodeGen in React Native apps doesn't automatically register
components like it does in libraries
Solution: Manual registration in generated provider files:
#import "DocumentVerificationView.h"

+ (NSDictionary<NSString *, Class<RCTComponentViewProtocol>>
  *)thirdPartyFabricComponents
  {
  return @{
  @"DocumentVerificationView": DocumentVerificationView.class
  };
  }

6. Missing Actual UI Implementation

Issue: Component had no actual UI content, causing "unimplemented
component" error
Solution: Implement comprehensive UIKit interface in setupNativeView:
- SF Symbol icon
- Title and subtitle labels
- Description text
- Interactive button with Auto Layout constraints

Required File Structure

ios/
├── DocumentVerification/
│   ├── DocumentVerificationView.h
│   └── DocumentVerificationView.mm
specs/
└── DocumentVerificationNativeComponent.ts
package.json (with codegenConfig)

Key Files & Content

1. package.json - CodeGen Configuration

{
"codegenConfig": {
"name": "RNFabricDeclarativeViewSpec",
"type": "components",
"jsSrcsDir": "specs"
}
}

2. TypeScript Spec (specs/DocumentVerificationNativeComponent.ts)

import codegenNativeComponent from
'react-native/Libraries/Utilities/codegenNativeComponent';
import type { ViewProps } from 'react-native';

interface NativeProps extends ViewProps {
}

export default
codegenNativeComponent<NativeProps>('DocumentVerificationView');

3. iOS Header (ios/DocumentVerification/DocumentVerificationView.h)

#import <React/RCTViewComponentView.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DocumentVerificationView : RCTViewComponentView

@end

NS_ASSUME_NONNULL_END

Critical Steps

1. Run CodeGen: npx react-native codegen
2. Add to Xcode Project: Include both .h and .mm files
3. Manual Registration: Since CodeGen doesn't auto-register in apps,
   manually add component to RCTThirdPartyComponentsProvider.mm
4. Fix Import Paths: Ensure header files can be found by generated code

The Register Components Script Issue

Answer to your question: The register components script should not be
necessary in a properly configured setup. It was a workaround because:

1. CodeGen in React Native apps doesn't automatically register components
   (unlike libraries)
2. The generated RCTThirdPartyComponentsProvider.mm file stays empty
3. Manual registration is required for apps vs libraries

Proper Solution: The React Native team expects app developers to either:
- Create a library for reusable components, or
- Manually register components in the generated provider files

The script automates what should ideally be a one-time manual setup step.

Key Takeaway

The main difference between React Native libraries and React Native apps
for Fabric components:
- Libraries: CodeGen automatically generates registration
- Apps: Manual component registration required in provider files

This explains why most Fabric documentation focuses on libraries - the
app use case requires additional manual steps that aren't well
documented.

The RCTThirdPartyComponentsProvider.mm file is a generated file created
  by React Native's CodeGen process. Here are the locations where you'll
  find it:

  File Locations

  Primary Location (most commonly used):

  /build/generated/ios/RCTThirdPartyComponentsProvider.mm

  Alternative Location (depending on build configuration):

  /ios/build/generated/ios/RCTThirdPartyComponentsProvider.mm

  How to Find It

  1. After running CodeGen:
  npx react-native codegen
  2. Search for the file:
  find . -name "RCTThirdPartyComponentsProvider.mm" -type f
  3. Common paths in your project:
    - ./build/generated/ios/RCTThirdPartyComponentsProvider.mm
    - ./ios/build/generated/ios/RCTThirdPartyComponentsProvider.mm

  What the File Initially Contains

  When first generated, it looks like this:
  #import <Foundation/Foundation.h>
  #import "RCTThirdPartyComponentsProvider.h"
  #import <React/RCTComponentViewProtocol.h>

  @implementation RCTThirdPartyComponentsProvider

  + (NSDictionary<NSString *, Class<RCTComponentViewProtocol>>
  *)thirdPartyFabricComponents
  {
    return @{
      // Empty - this is where your components need to be registered
    };
  }

  @end

  What You Need to Modify

  Add your component registration:
  #import "DocumentVerificationView.h"  // Add this import

  + (NSDictionary<NSString *, Class<RCTComponentViewProtocol>>
  *)thirdPartyFabricComponents
  {
    return @{
      @"DocumentVerificationView": DocumentVerificationView.class  // Add
  this line
    };
  }

  Important Notes

  - This is a generated file - it gets recreated every time you run npx
  react-native codegen
  - Manual edits will be lost when CodeGen runs again
  - This is why the script was necessary - to automatically re-add the
  registration after each CodeGen run
  - In libraries, this happens automatically - but in apps, manual
  registration is required

  If the File Doesn't Exist

  If you can't find the file, it means CodeGen hasn't run properly. Run:
  npx react-native codegen

  Then search again. The file should be created in one of the locations
  mentioned above.
