//
//  ActivityConfig.swift
//  TSLocationManager
//

import Foundation
import TSLocationManager

extension BGGeo {
    /// A motion-activity that can trigger location-tracking: `ActivityConfig.triggerActivities`.  (WO-167) The
    /// types' TriggerActivity; the raw value is the name the SDK stores.
    public enum TriggerActivity: String, CaseIterable {
        case walking
        case onFoot = "on_foot"
        case running
        case onBicycle = "on_bicycle"
        case inVehicle = "in_vehicle"
    }

    public class ActivityConfig {
        private let module: TSActivityConfig
        init(_ module: TSActivityConfig) { self.module = module }

        public var stopDetectionDelay: TimeInterval {
            get { module.stopDetectionDelay }
            set { module.stopDetectionDelay = newValue }
        }
        public var activityRecognitionInterval: TimeInterval {
            get { module.activityRecognitionInterval }
            set { module.activityRecognitionInterval = newValue }
        }
        public var minimumActivityRecognitionConfidence: Int {
            get { Int(module.minimumActivityRecognitionConfidence) }
            set { module.minimumActivityRecognitionConfidence = newValue }
        }
        public var disableMotionActivityUpdates: Bool {
            get { module.disableMotionActivityUpdates }
            set { module.disableMotionActivityUpdates = newValue }
        }
        public var disableStopDetection: Bool {
            get { module.disableStopDetection }
            set { module.disableStopDetection = newValue }
        }
        public var stopOnStationary: Bool {
            get { module.stopOnStationary }
            set { module.stopOnStationary = newValue }
        }
        /// The motion-activities which are allowed to trigger location-tracking.  (WO-167)
        public var triggerActivities: [TriggerActivity] {
            get {
                module.triggerActivities.split(separator: ",").compactMap {
                    TriggerActivity(rawValue: $0.trimmingCharacters(in: .whitespaces))   // a name of no case is skipped
                }
            }
            set { module.triggerActivities = newValue.map(\.rawValue).joined(separator: ",") }
        }

        /// The same setting as the comma-separated string the SDK stores.
        @available(*, deprecated, renamed: "triggerActivities", message: "a [TriggerActivity] (WO-167)")
        public var triggerActivitiesString: String {
            get { module.triggerActivities }
            set { module.triggerActivities = newValue }
        }
    }
}
