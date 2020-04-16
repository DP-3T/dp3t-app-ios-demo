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
    private let site: String
    private var loadCount: Int = 0

    private var url: URL {
        get {
            return NSBackendEnvironment.current.staticApiBaseURL.appendingPathComponent(site)
        }

        set {}
    }

    // MARK: - Init

    init(site: String) {
        self.site = site

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

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "close".ub_localized, style: .done, target: self, action: #selector(close))

        startLoading(url: url)
    }

    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Start loading

    private func startLoading(url: URL) {
        startLoading()
        webView.load(URLRequest(url: url))
    }

    // MARK: - Setup

    private func setup() {
        webView.navigationDelegate = self

        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.backgroundColor = UIColor.ns_background_secondary

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

            if scheme == "http" || scheme == "https" {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
                return
            }

            if scheme != "http", scheme != "https" {
                guard let host = url.host
                else {
                    decisionHandler(.allow)
                    return
                }

                if host == "inform" {
                    NSInformViewController.present(from: self)
                } else {
                    let webVC = NSWebViewController(site: host)
                    if let navVC = navigationController {
                        navVC.pushViewController(webVC, animated: true)
                    } else {
                        present(NSNavigationController(rootViewController: webVC), animated: true, completion: nil)
                    }
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

    func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        loadCount = 1
    }

    func webView(_: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError error: Error) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loadCount -= 1

            if strongSelf.loadCount == 0 {
                strongSelf.stopLoading(error: error, reloadHandler: { strongSelf.startLoading(url: strongSelf.url) })
            }
        }
    }

    func webView(_: WKWebView, didFinish _: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loadCount -= 1

            if strongSelf.loadCount == 0 {
                strongSelf.stopLoading()
            }
        }
    }
}
