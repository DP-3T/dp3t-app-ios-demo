/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    internal var window: UIWindow?
    private var lastForegroundActivity: Date?

    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // setup sdk
        NSTracingManager.shared.initialize()

        // defer window initialization if app was launched in
        // background because of location change
        if shouldSetupWindow(application: application, launchOptions: launchOptions) {
            setupWindow()
            willAppearAfterColdstart(application, coldStart: true, backgroundTime: 0)
        }

        // setup and handle push
        let pushHandler = NSPushHandler()
        let pushRegistrationManager = UBPushRegistrationManager(registrationUrl: NSEndpoint.register.url)
        UBPushManager.shared.didFinishLaunchingWithOptions(
            launchOptions,
            pushHandler: pushHandler,
            pushRegistrationManager: pushRegistrationManager
        )

        return true
    }

    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        UBPushManager.shared.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
    }

    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        UBPushManager.shared.didFailToRegisterForRemoteNotifications(with: error)
    }

    private func shouldSetupWindow(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if application.applicationState == .background {
            return false
        }

        guard let launchOptions = launchOptions else {
            return true
        }

        let backgroundOnlyKeys: [UIApplication.LaunchOptionsKey] = [.location, .bluetoothCentrals, .bluetoothPeripherals]

        for k in backgroundOnlyKeys {
            if launchOptions.keys.contains(k) {
                return false
            }
        }

        return true
    }

    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        window?.makeKey()

        if NSContentEnvironment.current.hasTabBar {
            window?.rootViewController = NSTabBarController()
        } else {
            let nvc = NSNavigationController(rootViewController: NSHomescreenViewController())
            nvc.setNavigationBarHidden(true, animated: false)
            window?.rootViewController = nvc
        }

        setupAppearance()

        window?.makeKeyAndVisible()

        NSTracingManager.shared.beginUpdatesAndTracing()
    }

    private func willAppearAfterColdstart(_: UIApplication, coldStart: Bool, backgroundTime: TimeInterval) {
        // Logic for coldstart / background

        // if app is cold-started or comes from background > 30 minutes,
        // do the force update check
        if coldStart || backgroundTime > 30.0 * 60.0 {
            startForceUpdateCheck()
        }
    }

    func applicationDidEnterBackground(_: UIApplication) {
        lastForegroundActivity = Date()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // If window was not initialized (e.g. app was started cause
        // by a location change), we need to do that
        if window == nil {
            setupWindow()
            willAppearAfterColdstart(application, coldStart: true, backgroundTime: 0)

        } else {
            let backgroundTime = -(lastForegroundActivity?.timeIntervalSinceNow ?? 0)
            willAppearAfterColdstart(application, coldStart: false, backgroundTime: backgroundTime)
        }
    }

    func application(_: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NSTracingManager.shared.performFetch(completionHandler: completionHandler)
    }

    func application(_: UIApplication, didReceiveRemoteNotification _: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NSTracingManager.shared.performFetch(completionHandler: completionHandler)
    }

    func application(_: UIApplication, didReceiveRemoteNotification _: [AnyHashable: Any]) {
        NSTracingManager.shared.syncDatabaseIfNeeded()
    }

    // MARK: - Force update

    private func startForceUpdateCheck() {
        NSConfigManager.shared.startConfigRequest(window: window)
    }

    // MARK: - Appearance

    private func setupAppearance() {
        UIBarButtonItem.appearance().tintColor = .ns_secondary

        UINavigationBar.appearance().titleTextAttributes = [
            .font: NSLabelType.textSemiBold.font,
            .foregroundColor: UIColor.ns_primary,
        ]
    }
}
