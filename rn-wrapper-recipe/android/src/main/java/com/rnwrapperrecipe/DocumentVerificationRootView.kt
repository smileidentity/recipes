package com.rnwrapperrecipe

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import com.smileidentity.SmileID
import com.smileidentity.compose.DocumentVerification

@Composable
fun DocumentVerificationRootView() {
  Column (
    modifier = Modifier
      .fillMaxSize(),
    horizontalAlignment = Alignment.CenterHorizontally,
    verticalArrangement = Arrangement.Center
  ) {
    SmileID.DocumentVerification(
      countryCode = "KE"
    )
  }
}
