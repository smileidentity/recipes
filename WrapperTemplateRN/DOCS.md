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