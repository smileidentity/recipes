package com.rnwrapperrecipe

import android.content.Context
import androidx.compose.runtime.Composable

class DocumentVerificationView(context: Context) :
  SmileIDComposeHostView(
    context = context,
    shouldUseAndroidLayout = true
  ) {

  @Composable
  override fun Content() {
    DocumentVerificationRootView()
  }
}
