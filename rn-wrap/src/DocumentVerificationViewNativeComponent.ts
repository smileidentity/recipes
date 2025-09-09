import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { ViewProps } from 'react-native';
import type {
  DirectEventHandler,
  Float,
  Int32,
  WithDefault,
} from 'react-native/Libraries/Types/CodegenTypes';

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

// String literal union (codegen doesn't support TS enums for component props)
export type AutoCapture =
  | 'AutoCapture'
  | 'AutoCaptureOnly'
  | 'ManualCaptureOnly';

// Individual props (flattened) so Fabric codegen produces native setters.
// NOTE: Keep names in sync with Kotlin view property setters you'll implement.
// Avoid nesting (e.g. params={{}}) because Fabric codegen doesn't currently
// generate partial diff setters for nested objects.
export interface NativeProps extends ViewProps {
  countryCode: string;
  userId?: string;
  jobId?: string;
  documentType?: string;
  captureBothSides?: boolean;
  idAspectRatio?: Float;
  bypassSelfieCaptureWithFile?: string;
  autoCaptureTimeout?: Int32; // seconds
  autoCapture?: WithDefault<AutoCapture, 'AutoCapture'>;
  allowNewEnroll?: boolean;
  allowAgentMode?: boolean;
  allowGalleryUpload?: boolean;
  showInstructions?: boolean;
  showAttribution?: boolean;
  skipApiSubmission?: boolean;
  useStrictMode?: boolean;
  extraPartnerParams?: ReadonlyArray<Readonly<{ key: string; value: string }>>;

  // Events
  onSuccess?: DirectEventHandler<DocumentVerificationSuccessEvent>;
  onError?: DirectEventHandler<DocumentVerificationErrorEvent>;
}

export default codegenNativeComponent<NativeProps>('DocumentVerificationView');
