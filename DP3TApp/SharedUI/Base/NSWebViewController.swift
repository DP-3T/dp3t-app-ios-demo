/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit
import WebKit

class NSWebViewController: NSViewController {
    // MARK: - Variables

    private let webView: WKWebView
    private let local: String?
    private var loadCount: Int = 0

    // MARK: - Init

    init(local: String) {
        self.local = local

        // Disable zoom in web view
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd,
                                                forMainFrameOnly: true)

        let contentController = WKUserContentController()
        contentController.addUserScript(script)

        let config = WKWebViewConfiguration()
        config.dataDetectorTypes = []
        config.userContentController = contentController
        webView = WKWebView(frame: .zero, configuration: config)

        super.init()
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        guard let path = Bundle.main.path(forResource: local ?? "index", ofType: "html", inDirectory: "Impressum/\("language_key".ub_localized)/")
        else { return }

        let url = URL(fileURLWithPath: path)

        do {
            var string = try String(contentsOf: url)

            string = string.replacingOccurrences(of: "{VERSION}", with: Bundle.appVersion)
            string = string.replacingOccurrences(of: "{BUILD}", with: Bundle.buildNumber + Bundle.environment)

            webView.loadHTMLString(string, baseURL: url.deletingLastPathComponent())
        } catch {}
    }

    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Setup

    private func setup() {
        webView.navigationDelegate = self

        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.backgroundColor = UIColor.ns_backgroundSecondary

        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
    }
}

extension NSWebViewController: WKNavigationDelegate {
    func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        switch navigationAction.navigationType {
        case .linkActivated:
            guard let url = navigationAction.request.url,
                let scheme = url.scheme else {
                decisionHandler(.allow)
                return
            }

            if scheme == "http" || scheme == "https" || scheme == "mailto" {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
                return
            }

            if scheme == "dp3t" || scheme == "file" {
                let webVC: NSWebViewController
//                if url.absoluteString.contains("licence") {
//                    webVC = NSWebViewController(local: "license-ios")
//                }
//                else {
                let path = (url.host ?? url.lastPathComponent).replacingOccurrences(of: ".html", with: "")
                webVC = NSWebViewController(local: path)
//                }
                webVC.title = self.title
                if let navVC = navigationController {
                    navVC.pushViewController(webVC, animated: true)
                } else {
                    present(NSNavigationController(rootViewController: webVC), animated: true, completion: nil)
                }

                decisionHandler(.cancel)
                return
            }

            decisionHandler(.allow)
            return

        default:
            decisionHandler(.allow)
            return
        }
    }
}

extension Bundle {
    static var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
    }

    static var buildNumber: String {
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""

        return buildNumber
    }

    static var environment: String {
        ""
    }
}
