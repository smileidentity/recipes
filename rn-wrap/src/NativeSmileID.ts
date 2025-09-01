import { NativeModules } from 'react-native';

// Minimal typed surface for our native module
export type SmileConfig = {
  partner_id: string;
  auth_token: string;
  prod_lambda_url: string;
  test_lambda_url: string;
};

export interface SmileIDModule {
  initialize(
    useSandbox: boolean,
    enableCrashReporting: boolean,
    config?: SmileConfig,
    apiKey?: string
  ): Promise<void>;
  setCallbackUrl(url?: string): Promise<void>;
}

const LINKING_ERROR =
  `The native module 'SmileID' was not found.\n` +
  `• Ensure iOS pods are installed (from example/ios: pod install).\n` +
  `• Rebuild the app after installing.\n` +
  `• If you're running from source, confirm ios/SmileIDModule.* is included in the Pod and the Swift file compiles.`;

// Access the classic bridge module (compatible with New Architecture)
// We registered the module as RCT_EXPORT_MODULE(SmileID)
const SmileIDNative = (NativeModules as { SmileID?: SmileIDModule }).SmileID;

// Provide a proxy that throws clear error messages if the native side isn't linked yet
const Fallback: SmileIDModule = {
  async initialize() {
    throw new Error(LINKING_ERROR);
  },
  async setCallbackUrl() {
    throw new Error(LINKING_ERROR);
  },
};

// Wrap to coerce object config -> JSON string
const Module: SmileIDModule = {
  async initialize(useSandbox, enableCrashReporting, config, apiKey) {
    // Pass the object directly; native module will handle encoding
    return (SmileIDNative ?? Fallback).initialize(
      useSandbox,
      enableCrashReporting,
      config,
      apiKey
    );
  },
  async setCallbackUrl(url) {
    return (SmileIDNative ?? Fallback).setCallbackUrl(url);
  },
};

export default Module;
