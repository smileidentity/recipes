package com.wrappertemplatern.views

import android.content.Context
import android.util.AttributeSet
import android.widget.LinearLayout
import androidx.compose.ui.platform.ComposeView

class DocumentVerificationView : LinearLayout {
    constructor(context: Context) : super(context) {
        configureComponent(context)
    }

    constructor(context: Context, attrs: AttributeSet?) : super(context, attrs) {
        configureComponent(context)
    }

    constructor(context: Context, attrs: AttributeSet?, defStyleAttr: Int) : super(
        context,
        attrs,
        defStyleAttr
    ) {
        configureComponent(context)
    }

    private fun configureComponent(context: Context) {
        layoutParams = LayoutParams(
            LayoutParams.WRAP_CONTENT,
            LayoutParams.WRAP_CONTENT
        )
        ComposeView(context).also {
            it.layoutParams = LayoutParams(
                LayoutParams.WRAP_CONTENT,
                LayoutParams.WRAP_CONTENT
            )

            it.setContent {
                DocumentVerificationViewContent()
            }
            addView(it)
        }
    }
}