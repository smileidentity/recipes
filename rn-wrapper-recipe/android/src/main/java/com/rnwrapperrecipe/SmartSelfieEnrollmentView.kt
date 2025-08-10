package com.rnwrapperrecipe

import android.content.Context
import android.util.AttributeSet
import androidx.compose.runtime.Composable

class SmartSelfieEnrollmentView(context: Context) :
  SmileIDComposeHostView(
    context = context,
    shouldUseAndroidLayout = true
  ) {
  @Composable
  override fun Content() {
    SmartSelfieEnrollmentRootView()
  }
}
