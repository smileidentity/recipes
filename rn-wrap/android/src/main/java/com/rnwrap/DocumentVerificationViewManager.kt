package com.rnwrap

import com.facebook.react.bridge.ReadableArray
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate;
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.DocumentVerificationViewManagerInterface
import com.facebook.react.viewmanagers.DocumentVerificationViewManagerDelegate
import kotlinx.collections.immutable.persistentMapOf

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

  // Generated interface setters (implemented manually so Compose recomposes)
  @ReactProp(name = "countryCode")
  override fun setCountryCode(view: DocumentVerificationView, value: String?) { value?.let { view.countryCode = it } }
  @ReactProp(name = "userId")
  override fun setUserId(view: DocumentVerificationView, value: String?) { view.userId = value }
  @ReactProp(name = "jobId")
  override fun setJobId(view: DocumentVerificationView, value: String?) { view.jobId = value }
  @ReactProp(name = "documentType")
  override fun setDocumentType(view: DocumentVerificationView, value: String?) { view.documentType = value }
  @ReactProp(name = "captureBothSides")
  override fun setCaptureBothSides(view: DocumentVerificationView, value: Boolean) { view.captureBothSides = value }
  @ReactProp(name = "idAspectRatio")
  override fun setIdAspectRatio(view: DocumentVerificationView, value: Float) { view.idAspectRatio = value }
  @ReactProp(name = "bypassSelfieCaptureWithFile")
  override fun setBypassSelfieCaptureWithFile(view: DocumentVerificationView, value: String?) { view.bypassSelfieCaptureWithFile = value }
  @ReactProp(name = "autoCaptureTimeout")
  override fun setAutoCaptureTimeout(view: DocumentVerificationView, value: Int) { view.autoCaptureTimeout = value }
  @ReactProp(name = "autoCapture")
  override fun setAutoCapture(view: DocumentVerificationView, value: String?) { view.autoCapture = value }
  @ReactProp(name = "allowNewEnroll")
  override fun setAllowNewEnroll(view: DocumentVerificationView, value: Boolean) { view.allowNewEnroll = value }
  @ReactProp(name = "allowAgentMode")
  override fun setAllowAgentMode(view: DocumentVerificationView, value: Boolean) { view.allowAgentMode = value }
  @ReactProp(name = "allowGalleryUpload")
  override fun setAllowGalleryUpload(view: DocumentVerificationView, value: Boolean) { view.allowGalleryUpload = value }
  @ReactProp(name = "showInstructions")
  override fun setShowInstructions(view: DocumentVerificationView, value: Boolean) { view.showInstructions = value }
  @ReactProp(name = "showAttribution")
  override fun setShowAttribution(view: DocumentVerificationView, value: Boolean) { view.showAttribution = value }
  @ReactProp(name = "useStrictMode")
  override fun setUseStrictMode(view: DocumentVerificationView, value: Boolean) { view.useStrictMode = value }
  @ReactProp(name = "skipApiSubmission")
  override fun setSkipApiSubmission(view: DocumentVerificationView, value: Boolean) { view.skipApiSubmission = value }
  @ReactProp(name = "extraPartnerParams")
  override fun setExtraPartnerParams(view: DocumentVerificationView, value: ReadableArray?) {
    if (value == null) {
      view.extraPartnerParams = persistentMapOf()
      return
    }
    val builder = mutableMapOf<String, String>()
    for (i in 0 until value.size()) {
      val map = value.getMap(i)
      val k = map?.getString("key")
      val v = map?.getString("value")
      if (k != null && v != null) builder[k] = v
    }
    view.extraPartnerParams = persistentMapOf<String, String>().putAll(builder)
  }

  companion object {
    const val REACT_CLASS = "DocumentVerificationView"
  }
}
