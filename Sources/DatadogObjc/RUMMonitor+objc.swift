/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import Foundation
import UIKit
import class Datadog.DDRUMMonitor
import class Datadog.RUMMonitor
import enum Datadog.RUMErrorSource
import enum Datadog.RUMUserActionType
import enum Datadog.RUMResourceKind
import enum Datadog.RUMMethod
import struct Datadog.RUMView
import protocol Datadog.UIKitRUMViewsPredicate

internal struct UIKitRUMViewsPredicateBridge: UIKitRUMViewsPredicate {
    let objcPredicate: DDUIKitRUMViewsPredicate

    func rumView(for viewController: UIViewController) -> RUMView? {
        return objcPredicate.rumView(for: viewController)?.swiftView
    }
}

@objc
public class DDRUMView: NSObject {
    let swiftView: RUMView

    @objc public var path: String { swiftView.path }
    @objc public var attributes: [String: Any] { swiftView.attributes }

    /// Initializes the RUM View description.
    /// - Parameters:
    ///   - path: the RUM View path, appearing as "PATH" in RUM Explorer.
    ///   - attributes: additional attributes to associate with the RUM View.
    @objc
    public init(path: String, attributes: [String: Any]) {
        swiftView = RUMView(
            path: path,
            attributes: castAttributesToSwift(attributes)
        )
    }
}

@objc
public protocol DDUIKitRUMViewsPredicate: AnyObject {
    /// The predicate deciding if the RUM View should be started or ended for given instance of the `UIViewController`.
    /// - Parameter viewController: an instance of the view controller noticed by the SDK.
    /// - Returns: RUM View parameters if received view controller should start/end the RUM View, `nil` otherwise.
    func rumView(for viewController: UIViewController) -> DDRUMView?
}

@objc
public enum DDRUMErrorSource: Int {
    /// Error originated in the source code.
    case source
    /// Error originated in the network layer.
    case network
    /// Error originated in a webview.
    case webview
    /// Custom error source.
    case custom

    internal var swiftType: RUMErrorSource {
        switch self {
        case .source: return .source
        case .network: return .network
        case .webview: return .webview
        case .custom: return .custom
        default: return .custom
        }
    }
}

@objc
public enum DDRUMUserActionType: Int {
    case tap
    case scroll
    case swipe
    case custom

    internal var swiftType: RUMUserActionType {
        switch self {
        case .tap: return .tap
        case .scroll: return .scroll
        case .swipe: return .swipe
        case .custom: return .custom
        default: return .custom
        }
    }
}

@objc
public enum DDRUMResourceKind: Int {
    case image
    case xhr
    case beacon
    case css
    case document
    case fetch
    case font
    case js
    case media
    case other

    internal var swiftType: RUMResourceKind {
        switch self {
        case .image: return .image
        case .xhr: return .xhr
        case .beacon: return .beacon
        case .css: return .css
        case .document: return .document
        case .fetch: return .fetch
        case .font: return .font
        case .js: return .js
        case .media: return .media
        default: return .other
        }
    }
}

@objc
public enum DDRUMMethod: Int {
    case post
    case get
    case head
    case put
    case delete
    case patch

    internal var swiftType: RUMMethod {
        switch self {
        case .post: return .post
        case .get: return .get
        case .head: return .head
        case .put: return .put
        case .delete: return .delete
        case .patch: return .patch
        default: return .get
        }
    }
}

@objc
public class DDRUMMonitor: NSObject {
    // MARK: - Internal

    internal let swiftRUMMonitor: Datadog.DDRUMMonitor

    internal init(swiftRUMMonitor: Datadog.DDRUMMonitor) {
        self.swiftRUMMonitor = swiftRUMMonitor
    }

    // MARK: - Public

    @objc
    override public convenience init() {
        self.init(swiftRUMMonitor: RUMMonitor.initialize())
    }

    @objc
    public func startView(
        viewController: UIViewController,
        path: String?,
        attributes: [String: Any]
    ) {
        swiftRUMMonitor.startView(viewController: viewController, path: path, attributes: castAttributesToSwift(attributes))
    }

    @objc
    public func stopView(
        viewController: UIViewController,
        attributes: [String: Any]
    ) {
        swiftRUMMonitor.stopView(viewController: viewController, attributes: castAttributesToSwift(attributes))
    }

    @objc
    public func startView(
        key: String,
        path: String?,
        attributes: [String: Any]
    ) {
        swiftRUMMonitor.startView(key: key, path: path, attributes: castAttributesToSwift(attributes))
    }

    @objc
    public func stopView(
        key: String,
        attributes: [String: Any]
    ) {
        swiftRUMMonitor.stopView(key: key, attributes: castAttributesToSwift(attributes))
    }

    @objc
    public func addTiming(name: String) {
        swiftRUMMonitor.addTiming(name: name)
    }

    @objc
    public func addError(
        message: String,
        source: DDRUMErrorSource,
        stack: String?,
        attributes: [String: Any]
    ) {
        swiftRUMMonitor.addError(message: message, source: source.swiftType, stack: stack, attributes: castAttributesToSwift(attributes))
    }

    @objc
    public func addError(
        error: Error,
        source: DDRUMErrorSource,
        attributes: [String: Any]
    ) {
        swiftRUMMonitor.addError(error: error, source: source.swiftType, attributes: castAttributesToSwift(attributes))
    }

    @objc
    public func startResourceLoading(
        resourceKey: String,
        request: URLRequest,
        attributes: [String: Any]
    ) {
        swiftRUMMonitor.startResourceLoading(resourceKey: resourceKey, request: request, attributes: castAttributesToSwift(attributes))
    }

    @objc
    public func startResourceLoading(
        resourceKey: String,
        url: URL,
        attributes: [String: Any]
    ) {
        swiftRUMMonitor.startResourceLoading(resourceKey: resourceKey, url: url, attributes: castAttributesToSwift(attributes))
    }

    @objc
    public func startResourceLoading(
        resourceKey: String,
        httpMethod: DDRUMMethod,
        urlString: String,
        attributes: [String: Any]
    ) {
        swiftRUMMonitor.startResourceLoading(resourceKey: resourceKey, httpMethod: httpMethod.swiftType, urlString: urlString, attributes: castAttributesToSwift(attributes))
    }

    @objc
    public func addResourceMetrics(
        resourceKey: String,
        metrics: URLSessionTaskMetrics,
        attributes: [String: Any]
    ) {
        swiftRUMMonitor.addResourceMetrics(resourceKey: resourceKey, metrics: metrics, attributes: castAttributesToSwift(attributes))
    }

    @objc
    public func stopResourceLoading(
        resourceKey: String,
        response: URLResponse,
        attributes: [String: Any]
    ) {
        swiftRUMMonitor.stopResourceLoading(resourceKey: resourceKey, response: response, attributes: castAttributesToSwift(attributes))
    }

    @objc
    public func stopResourceLoading(
        resourceKey: String,
        statusCode: Int,
        kind: DDRUMResourceKind,
        attributes: [String: Any]
    ) {
        swiftRUMMonitor.stopResourceLoading(resourceKey: resourceKey, statusCode: statusCode, kind: kind.swiftType, attributes: castAttributesToSwift(attributes))
    }

    @objc
    public func stopResourceLoadingWithError(
        resourceKey: String,
        error: Error,
        response: URLResponse?,
        attributes: [String: Any]
    ) {
        swiftRUMMonitor.stopResourceLoadingWithError(resourceKey: resourceKey, error: error, response: response, attributes: castAttributesToSwift(attributes))
    }

    @objc
    public func stopResourceLoadingWithError(
        resourceKey: String,
        errorMessage: String,
        response: URLResponse?,
        attributes: [String: Any]
    ) {
        swiftRUMMonitor.stopResourceLoadingWithError(resourceKey: resourceKey, errorMessage: errorMessage, response: response, attributes: castAttributesToSwift(attributes))
    }

    @objc
    public func startUserAction(
        type: DDRUMUserActionType,
        name: String,
        attributes: [String: Any]
    ) {
        swiftRUMMonitor.startUserAction(type: type.swiftType, name: name, attributes: castAttributesToSwift(attributes))
    }

    @objc
    public func stopUserAction(
        type: DDRUMUserActionType,
        name: String?,
        attributes: [String: Any]
    ) {
        swiftRUMMonitor.stopUserAction(type: type.swiftType, name: name, attributes: castAttributesToSwift(attributes))
    }

    @objc
    public func addUserAction(
        type: DDRUMUserActionType,
        name: String,
        attributes: [String: Any]
    ) {
        swiftRUMMonitor.addUserAction(type: type.swiftType, name: name, attributes: castAttributesToSwift(attributes))
    }

    @objc
    public func addAttribute(
        forKey key: String,
        value: Any
    ) {
        swiftRUMMonitor.addAttribute(forKey: key, value: AnyEncodable(value))
    }

    @objc
    public func removeAttribute(forKey key: String) {
        swiftRUMMonitor.removeAttribute(forKey: key)
    }
}
