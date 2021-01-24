//
//  WebKitManager.swift
//  GhostPlusSwift
//
//  Created by DAVID IL YONG CHUN on 2021/01/19.
//

import UIKit
import WebKit


public class WebKitManager {
    // MARK: - static variables
    public static let shared = WebKitManager()
    
    // MARK: - variables
    let processPool = WKProcessPool()
    
    var defaultUserAgent: String?
    
    var _title:String?
    
    var title:String? {
        get { return self._title }
        set(value) { self._title = value}
    }
    
    // MARK: - initialize
    private init() {
        
    }
    
    // MARK: - public methods
    public func createWKWebView() -> WKWebView {
        let preferences = WKPreferences()
        
        let userContentController = WKUserContentController()
        //userContentController.add(self, name: "app")
        
        let configuration = WKWebViewConfiguration()
        configuration.processPool = self.processPool
        configuration.preferences = preferences
        configuration.userContentController = userContentController
        configuration.allowsInlineMediaPlayback = true
        configuration.suppressesIncrementalRendering = false
        configuration.selectionGranularity = .dynamic
        if #available(iOS 10.0, *) {
            configuration.dataDetectorTypes = []
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 13.0, *) {
            configuration.defaultWebpagePreferences.preferredContentMode = .mobile
        }
        
        let webView = WKWebView(frame: UIScreen.main.bounds, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = false
        //webView.backgroundColor = .white
        //webView.scrollView.backgroundColor = .white
        //webView.scrollView.bounces = true
        //webView.scrollView.decelerationRate = .fast
        
        webView.customUserAgent = UserDefaults.standard.string(forKey: "UserAgent")
        
        return webView
    }
    
    public func grabUserAgent() {
        
        var finished = false
        var userAgent: String?
        
        let webView = WebKitManager.shared.createWKWebView()
        webView.evaluateJavaScript("navigator.userAgent") { (result, _) in
            //log.debug("result: \(result)")
            userAgent = result as? String
            finished = true
        }
        
        // synchronous
        while !finished {
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date.distantFuture)
        }
        
        NSLog("userAgent: \(String(describing: userAgent))")
        
        defaultUserAgent = userAgent
    }
    
    func setAppendUserAgent(_ appendUserAgent: String) {
        if let userAgent = defaultUserAgent?.appending(" \(appendUserAgent)") {
            UserDefaults.standard.register(defaults: ["UserAgent": userAgent])
        }
    }
}

// MARK: - WKUIDelegate
extension WebKitManager {
    static func runJavaScriptAlertPanel(viewControllerToPresent: UIViewController, title:String? = "GhostPlus", message: String, okButton:String? = "OK" , completionHandler: @escaping () -> Void) {
        let alert = UIAlertController.init(title: (title) , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title:okButton , style: .cancel, handler: { _ in
            completionHandler()
        }))
        viewControllerToPresent.present(alert, animated: true, completion: nil)
    }
    
    static func runJavaScriptConfirmPanel(viewControllerToPresent: UIViewController, message: String, title:String? = "GhostPlus" , okButton:String? = "OK" , cancelButton:String? = "Cancel" , completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController.init(title:title , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: okButton, style: .cancel, handler: { _ in
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction.init(title: cancelButton , style: .default, handler: { _ in
            completionHandler(false)
        }))
        viewControllerToPresent.present(alert, animated: true, completion: nil)
    }
    
    static func runJavaScriptTextInputPanel(viewControllerToPresent: UIViewController, title:String? = "GhostPlus" , okButton:String? = "OK" , cancelButton:String? = "Cancel" ,  prompt: String, defaultText: String?, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController.init(title: title , message: prompt, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = defaultText
        }
        alert.addAction(UIAlertAction.init(title: okButton, style: .cancel, handler: { _ in
            let inputText = alert.textFields?.first?.text
            completionHandler(inputText)
        }))
        alert.addAction(UIAlertAction.init(title: cancelButton , style: .default, handler: { _ in
            completionHandler(nil)
        }))
        viewControllerToPresent.present(alert, animated: true, completion: nil)
    }
}

// MARK: - utils
extension WebKitManager {
    func decidePolicyForAppStore(_ navigationAction: WKNavigationAction) -> Bool {
        guard let url = navigationAction.request.url else { return false }
        if url.host == "itunes.apple.com" {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                // Fallback on earlier versions
            }
            return false
        }
        return true
    }
    
    func decidePolicyForTel(_ navigationAction: WKNavigationAction) -> Bool {
        guard let url = navigationAction.request.url else { return false }
        if url.scheme == "tel" && UIApplication.shared.canOpenURL(url) {
            if let aUrl = URL(string: String(format: "telprompt:%@", (url as NSURL).resourceSpecifier ?? "")) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(aUrl)
                } else {
                    // Fallback on earlier versions
                }
                return false
            }
        }
        return true
    }
    
    func decidePolicyForEmail(_ navigationAction: WKNavigationAction) -> Bool {
        guard let url = navigationAction.request.url else { return false }
        if url.scheme == "mailto" && UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                // Fallback on earlier versions
            }
            return false
        }
        return true
    }
}

