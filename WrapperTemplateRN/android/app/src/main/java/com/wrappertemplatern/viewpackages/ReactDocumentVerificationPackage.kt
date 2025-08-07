package com.wrappertemplatern.viewpackages

import com.facebook.react.BaseReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.model.ReactModuleInfo
import com.facebook.react.module.model.ReactModuleInfoProvider
import com.facebook.react.uimanager.ViewManager
import com.wrappertemplatern.viewmanagers.DocumentVerificationViewManager

class ReactDocumentVerificationPackage: BaseReactPackage() {
    override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
        return listOf(DocumentVerificationViewManager())
    }
    override fun getModule(s: String, reactApplicationContext: ReactApplicationContext): NativeModule? {
        when (s) {
            DocumentVerificationViewManager.REACT_CLASS -> DocumentVerificationViewManager()
        }
        return null
    }

    override fun getReactModuleInfoProvider(): ReactModuleInfoProvider = ReactModuleInfoProvider {
        mapOf(DocumentVerificationViewManager.REACT_CLASS to ReactModuleInfo(
            name = DocumentVerificationViewManager.REACT_CLASS,
            className = DocumentVerificationViewManager.REACT_CLASS,
            canOverrideExistingModule = false,
            needsEagerInit = false,
            isCxxModule = false,
            isTurboModule = true,
        )
        )
    }
}