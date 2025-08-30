import Foundation
import SmileID

@objc(SmileIDBridge)
public class SmileIDBridge: NSObject {
  @objc public static func setCallbackUrl(_ urlString: String?) {
    let work = {
      if let s = urlString, let url = URL(string: s) {
        SmileID.setCallbackUrl(url: url)
      } else {
        SmileID.setCallbackUrl(url: nil)
      }
    }
    if Thread.isMainThread {
      work()
    } else {
      DispatchQueue.main.async(execute: work)
    }
  }

  // Initializes the SmileID SDK. If configJson is provided and you want to use it,
  // parse it here into SmileID.Config; otherwise rely on the app bundle's smile_config.json.
  @objc public static func initializeSDK(
    _ useSandbox: Bool,
    enableCrashReporting: Bool,
    configJson: String?,
    apiKey: String?
  ) {
    let work = {
      // Advertise wrapper info (React Native + version) to the SDK
      #if SMILE_ID_VERSION
        let sdkVersion = SMILE_ID_VERSION
      #else
        let sdkVersion = "unknown"
      #endif
      SmileID.setWrapperInfo(name: .reactNative, version: sdkVersion)

      // Decode a provided config JSON if any; otherwise don't force a config
      // so the basic initialize(useSandbox:) path is available as a fallback.
      var providedConfig: Config? = nil
      if let json = configJson, let data = json.data(using: .utf8) {
        let decoder = JSONDecoder()
        // JSON keys should be snake_case matching CodingKeys in Config
        if let decoded = try? decoder.decode(Config.self, from: data) {
          providedConfig = decoded
        }
      }

      // Fallbacks:
      // 1) If both apiKey and config are provided, initialize with both
      // 2) If only config is provided, initialize with config
      // 3) Otherwise, basic initialization with just sandbox flag
      if let apiKey = apiKey, let cfg = providedConfig {
        SmileID.initialize(
          apiKey: apiKey,
          config: cfg,
          useSandbox: useSandbox,
          enableCrashReporting: enableCrashReporting,
          requestTimeout: SmileID.defaultRequestTimeout
        )
      } else if let cfg = providedConfig {
        SmileID.initialize(
          config: cfg,
          useSandbox: useSandbox
        )
      } else {
        SmileID.initialize(
          useSandbox: useSandbox
        )
      }
    }

    if Thread.isMainThread {
      work()
    } else {
      // Run synchronously on main to complete initialization before resolving the JS promise
      DispatchQueue.main.sync(execute: work)
    }
  }
}
