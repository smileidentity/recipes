export { default as RnWrapperRecipeView } from './RnWrapperRecipeViewNativeComponent';
export { default as DocumentVerificationView } from './DocumentVerificationViewNativeComponent';
export { default as SmartSelfieAuthenticationView } from './SmartSelfieAuthenticationViewNativeComponent';
export { default as SmartSelfieEnrollmentView } from './SmartSelfieEnrollmentViewNativeComponent';
export { default as SmileIDNative } from './NativeSmileID';
export const initialize = (
  ...args: Parameters<import('./NativeSmileID').SmileIDModule['initialize']>
) => import('./NativeSmileID').then((m) => m.default.initialize(...args));
export const setCallbackUrl = (
  ...args: Parameters<import('./NativeSmileID').SmileIDModule['setCallbackUrl']>
) => import('./NativeSmileID').then((m) => m.default.setCallbackUrl(...args));
