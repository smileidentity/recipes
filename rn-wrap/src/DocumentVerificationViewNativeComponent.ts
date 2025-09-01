import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { ViewProps } from 'react-native';
import type { DirectEventHandler } from 'react-native/Libraries/Types/CodegenTypes';

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

export default codegenNativeComponent<NativeProps>('DocumentVerificationView');
