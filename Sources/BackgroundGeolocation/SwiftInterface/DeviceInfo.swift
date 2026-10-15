//
//  DeviceInfo.swift
//  TSLocationManager
//

import Foundation
import TSLocationManager

extension BGGeo {
    /// The device the SDK runs on, as `getDeviceInfo()` reports it in every plugin.  (WO-168)
    ///
    /// ```swift
    /// let info = BGGeo.shared.deviceInfo
    /// print("\(info.manufacturer) \(info.model), \(info.platform) \(info.version)")
    /// ```
    public class DeviceInfo {
        private let info = TSDeviceInfo.sharedInstance()

        init() {}

        /// The device model identifier, eg `"iPhone16,1"`.
        public var model: String { info.model }
        /// `"Apple"`.
        public var manufacturer: String { info.manufacturer }
        /// The OS version, `UIDevice.systemVersion`.
        public var version: String { info.version }
        /// The OS name, `UIDevice.systemName` (`"iOS"`).
        public var platform: String { info.platform }
        /// `"swift"`: the API the app calls.  Each plugin reports its own name here.
        public var framework: String { "swift" }
    }
}
