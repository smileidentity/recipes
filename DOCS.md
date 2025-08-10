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

**CRITICAL DISTRIBUTION CONCERN**: The register components script IS necessary for production apps because:

1. **CodeGen runs during CI/CD builds**: When building for distribution, CodeGen regenerates files and overwrites manual edits
2. **Generated files are ephemeral**: RCTThirdPartyComponentsProvider.mm is recreated every build, losing manual registrations
3. **Different build environments**: CI servers, release builds, and team members all trigger CodeGen independently

**Why Manual Registration Fails in Production:**
- ❌ Manual edits to generated files are lost on every build
- ❌ CI/CD pipelines run clean builds that regenerate all CodeGen files
- ❌ `npx react-native codegen` overwrites your manual component registrations
- ❌ Release builds always start with fresh generated files

**The Script Solves Real Problems:**
1. **Persistent Registration**: Automatically re-adds components after any CodeGen run
2. **CI/CD Compatibility**: Works in automated build environments
3. **Team Consistency**: Ensures all developers have properly registered components
4. **Distribution Safety**: Guarantees production builds include component registration

**Alternative Solutions:**
1. **Create a Library**: Extract components into a separate npm package (recommended for reusable components)
2. **Build Script Integration**: Add the registration script to your build process
3. **Custom CodeGen Templates**: Modify React Native's CodeGen templates (advanced/unsupported)

**For Production Apps**: The registration script is NOT a workaround—it's a necessary part of the build process for React Native apps using custom Fabric components.

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
  - This is why the script is ESSENTIAL - to automatically re-add the
  registration after each CodeGen run
  - In libraries, this happens automatically - but in apps, manual
  registration is required
  - PRODUCTION BUILDS: Always include the registration script in your build process

  If the File Doesn't Exist

  If you can't find the file, it means CodeGen hasn't run properly. Run:
  npx react-native codegen

  Then search again. The file should be created in one of the locations
  mentioned above.

## Best Practices for Production

### Build Process Integration
Add the registration script to your build pipeline:

```json
// package.json
{
  "scripts": {
    "postcodegen": "./scripts/register-components.sh",
    "ios": "npx react-native codegen && ./scripts/register-components.sh && npx react-native run-ios"
  }
}
```

### CI/CD Integration
For continuous integration, ensure the script runs after CodeGen:

```yaml
# .github/workflows/ios.yml
- name: Generate CodeGen files
  run: npx react-native codegen
  
- name: Register custom components
  run: ./scripts/register-components.sh
  
- name: Build iOS app
  run: xcodebuild -workspace ios/YourApp.xcworkspace ...
```

### Team Development
- Commit the registration script to version control
- Document the build process for team members
- Include script execution in setup documentation

The registration script is a **required build step** for React Native apps with custom Fabric components, not an optional workaround.

# SwiftUI Integration Implementation

## Overview

After implementing both UIKit and SwiftUI approaches for Fabric components, here's a comprehensive analysis and recommendations for your project architecture.

## SwiftUI vs UIKit Implementation

### What We Implemented

1. **SwiftUI Declarative Approach**:
   - `DocumentVerificationSwiftUIView.swift` - Declarative UI with modern Swift syntax
   - `DocumentVerificationViewModel.swift` - Reactive state management with @Published properties
   - `DocumentVerificationSwiftUIWrapper.swift` - Bridge between SwiftUI and Objective-C++
   - Updated `DocumentVerificationView.mm` to use UIHostingController

2. **Key Benefits of SwiftUI Approach**:
   - **Declarative UI**: Cleaner, more maintainable code structure
   - **Reactive Updates**: @Published properties automatically trigger UI updates
   - **Type Safety**: Swift's type system provides compile-time safety
   - **Modern Patterns**: Follows current iOS development best practices
   - **Better Preview Support**: SwiftUI previews enable faster development iteration

### Challenges Encountered

1. **Swift-Objective-C++ Interop**: Required wrapper classes to bridge SwiftUI with Fabric's Objective-C++ components
2. **Build Configuration**: Swift files need proper bridging headers and project configuration
3. **Complexity**: Added multiple layers between React Native and native UI

## Architecture Recommendations

### Option 1: Continue with Current Project Structure (Recommended for Learning)

**Pros**:
- Full control over implementation
- Deep understanding of Fabric architecture
- Custom build processes
- Direct integration with your specific needs

**Cons**:
- Complex build setup with registration scripts
- Manual component management
- Potential build issues with CodeGen regeneration
- Maintenance overhead for each new component

**When to Choose**: 
- Learning React Native Fabric internals
- Building highly customized components
- Small number of native components (< 5)
- Full control over build process is required

### Option 2: Create a Native Component Library (Strongly Recommended for Production)

**Pros**:
- Automated CodeGen registration
- Cleaner separation of concerns
- Reusable across projects
- Standard npm distribution
- Better testing isolation
- CI/CD friendly
- No manual registration scripts needed

**Cons**:
- Initial setup overhead
- Requires npm publishing workflow
- Separate versioning concerns

**Implementation Structure**:
```
smile-id-react-native-components/
├── package.json
├── ios/
│   └── SmileIdComponents/
│       ├── DocumentVerificationView.h
│       ├── DocumentVerificationView.mm
│       ├── DocumentVerificationSwiftUIView.swift
│       └── DocumentVerificationViewModel.swift
├── android/
│   └── src/main/java/com/smileid/
├── specs/
│   └── DocumentVerificationNativeComponent.ts
└── src/
    └── index.ts
```

**Library Benefits for Your Use Case**:
- **SmileID SDK Wrapper**: Perfect for bundling all SmileID native implementations
- **Version Management**: Easy to update SDK versions across projects
- **Documentation**: Clear API documentation for component usage
- **Testing**: Isolated testing environment for components
- **Distribution**: Easy to share across multiple React Native apps

### Option 3: Hybrid Approach (Best of Both Worlds)

Create a mono-repo structure:
```
smile-id-workspace/
├── packages/
│   ├── smile-id-components/     # Library for reusable components
│   └── example-app/             # Your current app for testing
└── tools/
    └── build-scripts/
```

## Final Recommendations

### For Production Use: Go with Option 2 (Library Approach)

**Why This is Ideal for SmileID Integration**:

1. **SDK Bundling**: Create `@smile-id/react-native-fabric` that bundles all native implementations
2. **Clean API**: Expose simple React components that hide native complexity
3. **Version Control**: Manage SmileID SDK versions at library level
4. **Multiple Apps**: Reuse across different React Native projects
5. **Maintenance**: Centralized updates and bug fixes

**Recommended Library Structure**:
```typescript
// User-facing API
import { DocumentVerificationView, BiometricKYCView } from '@smile-id/react-native-fabric';

// In your React Native app
<DocumentVerificationView
  onComplete={(result) => console.log(result)}
  onError={(error) => console.log(error)}
/>
```

### Migration Strategy

1. **Phase 1**: Extract current implementation into a library
2. **Phase 2**: Add SwiftUI components to library for better UX
3. **Phase 3**: Consume library in your main app
4. **Phase 4**: Add additional SmileID components to library

### SwiftUI Integration Decision

**Recommend**: Keep SwiftUI implementation in the library for these components:
- **Document Verification**: Better camera preview handling
- **Biometric Capture**: Superior animation and gesture support  
- **Results Display**: Modern, polished UI presentation

**Use UIKit for**: 
- Simple form components
- Basic list views
- Components requiring precise layout control

## Implementation Next Steps

1. **Create Library Package**:
   ```bash
   npx create-react-native-library @smile-id/react-native-fabric
   ```

2. **Move Components**: Transfer your current implementation to library structure

3. **Add SwiftUI Support**: Include SwiftUI views in library with proper bridging

4. **Testing**: Create comprehensive example app in library

5. **Distribution**: Publish to npm for easy consumption

## Build Process Simplification

With a library approach, your main app's build process becomes:
```json
{
  "dependencies": {
    "@smile-id/react-native-fabric": "^1.0.0"
  }
}
```

No more:
- ❌ Manual component registration scripts
- ❌ CodeGen configuration management  
- ❌ Complex build dependencies
- ❌ Swift bridging header management

The library handles all complexity internally, providing a clean, simple integration experience for your React Native apps.

## Conclusion

While the current project structure works for learning and experimentation, **creating a dedicated library is the recommended approach for production SmileID integration**. It provides better maintainability, easier distribution, cleaner APIs, and eliminates the build complexity issues you've encountered.

The SwiftUI implementation adds significant value for user-facing components, providing modern iOS UI patterns and better user experience. Combined with a library architecture, this creates a robust, maintainable solution for SmileID React Native integration.

Why Library?
- Less Errors especially on iOS cause of codegen
- Separates concerns
- Bootstraps everything for you even codegen configs


Getting Started

```
npx create-react-native-library@latest WrapperLibraryTemplateRN --reactNativeVersion 0.78.0
```

Using a specific react n


## Troubleshooting

- [Hermes crash: property not configurable / component undefined (iOS)](#ts-hermes)
- [Module Resolution Error: main could not be resolved](#ts-module-resolve)

<a id="ts-hermes"></a>
### Hermes crash: `TypeError: property is not configurable` and `Cannot read property 'DocumentVerificationView' of undefined`

Symptoms:
- App logs show `TypeError: property is not configurable, js engine: hermes`.
- Followed by `Warning: TypeError: Cannot read property 'DocumentVerificationView' of undefined` when rendering the component in the example app.

Root cause:
- Re-exporting the same symbols multiple times from the package entry can cause Hermes to attempt redefining already-frozen properties. Using both default exports and `export *` from the same module can trigger this and leave the module object unusable at runtime.
- A secondary risk is a Swift/ObjC symbol name collision if a SwiftUI struct shares the exact name as the ObjC class used by Fabric.

Fix:
1) Simplify JS exports to avoid star re-exports
   - In `rn-wrapper-recipe/src/index.tsx`, export only named defaults:
     - Before:
       - `export { default as RnWrapperRecipeView } from './RnWrapperRecipeViewNativeComponent';`
       - `export * from './RnWrapperRecipeViewNativeComponent';`
       - `export { default as DocumentVerificationView } from './DocumentVerificationViewNativeComponent';`
       - `export * from './DocumentVerificationViewNativeComponent';`
     - After:
       - `export { default as RnWrapperRecipeView } from './RnWrapperRecipeViewNativeComponent';`
       - `export { default as DocumentVerificationView } from './DocumentVerificationViewNativeComponent';`

   - Ensure the built output mirrors this. In `rn-wrapper-recipe/lib/module/index.js` remove star re-exports as well and keep only the two named default exports.

2) Avoid Swift/ObjC name collision (optional but recommended)
   - If you have a SwiftUI type named `DocumentVerificationView`, rename it to something like `DocumentVerificationRootView` and update the provider to reference the new name:
     - `DocumentVerificationViewProvider.swift` should initialize `UIHostingController(rootView: DocumentVerificationRootView())`.
   - Keep the ObjC class `DocumentVerificationView : RCTViewComponentView` unchanged to match the codegen component name.

3) Clean rebuild to refresh caches and generated files
   - From the repo root:
     - `yarn install`
     - `yarn prepare` (runs bob build to produce `lib/`)
   - Restart Metro with a clean cache from the example app:
     - `cd rn-wrapper-recipe/example && yarn start --reset-cache`
   - Reinstall iOS pods to rerun codegen and integrate generated providers:
     - `cd rn-wrapper-recipe/example/ios && rm -rf Pods Podfile.lock build && pod install`
   - Build and run iOS:
     - `cd .. && yarn ios`

Verification:
- The example app should render `<DocumentVerificationView />` without module errors.
- Generated file `build/generated/ios/RCTThirdPartyComponentsProvider.mm` should include:
  - `@"DocumentVerificationView": NSClassFromString(@"DocumentVerificationView")`


<a id="ts-module-resolve"></a>
### Module Resolution Error: "Could not be resolved"

If you encounter an error similar to:

```
Error: While trying to resolve module `react-native-rn-wrapper-recipe` from file `/path/to/example/src/App.tsx`, 
the package `/path/to/package.json` was successfully found. However, this package itself specifies a 
`main` module field that could not be resolved (`/path/to/lib/module/index.js`). 
Indeed, none of these files exist.
```

This error occurs because the library hasn't been built yet. The `package.json` specifies `"main": "./lib/module/index.js"`, but the `lib` directory doesn't exist until the build process runs.

**Solution:**

Run the prepare script to build the library:

```bash
yarn prepare
```

This command runs `bob build` (react-native-builder-bob) which:
- Compiles TypeScript files to JavaScript
- Generates type definitions
- Creates the `lib/module/index.js` file that the module resolver expects

**Why this happens:**

- The `prepare` script doesn't run automatically during `yarn install` in this Yarn 3 workspace setup
- Both the main library and example app need the built files to resolve imports correctly
- This is common in library development where source files need compilation before consumption

**Prevention:**

After cloning the repository or installing dependencies, always run:
```bash
yarn install
yarn prepare
```

## Exposing native callbacks to JS (iOS, Fabric)

Forward SmileID native results (success/error) from Swift/SwiftUI to React Native using Fabric events.

Summary
- Add typed DirectEventHandler props in the TS spec.
- In SwiftUI, call closures when SmileID delegate fires.
- In the UIView provider, keep @objc callback properties and pass them into the SwiftUI root.
- In the ObjC++ component view, set those callbacks and emit Fabric events to JS.
- In JS, handle onSuccess/onError from e.nativeEvent.

1) TypeScript spec: define events
```ts
// src/DocumentVerificationViewNativeComponent.ts
import type { DirectEventHandler } from 'react-native/Libraries/Types/CodegenTypes';
import type { ViewProps } from 'react-native';

export type DocumentVerificationSuccessEvent = Readonly<{
  selfie: string;
  documentFrontFile: string;
  documentBackFile?: string;
  didSubmitDocumentVerificationJob: boolean;
}>;

export type DocumentVerificationErrorEvent = Readonly<{
  message: string;
  code?: string;
}>;

interface NativeProps extends ViewProps {
  onSuccess?: DirectEventHandler<DocumentVerificationSuccessEvent>;
  onError?: DirectEventHandler<DocumentVerificationErrorEvent>;
}
```

2) SwiftUI: bridge SmileID delegate
```swift
// ios/DocumentVerificationView.swift
struct DocumentVerificationRootView: View, DocumentVerificationResultDelegate {
  let onSuccess: (NSDictionary) -> Void
  let onError: (String, String?) -> Void

  func didSucceed(selfie: URL, documentFrontImage: URL, documentBackImage: URL?, didSubmitDocumentVerificationJob: Bool) {
    let payload: NSMutableDictionary = [
      "selfie": selfie.absoluteString,
      "documentFrontFile": documentFrontImage.absoluteString,
      "didSubmitDocumentVerificationJob": didSubmitDocumentVerificationJob,
    ]
    if let documentBackImage { payload["documentBackFile"] = documentBackImage.absoluteString }
    onSuccess(payload)
  }

  func didError(error: Error) { onError(error.localizedDescription, nil) }
}
```

3) Provider: expose callbacks to ObjC
```swift
// ios/DocumentVerificationViewProvider.swift
@objc public var onSuccess: ((NSDictionary) -> Void)?
@objc public var onError: ((NSString, NSString?) -> Void)?

self.hostingController = UIHostingController(
  rootView: DocumentVerificationRootView(
    onSuccess: { [weak self] payload in self?.onSuccess?(payload) },
    onError: { [weak self] message, code in self?.onError?(message as NSString, code as NSString?) }
  )
)
```

4) ObjC++ component: emit Fabric events
```objc
// ios/DocumentVerificationView.mm
__weak DocumentVerificationView *weakSelf = self;
_view.onSuccess = ^(NSDictionary *payload) {
  DocumentVerificationView *strongSelf = weakSelf; if (!strongSelf) return;
  auto emitter = std::static_pointer_cast<const DocumentVerificationViewEventEmitter>(strongSelf->_eventEmitter);
  if (!emitter) return;
  // map payload -> event fields, then emit
  DocumentVerificationViewEventEmitter::OnSuccess ev{};
  // ... assign fields from payload ...
  emitter->onSuccess(std::move(ev));
};
_view.onError = ^(NSString *message, NSString *code) {
  DocumentVerificationView *strongSelf = weakSelf; if (!strongSelf) return;
  auto emitter = std::static_pointer_cast<const DocumentVerificationViewEventEmitter>(strongSelf->_eventEmitter);
  if (!emitter) return;
  DocumentVerificationViewEventEmitter::OnError ev{};
  // ... assign fields from message/code ...
  emitter->onError(std::move(ev));
};
```

5) JS usage
```tsx
<DocumentVerificationView
  style={{ flex: 1 }}
  onSuccess={(e) => {
    const { selfie, documentFrontFile, documentBackFile, didSubmitDocumentVerificationJob } = e.nativeEvent;
  }}
  onError={(e) => {
    const { message, code } = e.nativeEvent;
  }}
/>
```

Rebuild
- Generate outputs and codegen: `yarn prepare`
- Restart Metro: `yarn start --reset-cache`
- Reinstall pods (example/ios): `rm -rf Pods Podfile.lock build && pod install`
- Run iOS: `yarn ios`

Tips
- Event prop names in TS must match what you emit on iOS.
- If OnSuccess/OnError types are missing, re-run codegen and pods.
- Use weak->strong in blocks before accessing `_eventEmitter`.