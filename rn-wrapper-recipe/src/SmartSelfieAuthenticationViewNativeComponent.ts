import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { ViewProps } from 'react-native';
import type { DirectEventHandler } from 'react-native/Libraries/Types/CodegenTypes';

// Pass success/error as single strings to keep RN Codegen simple and robust.
// result: JSON string containing { selfieFile, livenessFiles, apiResponse? }
export type SmartSelfieAuthSuccessEvent = Readonly<{ result: string }>;
// error: plain message or a JSON string with { message, code? }
export type SmartSelfieAuthErrorEvent = Readonly<{ error: string }>;

interface NativeProps extends ViewProps {
  onSuccess?: DirectEventHandler<SmartSelfieAuthSuccessEvent>;
  onError?: DirectEventHandler<SmartSelfieAuthErrorEvent>;
}

export default codegenNativeComponent<NativeProps>('SmartSelfieAuthenticationView');
