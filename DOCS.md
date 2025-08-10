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

### Understanding the iOS pieces (New Architecture) before you implement

This wrapper uses React Native’s New Architecture (Fabric). Here’s what each file does and how they fit together.

#### File roles and responsibilities

- Header (.h)
  - Declares a Fabric component class that inherits from `RCTViewComponentView`.
  - Example: `@interface DocumentVerificationView : RCTViewComponentView @end`.
  - Only interfaces live here—no logic.

- Component implementation (.mm, Objective‑C++)
  - The Fabric view implementation. Uses ObjC++ because it talks to C++ event emitters generated by RN Codegen.
  - Responsibilities:
    - Register a descriptor: `+componentDescriptorProvider` returning `concreteComponentDescriptorProvider<...>()`.
      - Why this is needed: Fabric discovers and renders native views via ComponentDescriptors. If your view’s descriptor isn’t registered, Fabric treats it as “unimplemented,” and the component won’t mount.
      - What a descriptor is: a generated C++ type (e.g., `DocumentVerificationViewComponentDescriptor`) that ties together the component name, its props type, and its event emitter type. It’s produced by RN Codegen from your TS spec and consumed by the registry at runtime.
      - Creating your own:
        1) Define a TS spec with `codegenNativeComponent` (props/events),
        2) Add the name to `package.json` `codegenConfig.ios.componentProvider`,
        3) Run codegen (and Pod install for iOS) to generate C++ headers,
        4) In your `.mm`, implement `+componentDescriptorProvider` returning `concreteComponentDescriptorProvider<YourComponentDescriptor>()` and guard with `#if RCT_NEW_ARCH_ENABLED`.
    - In `initWithFrame:` create and set the Swift provider as `self.contentView`.
    - Subscribe to provider callbacks (`onSuccess`, `onError`) and forward them to JS by emitting typed events via the generated `...EventEmitter`.
    - Use `__weak self` outside blocks and promote to strong inside before using `_eventEmitter`.
  - Wrapped in `#if RCT_NEW_ARCH_ENABLED`.

- View provider (.swift)
  - A lightweight `UIView` that hosts your SwiftUI view in a `UIHostingController`.
  - Exposes `@objc` callback properties so Objective‑C can call them (e.g., `@objc public var onSuccess: ((NSString) -> Void)?`).
  - Creates the hosting controller once, pins it to fill, and calls `reactAddController(toClosestParent:)`.

- SwiftUI root (.swift)
  - The actual native UI (e.g., SmileID screens). Implements the delegate/protocol from the native SDK and converts results into a payload for JS.
  - To keep RN Codegen simple, emit a single JSON string for success and a plain string for errors.
  - Calls the closures exposed by the provider.

- TS spec (.ts)
  - Declares the Fabric component props and event payload types, and calls `codegenNativeComponent`.
  - For event payloads, prefer a single string field (e.g., `{ result: string }`) to avoid codegen edge cases with nested optional objects.

- Library index (.ts/tsx)
  - Exports your component so RN apps can import it: `export { default as MyView } from './MyViewNativeComponent'`.

- package.json (codegenConfig)
  - Adds your component to iOS `componentProvider` so RN Codegen generates descriptors/emitters and registration boilerplate.
  - Example: `"MyView": "MyView"`.

#### Objective‑C / ObjC++ crash course (just enough for Fabric)

- Headers and interfaces
  - `#import` brings in headers. `NS_ASSUME_NONNULL_BEGIN/END` mark nonnull by default.
  - `@interface ClassName : BaseClass @end` declares a class; implementation goes in `.m/.mm` under `@implementation`.

- Types you’ll see
  - `NSString *`, `NSDictionary *`, `NSArray *`, `NSNumber *`, `BOOL`.
  - Generic C++ types from RN codegen: `std::string`, `std::optional`, `std::vector<std::string>` used only in `.mm`.

- Blocks (closures)
  - Declared like: `^ (NSString *msg) { ... }`.
  - Capture `__weak typeof(self) weakSelf = self;` outside, then `auto strongSelf = weakSelf; if (!strongSelf) return;` inside.

- Bridging Swift to ObjC
  - The auto‑generated `RnWrapperRecipe-Swift.h` lets `.mm` call into Swift classes and `@objc` properties.

- New Architecture guards
  - Wrap Fabric code with `#if RCT_NEW_ARCH_ENABLED` to keep legacy builds compiling.

#### End‑to‑end: steps to add a new SwiftUI Fabric view

1) Create the TS spec
  - `src/MyViewNativeComponent.ts`: define props and events and export with `codegenNativeComponent`.
  - Keep events string‑based: `onSuccess?: DirectEventHandler<{ result: string }>`; `onError?: DirectEventHandler<{ error: string }>`.

2) Export from the library entry
  - `src/index.tsx`: `export { default as MyView } from './MyViewNativeComponent'`.

3) Register in codegen
  - `package.json` → `codegenConfig.ios.componentProvider["MyView"] = "MyView"`.

4) Add iOS files
  - `ios/MyView.h`: subclass `RCTViewComponentView` (no logic).
  - `ios/MyViewProvider.swift`: a `UIView` hosting `UIHostingController<MyRootView>` with `@objc` string callbacks.
  - `ios/MyView.swift`: SwiftUI root that calls the native SDK, builds a params dictionary, encodes JSON string on success, passes error messages on failure.
  - `ios/MyView.mm`: Fabric glue—set `self.contentView = provider`, wire provider callbacks to `MyViewEventEmitter` by assigning `ev.result`/`ev.error` and calling `emitter->onSuccess/onError`.

5) Generate and wire
  - yarn prepare
  - In example app: `cd example/ios && rm -rf Pods Podfile.lock build && RCT_NEW_ARCH_ENABLED=1 bundle exec pod install --repo-update`
  - Run iOS: `yarn ios`

6) Use it from JS
  - Import from your library and render: `<MyView onSuccess={(e) => JSON.parse(e.nativeEvent.result)} onError={(e) => console.error(e.nativeEvent.error)} />`.

### Demo: two SmileID views end-to-end (iOS, Fabric)

In this section we demo the above end‑to‑end flow with two real SmileID views. Example 1 shows SmartSelfie Authentication. Example 2 revisits Document Verification and focuses on wiring success/error callbacks with minimal duplication.

#### Example 1: SmartSelfie Authentication — stringified result and error

1) TS spec
```ts
// src/SmartSelfieAuthenticationViewNativeComponent.ts
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { ViewProps } from 'react-native';
import type { DirectEventHandler } from 'react-native/Libraries/Types/CodegenTypes';

export type SmartSelfieAuthSuccessEvent = Readonly<{ result: string }>;
export type SmartSelfieAuthErrorEvent = Readonly<{ error: string }>;

interface NativeProps extends ViewProps {
  onSuccess?: DirectEventHandler<SmartSelfieAuthSuccessEvent>;
  onError?: DirectEventHandler<SmartSelfieAuthErrorEvent>;
}

export default codegenNativeComponent<NativeProps>('SmartSelfieAuthenticationView');
```

2) Export and codegen mapping
- Export from `src/index.tsx`: `export { default as SmartSelfieAuthenticationView } from './SmartSelfieAuthenticationViewNativeComponent';`
- package.json
```json
{
  "codegenConfig": {
    "ios": {
      "componentProvider": {
        "SmartSelfieAuthenticationView": "SmartSelfieAuthenticationView"
      }
    }
  }
}
```

3) SwiftUI + Provider (emit strings)
```swift
// ios/SmartSelfieAuthenticationViewProvider.swift
@objc public class SmartSelfieAuthenticationViewProvider: UIView {
  // Emit single-string payloads to match codegen types
  @objc public var onSuccess: ((NSString) -> Void)?
  @objc public var onError: ((NSString) -> Void)?

  private var hostingController: UIHostingController<SmartSelfieAuthenticationRootView>?

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder: NSCoder) { super.init(coder: coder); setupView() }

  private func setupView() {
    if hostingController != nil { return }
    hostingController = UIHostingController(
      rootView: SmartSelfieAuthenticationRootView(
        onSuccess: { [weak self] json in self?.onSuccess?(json) },
        onError: { [weak self] json in self?.onError?(json) }
      )
    )
    guard let hostingController else { return }
    // Add as child controller and pin edges
    reactAddController(toClosestParent: hostingController)
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    addSubview(hostingController.view)
    NSLayoutConstraint.activate([
      hostingController.view.topAnchor.constraint(equalTo: topAnchor),
      hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor),
      hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
      hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }
}
```

Also add the SwiftUI root view:
```swift
// ios/SmartSelfieAuthenticationView.swift
struct SmartSelfieAuthenticationRootView: View, SmartSelfieResultDelegate {
  let onSuccess: (NSString) -> Void
  let onError: (NSString) -> Void

  var body: some View {
    SmileID.smartSelfieAuthenticationScreen(userId: "userID", delegate: self)
  }

  // Build a JSON result and pass it as a string
  func didSucceed(
    selfieImage: Data,
    livenessImages: [Data],
    jobStatusResponse: SmartSelfieJobStatusResponse
  ) {
    var params: [String: Any] = [
      "selfieFile": selfieImage.base64EncodedString(),
      "livenessFiles": livenessImages.map { $0.base64EncodedString() },
    ]
    let api: [String: Any] = [
      "code": jobStatusResponse.code as Any,
      "created_at": jobStatusResponse.createdAt as Any,
      "job_id": jobStatusResponse.jobId as Any,
      "job_type": jobStatusResponse.jobType as Any,
      "message": jobStatusResponse.message as Any,
      "partner_id": jobStatusResponse.partnerId as Any,
      "partner_params": jobStatusResponse.partnerParams as Any,
      "status": jobStatusResponse.status as Any,
      "updated_at": jobStatusResponse.updatedAt as Any,
      "user_id": jobStatusResponse.userId as Any,
    ]
    params["apiResponse"] = api
    guard let data = try? JSONSerialization.data(withJSONObject: params),
          let json = String(data: data, encoding: .utf8) else {
      onError("SmartSelfie JSON encoding error")
      return
    }
    onSuccess(json as NSString)
  }

  func didError(error: Error) { onError(error.localizedDescription as NSString) }
}
```

4) ObjC++ component view
```objc
// ios/SmartSelfieAuthenticationView.mm
// Wire provider callbacks to Fabric emitter with string payloads
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
```

5) JS usage
```tsx
<SmartSelfieAuthenticationView
  style={{ flex: 1 }}
  onSuccess={(e) => {
    try { const data = JSON.parse(e.nativeEvent.result); /* use data */ }
    catch { console.log(e.nativeEvent.result); }
  }}
  onError={(e) => console.error(e.nativeEvent.error)}
/>
```

6) Build & verify
- `yarn prepare`
- `yarn start --reset-cache`
- `cd example/ios && rm -rf Pods Podfile.lock build && pod install`
- `yarn ios`

Why strings?
- Keeps RN codegen stable by avoiding nested optional object types in event payloads.

#### Example 2: Document Verification — expose native callbacks

Goal: forward SmileID Document Verification results to JS via Fabric events using the same robust string approach, or typed fields if you prefer.

1) TS spec options
- Robust (string payloads):
```ts
export type DocumentVerificationSuccessEvent = Readonly<{ result: string }>;
export type DocumentVerificationErrorEvent = Readonly<{ error: string }>;
interface NativeProps extends ViewProps {
  onSuccess?: DirectEventHandler<DocumentVerificationSuccessEvent>;
  onError?: DirectEventHandler<DocumentVerificationErrorEvent>;
}
```
- Or typed fields (requires careful codegen mapping): selfie, documentFrontFile, optional documentBackFile, and didSubmitDocumentVerificationJob.

2) SwiftUI + Provider
- Provider exposes `onSuccess`/`onError` as `NSString` closures.
- SwiftUI root collects SmileID delegate outputs and either JSON‑encodes a result object or maps explicit fields.

3) ObjC++ component view
- Promote `weakSelf` to strong, get `auto emitter = std::static_pointer_cast<const DocumentVerificationViewEventEmitter>(self->_eventEmitter);`.
- Emit:
  - String payloads: set `ev.result`/`ev.error` from `NSString`.
  - Typed payloads: assign each field from the Swift payload dictionary to `ev` fields before `emitter->onSuccess`.

4) JS usage
```tsx
<DocumentVerificationView
  style={{ flex: 1 }}
  onSuccess={(e) => {
    // If using string payloads
    try { const data = JSON.parse(e.nativeEvent.result); } catch { /* fallback */ }
    // If using typed fields, read directly from e.nativeEvent
  }}
  onError={(e) => console.error(e.nativeEvent.error)}
/>
```

5) Build steps (same as Example 1)
- `yarn prepare` → regenerate code
- Clean pods (example/ios) and `pod install`
- `yarn ios` to run

Notes
- Event prop names in TS must match those emitted from iOS.
- Wrap Fabric code with `#if RCT_NEW_ARCH_ENABLED`.
- Use weak→strong promotion before accessing `_eventEmitter` in blocks.


## SmileID native module: initialize/setCallbackUrl from JS (New Architecture)

This section documents how the wrapper exposes SmileID iOS SDK static methods to JavaScript and the threading fix that avoids a Main Thread Checker crash.

### What this adds
- A tiny native module to call `SmileID.initialize(...)` and `SmileID.setCallbackUrl(...)` from JS.
- Initialization fallbacks: prefer `apiKey + config` → `config only` → `basic` (sandbox flag only).
- Main-thread dispatch around SDK calls to avoid UI APIs being touched off the main queue.

### Files involved
- iOS native module and bridge
  - `rn-wrapper-recipe/ios/SmileIDModule.h` — RCTBridgeModule interface
  - `rn-wrapper-recipe/ios/SmileIDModule.mm` — Objective‑C implementation exported as `RCT_EXPORT_MODULE(SmileID)` with two promise methods:
    - `initialize(useSandbox, enableCrashReporting, config?: NSDictionary, apiKey?: NSString)`
    - `setCallbackUrl(url?: NSString)`
  - `rn-wrapper-recipe/ios/SmileIDBridge.swift` — Swift helper that:
    - Sets wrapper info: `SmileID.setWrapperInfo(name: .reactNative, version: <SMILE_ID_VERSION|unknown>)`
    - Decodes optional `configJson` into `Config` (snake_case JSON)
    - Performs initialization fallbacks and ensures calls run on the main thread
- JS binding
  - `rn-wrapper-recipe/src/NativeSmileID.ts` — Type-safe wrapper over `NativeModules.SmileID` with `initialize` and `setCallbackUrl` exported for app use
- Example usage
  - `rn-wrapper-recipe/example/src/App.tsx` — Calls `initialize(...)` once on startup with a sample config

### API (JS)
- `initialize(useSandbox: boolean, enableCrashReporting: boolean, config?: SmileConfig, apiKey?: string): Promise<void>`
  - `SmileConfig` expects snake_case keys matching the iOS `Config.CodingKeys`
  - Fallbacks inside native:
    1) If both `apiKey` and `config` are provided → `SmileID.initialize(apiKey:config:useSandbox:enableCrashReporting:requestTimeout:)`
    2) Else if only `config` is provided → `SmileID.initialize(config:useSandbox:)`
    3) Else → `SmileID.initialize(useSandbox:)`
- `setCallbackUrl(url?: string): Promise<void>`

### Main-thread fix (crash prevention)
Symptoms observed: Main Thread Checker complained about UI API calls (e.g., `-[UIWindow screen]`) when `initialize(...)` was invoked on a background queue (TurboModule thread).

Fix implemented in `SmileIDBridge.swift`:
- Wrap all calls that may touch UI (or frameworks like Sentry used by SmileID) on the main thread.
  - `initializeSDK(...)`: executes on the main queue (synchronously) before resolving the JS promise to ensure initialization completes safely.
  - `setCallbackUrl(...)`: executes on the main queue (asynchronously), which is fine for a setter.

Why synchronous for initialize? It guarantees the Promise only resolves after the SDK is fully initialized, making downstream usage deterministic and avoiding race conditions.

### Does this use TurboModules?
- Yes, it runs under the New Architecture’s TurboModule manager, but this implementation uses the Objective‑C interop path (no TS codegen spec). You’ll see calls on `com.meta.react.turbomodulemanager.queue` and `ObjCTurboModule` in stack traces.
- It is not a “codegen TurboModule.” To make it fully codegen-based, add a TypeScript spec for the module, configure CodeGen, and re-implement the module conforming to the generated interface. For most simple bridges, the interop approach is sufficient.

### Build steps (iOS)
When you add or change native iOS files, reinstall Pods and rebuild:

```sh
# From the example app (or host app) iOS folder
cd rn-wrapper-recipe/example/ios
rm -rf Pods Podfile.lock build
RCT_NEW_ARCH_ENABLED=1 bundle exec pod install --repo-update
cd ..
"$(npm bin)/react-native" run-ios
```

If you see header/module import errors, a clean pod install (with New Architecture enabled) usually resolves them.

### Notes
- Wrapper version is read from `SMILE_ID_VERSION` if the compile-time flag is defined; otherwise it defaults to "unknown". This does not affect functionality.
- `SmileConfig` must be provided in snake_case; it’s JSON‑encoded on the Objective‑C side and decoded into Swift’s `Config`.
- Invalid or missing `config` simply falls back to the lighter initialization paths described above.

## Android native module: initialize/setCallbackUrl from JS (New Architecture)

Android mirrors the iOS approach with a Kotlin native module exposing `initialize` and `setCallbackUrl` to JS and ensuring calls execute on the UI thread.

### Files involved
- Native module and registration
  - `rn-wrapper-recipe/android/src/main/java/com/rnwrapperrecipe/SmileIDModule.kt` — Kotlin module exposing:
    - `initialize(useSandbox: Boolean, enableCrashReporting: Boolean, config: ReadableMap?, apiKey: String?)`
    - `setCallbackUrl(url: String?)`
    Both methods resolve a Promise and run on the main thread via `UiThreadUtil.runOnUiThread { ... }`.
  - `rn-wrapper-recipe/android/src/main/java/com/rnwrapperrecipe/RnWrapperRecipePackage.kt` — Registers `SmileIDModule` in `createNativeModules`.

### API surface (JS)
Same as iOS via `src/NativeSmileID.ts`:
- `initialize(useSandbox: boolean, enableCrashReporting: boolean, config?: SmileConfig, apiKey?: string): Promise<void>`
- `setCallbackUrl(url?: string): Promise<void>`

### Main-thread handling
- `initialize(...)` and `setCallbackUrl(...)` are dispatched onto the Android UI thread using `UiThreadUtil.runOnUiThread` to prevent UI access from background threads.

### Fallbacks and current behavior
- The module keeps the same fallbacks contract as iOS at the JS layer. The Kotlin implementation currently calls the safe baseline `SmileID.initialize(context, useSandbox)` which is sufficient for Compose flows.
- If you need to pass `apiKey` and/or a richer `Config` on Android as well, extend `SmileIDModule.initialize` to:
  - Map `ReadableMap` → the SDK’s `Config` (data class)
  - Prefer `initialize(context, apiKey, config, useSandbox, enableCrashReporting, requestTimeout)` if that overload exists in your SDK version
- This ensures parity with iOS while keeping the current implementation stable and compatible.

### Does this use TurboModules?
- Yes, the Kotlin module runs under the New Architecture’s TurboModule runtime via the Java/Kotlin interop path (not a codegen TurboModule). It’s discoverable through autolinking and the React Gradle plugin.

### Build steps (Android)
- The module is part of the library; autolinking will register the package. Rebuild the Android app after changes to the library.
- If you run into dependency conflicts (Kotlin or kotlinx-serialization), this template already pins versions in `android/build.gradle` using `resolutionStrategy`.
