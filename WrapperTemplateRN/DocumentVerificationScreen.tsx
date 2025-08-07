
import React from 'react';
import {View, StyleSheet} from 'react-native';
import DocumentVerificationView  from './specs/DcoumentVerificationNativeComponent.ts';


export default function DocumentVerificationScreen() {
  return (
    <View style={styles.container}>
      <DocumentVerificationView style={styles.nativeView} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  nativeView: {
    flex: 1,
    width: '100%',
  },
});
