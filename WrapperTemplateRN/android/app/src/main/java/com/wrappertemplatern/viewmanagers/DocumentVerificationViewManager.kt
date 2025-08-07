package com.wrappertemplatern.viewmanagers

import com.facebook.react.module.annotations.ReactModule;
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate;
import com.wrappertemplatern.views.DocumentVerificationView
import com.facebook.react.viewmanagers.DocumentVerificationViewManagerInterface;
import com.facebook.react.viewmanagers.DocumentVerificationViewManagerDelegate;

@ReactModule(name = DocumentVerificationViewManager.REACT_CLASS)
class DocumentVerificationViewManager: SimpleViewManager<DocumentVerificationView>(),
    DocumentVerificationViewManagerInterface<DocumentVerificationView> {
    private val delegate: DocumentVerificationViewManagerDelegate<DocumentVerificationView, DocumentVerificationViewManager> =
        DocumentVerificationViewManagerDelegate(this)

    override fun getDelegate(): ViewManagerDelegate<DocumentVerificationView> = delegate

    override fun getName(): String = REACT_CLASS

    override fun createViewInstance(context: ThemedReactContext): DocumentVerificationView {
        return DocumentVerificationView(context)
    }

    companion object {
        const val REACT_CLASS = "DocumentVerificationView"
    }
}