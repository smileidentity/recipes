export { default as RnWrapView } from './RnWrapViewNativeComponent';
export { default as DocumentVerificationView } from './DocumentVerificationViewNativeComponent';
export { default as SmartSelfieAuthenticationView } from './SmartSelfieAuthenticationViewNativeComponent';
export { default as SmartSelfieEnrollmentView } from './SmartSelfieEnrollmentViewNativeComponent';
import SmileIDNative from './NativeSmileID';
export { default as SmileIDNative } from './NativeSmileID';

export const initialize = (
  ...args: Parameters<import('./NativeSmileID').SmileIDModule['initialize']>
) => SmileIDNative.initialize(...args);

export const setCallbackUrl = (
  ...args: Parameters<import('./NativeSmileID').SmileIDModule['setCallbackUrl']>
) => SmileIDNative.setCallbackUrl(...args);
