# Creating Your Own React Native Wrapper for SmileID SDKs

This doc provides a guide on how to create your own React Native wrapper for the SmileID SDKs. This is useful if you want to integrate the SmileID functionality into your React Native application.

If you're using Expo, we already have the [react-native-expo](https://github.com/smileidentity/react-native-expo) SDK you should use. If you're on React Native 0.74.2 and below, use the legacy [react-native SDK](https://github.com/smileidentity/react-native).

This guide is for developers on the New Architecture who want to create a custom wrapper for the SmileID SDKs.


# Overview

In the old architecture of React Native, you would have used [Native Modules](https://reactnative.dev/docs/legacy/native-modules-intro) & Native Components to access native functionality. However, in the New Architecture, you will use [Turbo Modules](https://reactnative.dev/docs/turbo-modules) and [Fabric Native Components](https://reactnative.dev/docs/fabric) to create your own wrapper. Turbo Modules are optimized for native module management, and Fabric allows for faster, more flexible rendering of native components.

## Why the library approach is recommended

We initially embedded Fabric components directly inside the app target and ran into instability—especially on iOS—due to bridging and codegen. Packaging the components as a library eliminated those issues and is the recommended path for production.

Note on iOS: Most of the pain comes from the bridging setup (ObjC++ + SwiftUI + RN Codegen registration). Descriptor registration, correct imports, and event emitter wiring are easy to misalign in an app target; a library centralizes and automates them.

Common pitfalls in app-embedded mode
- Missing registration: `RCTThirdPartyComponentsProvider.mm` doesn’t include your views, leaving them “unimplemented.” Manual edits are overwritten by CodeGen.
- Descriptor/import mismatches: Wrong generated headers or missing `+componentDescriptorProvider` implementation.
- ObjC++ linkage: Implementation must be `.mm` to talk to C++ emitters; Xcode needs the file type set correctly.
- Naming and wiring drift: Spec/class name collisions and missing provider callbacks cause runtime errors and no JS events.

How the library fixes it
- Auto CodeGen registration for components and emitters; no hand-edits to generated files.
- Clear separation of `.h` (headers), `.mm` (Fabric glue), Swift provider (UIHostingController), and SwiftUI root.
- Distribution-friendly: consumers install the package; no per-app Xcode tweaks.

Build simplification (what you avoid)
- Manual component registration scripts
- CodeGen configuration churn
- Complex native build wiring and Swift bridging headers

Pros
- Automated registration and consistent builds
- Cleaner separation and reuse across projects
- Better testability and CI/CD workflows

Cons
- Initial library setup and versioning flow

Bottom line: Use a library for your Fabric components—particularly on iOS—so you get predictable bridging and stable JS events without fragile app-level tweaks.


**Implementation Structure (rn-wrapper-recipe)**:
```
rn-wrapper-recipe/
├── package.json
├── src/
│   ├── index.tsx
│   ├── RnWrapperRecipeViewNativeComponent.ts
│   ├── DocumentVerificationViewNativeComponent.ts
│   └── __tests__/index.test.tsx
├── ios/
│   ├── RnWrapperRecipeView.h
│   ├── RnWrapperRecipeView.mm
│   ├── DocumentVerificationView.h
│   ├── DocumentVerificationView.mm
│   ├── DocumentVerificationViewProvider.swift
│   └── DocumentVerificationView.swift
├── android/
│   ├── build.gradle
│   ├── gradle.properties
│   └── src/main/java/com/rnwrapperrecipe/
│       ├── … (Fabric view classes, managers, native module)
│       └── …
├── example/
│   ├── android/
│   ├── ios/
│   └── src/App.tsx
```

# Getting Started

We scaffold the library with create-react-native-library, an official CLI for generating React Native library packages. It supports Fabric view templates and lets you pin the React Native version used in the example app and configs.

```bash
npx create-react-native-library@latest rn-wrapper-recipe --reactNativeVersion 0.78.0
```

During the interactive prompts, pick Fabric view (integration for native views to JS). The screenshot below shows the prompt flow and the Fabric view selection.

![create-react-native-library prompts — choose “Fabric view”](./Screenshot%202025-08-09%20at%2010.10.51.png)


## Try it

Run the included example to verify the wrapper and events end-to-end.

```bash
# From repo root
yarn install
yarn prepare

# Android
cd rn-wrapper-recipe/example
yarn android

# iOS (New Architecture)
cd rn-wrapper-recipe/example/ios
rm -rf Pods Podfile.lock build
RCT_NEW_ARCH_ENABLED=1 bundle exec pod install --repo-update
cd ..
yarn ios
```

If iOS fails after native changes, re-run pod install with RCT_NEW_ARCH_ENABLED=1.

# Android
This section shows how the Android pieces fit together when wrapping SmileID screens with React Native Fabric using a Compose host.

## 1) Add SmileID SDK and set up Compose

- Add the SmileID Android SDK to your module with the exact versions used by this template:

```groovy
// app/build.gradle (or your library module)
dependencies {
  implementation("com.smileidentity:android-sdk:11.1.0") {
    exclude group: 'org.jetbrains.kotlin', module: 'kotlin-stdlib'
    exclude group: 'org.jetbrains.kotlin', module: 'kotlin-stdlib-jdk7'
    exclude group: 'org.jetbrains.kotlin', module: 'kotlin-stdlib-jdk8'
    exclude group: 'org.jetbrains.kotlin', module: 'kotlin-stdlib-common'
    exclude group: 'org.jetbrains.kotlinx', module: 'kotlinx-serialization-core'
    exclude group: 'org.jetbrains.kotlinx', module: 'kotlinx-serialization-json'
    exclude group: "com.squareup.okhttp3"
  }

  // Kotlin and kotlinx versions aligned with React Native 0.78 in this template
  implementation("org.jetbrains.kotlin:kotlin-stdlib:2.0.21")
  implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:2.0.21")
  implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.7.0")

  // Support libs used by the SmileID flows here
  implementation 'androidx.fragment:fragment-ktx:1.8.8'
  implementation("com.squareup.okhttp3:okhttp:4.12.0")
  implementation("com.squareup.okhttp3:logging-interceptor:4.12.0")
}
```

- Enable Compose with the Kotlin plugins (Groovy DSL):

```groovy
// top of your module build.gradle
apply plugin: 'org.jetbrains.kotlin.plugin.compose'
apply plugin: 'org.jetbrains.kotlin.plugin.serialization'

android {
  buildFeatures { compose true }
}
```

- Align Kotlin and kotlinx-serialization to the versions used above to avoid binary mismatches with React Native:

```groovy
// build.gradle (project or module scope)
allprojects {
  configurations.configureEach {
    resolutionStrategy {
      force(
        "org.jetbrains.kotlin:kotlin-stdlib:2.0.21",
        "org.jetbrains.kotlin:kotlin-stdlib-jdk7:2.0.21",
        "org.jetbrains.kotlin:kotlin-stdlib-jdk8:2.0.21",
        "org.jetbrains.kotlin:kotlin-stdlib-common:2.0.21",
        "org.jetbrains.kotlinx:kotlinx-serialization-json:1.7.0",
        "org.jetbrains.kotlinx:kotlinx-serialization-core:1.7.0"
      )

      eachDependency { details ->
        if (details.requested.group == "org.jetbrains.kotlin") {
          details.useVersion("2.0.21")
        }
        if (details.requested.group == "org.jetbrains.kotlinx" &&
            details.requested.name.startsWith("kotlinx-serialization")) {
          details.useVersion("1.7.0")
        }
      }
    }
  }
}
```

Notes:
- These exact versions match the template’s `android/build.gradle` and are known-good with RN 0.78 and SmileID SDK 11.1.0.
- The excludes on the SmileID dependency ensure the forced Kotlin/kotlinx/OkHttp versions take effect without duplicates.

### Kotlin options (JDK 17 + metadata flag)

Add the same Kotlin compiler options as the template:

```groovy
android {
  kotlinOptions {
    jvmTarget = JavaVersion.VERSION_17.toString()
    freeCompilerArgs += ['-Xskip-metadata-version-check']
  }

  compileOptions {
    sourceCompatibility JavaVersion.VERSION_17
    targetCompatibility JavaVersion.VERSION_17
  }
}
```

Why this matters:
- jvmTarget = 17 aligns Kotlin bytecode with your Java toolchain (AGP 8.x and RN 0.78 use Java 17). This prevents class version mismatches and runtime linkage issues.
- -Xskip-metadata-version-check relaxes Kotlin’s metadata compatibility check. It’s useful when a transitive library (e.g., SmileID SDK compiled with Kotlin 2.2.x) is consumed under a forced Kotlin 2.0.21 toolchain. Without it, you may see errors like “kotlin.Metadata version is newer than supported”. Keep this flag while your dependency graph mixes Kotlin compiler versions.

## 2) Create a Fabric view that hosts Compose

Extend the provided base host `SmileIDComposeHostView`, which handles lifecycle, optional Android-side layout bridging, and direct-event dispatch to JS.

Example (SmartSelfie Authentication):

```kotlin
class SmartSelfieAuthenticationView(context: Context) :
  SmileIDComposeHostView(context = context, shouldUseAndroidLayout = true) {

  @Composable
  override fun Content() {
    SmartSelfieAuthenticationRootView(
      onResult = { result: SmartSelfieResult ->
        // Success → emit to JS
        dispatchDirectEvent(eventPropName = "onSuccess", payload = result.toWritableMap())
      },
      onError = { throwable: Throwable ->
        // Error → emit to JS
        dispatchDirectEvent(eventPropName = "onError", payload = throwable.toSmartSelfieErrorPayload())
      }
    )
  }
}
```

Tips:
- Set `shouldUseAndroidLayout = true` if your view needs a measure/layout pass after `requestLayout()` under RN (common with camera content). See Troubleshooting: [View doesn’t resize or re-layout under RN](#ts-android-requestlayout).
- The base host ensures a proper ViewModelStoreOwner and disposes composition on detach, which stabilizes CameraX and avoids retained state across navigations.

## 3) Create a View Manager

Register the view with React Native via a SimpleViewManager (Fabric-compatible). The `getName()` must match the component name used in your TS spec.

```kotlin
@ReactModule(name = "SmartSelfieAuthenticationView")
class SmartSelfieAuthenticationViewManager : SimpleViewManager<SmartSelfieAuthenticationView>() {
  override fun getName() = "SmartSelfieAuthenticationView"
  override fun createViewInstance(reactContext: ThemedReactContext) =
    SmartSelfieAuthenticationView(reactContext)
}
```

Repeat per SmileID screen (e.g., Enrollment, Document Verification).

## 4) Add the manager to your Package

```kotlin
class RnWrapperRecipePackage : ReactPackage {
  override fun createViewManagers(reactContext: ReactApplicationContext) = listOf(
    SmartSelfieAuthenticationViewManager(),
    // SmartSelfieEnrollmentViewManager(),
    // DocumentVerificationViewManager(),
  )
}
```

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

## Troubleshooting

- [Hermes crash: property not configurable / component undefined (iOS)](#ts-hermes)
- [Module Resolution Error: main could not be resolved](#ts-module-resolve)
- [Android: StackOverflowError in Compose (infinite recursion)](#ts-android-compose-recursion)
- [Android: View doesn’t resize or re-layout under RN (requestLayout ignored)](#ts-android-requestlayout)
- [Android: Camera preview shows black (CameraX lifecycle/layout under RN)](#ts-android-camerax-black)
- [Windows Common Issues](#ts-windows-common-issues)

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


<a id="ts-android-compose-recursion"></a>
### Android: StackOverflowError in Compose (infinite recursion)

Symptoms:
- Crash with `dispatchMountItems: caught exception` and `java.lang.StackOverflowError`.
- Logcat shows `androidx.compose.ui.platform.ComposeView.Content(...)` repeated many times, often alternating with `SmileIDComposeHostView.kt:<line>`.

Root cause:
- Inside a `ComposeView` configuration block, calling `setContent { Content() }` resolves `Content()` to `ComposeView.Content` instead of the host view’s abstract composable, creating an infinite recursion loop.

Fix:
1) Qualify the call to the host’s composable:
```kotlin
// In SmileIDComposeHostView.configure(...)
setContent { this@SmileIDComposeHostView.Content() }
```
2) Rebuild the Android app. The recursion will stop and the view will render normally.

Notes:
- This bug often presents only at runtime, with a very deep, repetitive stack pointing to `ComposeView.Content`.
- Renaming the host method (e.g., to `renderContent()`) also avoids the symbol collision, but qualification is sufficient.


<a id="ts-android-requestlayout"></a>
### Android: View doesn’t resize or re-layout under RN (requestLayout ignored)

Symptoms:
- Your Compose-based view does not update size when its content changes.
- Calling `requestLayout()` in native has no visible effect under React Native.

Root cause:
- React Native’s layout system (Yoga) doesn’t honor Android `requestLayout()` the way a pure native hierarchy would, so the child view isn’t re-measured/re-laid out automatically. See RN issue #17968 for background.

Fix (final approach in this template):
1) Use the provided base host view with an opt-in layout bridge.
   - `SmileIDComposeHostView(context, shouldUseAndroidLayout = true)`
   - When enabled, the host overrides `requestLayout()` to manually trigger measure/layout on the UI thread:
```kotlin
override fun requestLayout() {
  super.requestLayout()
  if (shouldUseAndroidLayout) {
    post { measureAndLayout() }
  }
}
@UiThread
fun measureAndLayout() {
  measure(
    MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY),
    MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY)
  )
  layout(left, top, right, bottom)
}
```
2) Extend the host with `shouldUseAndroidLayout = true` in your Fabric views:
```kotlin
class DocumentVerificationView(context: Context) :
  SmileIDComposeHostView(context = context, shouldUseAndroidLayout = true)
```

Trade-offs:
- This simulates Android-side layout under RN control and works well for Compose content that needs imperative re-layout.
- In some cases, Android-calculated layout may not match Yoga’s expected bounds. Use judiciously; if your view doesn’t need it, keep the default `false`.

Lifecycle/state tip:
- The base host assigns a `ViewTreeViewModelStoreOwner` from the Activity when available (FragmentActivity), or creates a custom store. It also clears any custom store on detach. This prevents retained Compose ViewModels and fixes camera re-initialization issues when navigating away and back to the view.


<a id="ts-android-camerax-black"></a>
### Android: Camera preview shows black (CameraX lifecycle/layout under RN)

Symptoms:
- Camera preview is black or briefly black when entering a SmileID Compose screen embedded in RN.
- Sometimes resolves after navigating away/back, or after rotating the device.

Root cause:
- CameraX waits for a proper LifecycleOwner state and a valid surface/size before starting the stream. Under React Native, layout timing and lifecycle propagation can differ from a pure Android hierarchy, so the preview may start before the view has stable dimensions or lifecycle. See: https://issuetracker.google.com/issues/350994519

Mitigations (used/proposed in this template):
- Use a stable composition and dispose strategy: `ViewCompositionStrategy.DisposeOnDetachedFromWindow`.
- Provide a consistent `ViewModelStoreOwner` to avoid retained state across remounts (base host does this), preventing stale camera session assumptions.
- If your flow needs imperative re-measure, enable `shouldUseAndroidLayout = true` so `requestLayout()` triggers a measure/layout pass and the preview surface gets a correct size.
- Ensure camera start happens on the UI thread and preferably after first composition/attach; if you manage CameraX directly, post initialization work until the view is attached and measured.
- Optionally set a `ViewTreeLifecycleOwner` from the Activity/Fragment if your Compose content or CameraX integration reads it directly (not required by this template, but useful for custom camera pipelines).

What to check if you still see black preview:
- Confirm `SmileID.initialize(...)` runs before opening the screen.
- Verify the host Activity is a `FragmentActivity` so internal components can access a valid lifecycle when needed.
- Log the measured width/height of the preview container; zero sizes indicate layout isn’t finalized yet.

<a id="ts-windows-common-issues"></a>
### Common Issues on Windows

#### “View config getter … CustomView … undefined” (and related build issues)

Symptoms:
- Rendering a Fabric native component fails with:
  - “View config getter callback for component `CustomView` must be a function (received `undefined`)”
  - Or build succeeds but the component is undefined at runtime.

Root cause:
- Metro resolves the wrong entry (compiled lib vs. source), or a duplicate copy of `react`/`react-native` is pulled into the bundle. This desynchronizes the Fabric component registry and the native build (codegen), so your component isn’t registered as expected.
- Typical triggers:
  - The library doesn’t expose a proper `react-native` entry and Metro loads `main` (compiled lib) instead of `src` (where codegen aligns).
  - Hierarchical lookup pulls a second copy of `react`/`react-native`.
  - Monorepo resolution isn’t mapped to the local workspace package.

Fix:

1) Library entry for Metro (package.json) 

Ensure the library exposes a React Native entry so Metro prefers the source used for codegen:

```json
{
  "main": "./lib/module/index.js",
  "react-native": "./src/index.tsx",
  "types": "./lib/typescript/src/index.d.ts"
}
```

Why: Metro should consume `src` (matching generated Fabric artifacts) while Node/resolvers use the compiled `lib` for non-RN consumers.

2) Metro config (example app)

Harden Metro for monorepo + Fabric codegen and avoid duplicate React/RN:

```js
const path = require('path');
const { getDefaultConfig } = require('@react-native/metro-config');
const { withMetroConfig } = require('react-native-monorepo-config');
const pkg = require('../package.json');

const root = path.resolve(__dirname, '..');

/**
 * Metro configuration
 * https://facebook.github.io/metro/docs/configuration
 *
 * @type {import('metro-config').MetroConfig}
 */
const config = getDefaultConfig(__dirname);

// Watch the monorepo root so edits in the library are picked up
config.watchFolders = [root];

// Resolver tweaks for monorepo + Fabric codegen
config.resolver = {
  ...(config.resolver || {}),
  // Prefer React Native entry so Metro loads src (with codegen) over compiled lib
  resolverMainFields: ['react-native', 'browser', 'main'],
  // Prevent Metro from walking up and pulling duplicates
  disableHierarchicalLookup: true,
  // Resolve deps from app and workspace to keep a single tree
  nodeModulesPaths: [
    path.join(__dirname, 'node_modules'),
    path.join(root, 'node_modules'),
  ],
  // Map singletons and the local package to the repo root
  extraNodeModules: {
    ...(config.resolver?.extraNodeModules || {}),
    [pkg.name]: root,
    'react-native': path.join(__dirname, 'node_modules/react-native'),
    react: path.join(__dirname, 'node_modules/react'),
    scheduler: path.join(__dirname, 'node_modules/scheduler'),
    // Keep your shim; add others only if installed
    'react-native-safe-area-context': path.resolve(
      __dirname,
      'shims/react-native-safe-area-context'
    ),
  },
};

module.exports = withMetroConfig(config, {
  root,
  dirname: __dirname,
});
```

Notes:
- If you need SVG support, install `react-native-svg-transformer` before enabling it in Metro. Missing transformers can prevent Metro from starting.

Verify the fix:

```powershell
cd "c:\\Users\\Guest User\\Downloads\\wrap\\example"
yarn start --reset-cache
```

In another terminal:

```powershell
cd "c:\\Users\\Guest User\\Downloads\\wrap\\example"
yarn android
```

Expected:
- Build succeeds, the app launches, and `<DocumentVerificationView />` renders without the “view config getter” error.

If the error persists:
- Ensure imports reference the local package, not a relative path or a different alias:
  - `import { DocumentVerificationView } from 'react-native-rn-wrapper-recipe';`
- Verify the Fabric component name matches across layers:
  - JS: `codegenNativeComponent<...>('DocumentVerificationView')`
  - Android: `DocumentVerificationViewManager.NAME = "DocumentVerificationView"`
  - iOS: ObjC class `DocumentVerificationView : RCTViewComponentView`
- Confirm the library’s `package.json` includes `"react-native": "./src/index.tsx"`.
- Force a fresh native build (clears CMake/C++ intermediates):

```powershell
cd "your_project_path/example"
# Stop Metro first if running
Remove-Item -Recurse -Force .\\android\\app\\.cxx -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force .\\android\\app\\build -ErrorAction SilentlyContinue
yarn android
```

#### NDK build failures: undefined libc++ symbols (Windows + RN 0.78)

Symptoms:
- Many undefined libc++ symbols during C++ link (ld.lld) when building CMake targets.

Root cause:
- NDK r27 on Windows can produce libc++ linker errors with React Native 0.78. RN 0.78 is stable with NDK r26.3.

Fix:
- Pin NDK to r26.3 in your example app’s Gradle:

```groovy
// example/android/build.gradle
ext {
  // ...
  ndkVersion = "26.3.11579264"
}
```

This avoids libc++ linker issues observed with NDK r27 on Windows.

## Resources

- [Exposing SwiftUI Views to React Native: An Integration Guide](https://www.callstack.com/blog/exposing-swiftui-views-to-react-native-an-integration-guide)
- [Native Modules](https://reactnative.dev/docs/turbo-native-modules-introduction)
- [Native Components](https://reactnative.dev/docs/fabric-native-components-introduction)
- [Deep Dive into React Native’s New Architecture: JSI, TurboModules, Fabric & Yoga](https://medium.com/@DhruvHarsora/deep-dive-into-react-natives-new-architecture-jsi-turbomodules-fabric-yoga-234bbdf853b4)

