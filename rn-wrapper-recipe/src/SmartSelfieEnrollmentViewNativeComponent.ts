import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { ViewProps } from 'react-native';
import type { DirectEventHandler } from 'react-native/Libraries/Types/CodegenTypes';

// String-based events to keep codegen robust
export type SmartSelfieEnrollSuccessEvent = Readonly<{ result: string }>;
export type SmartSelfieEnrollErrorEvent = Readonly<{ error: string }>;

interface NativeProps extends ViewProps {
  onSuccess?: DirectEventHandler<SmartSelfieEnrollSuccessEvent>;
  onError?: DirectEventHandler<SmartSelfieEnrollErrorEvent>;
}

export default codegenNativeComponent<NativeProps>('SmartSelfieEnrollmentView');
