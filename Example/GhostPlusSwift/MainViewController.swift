//
//  ViewController.swift
//  GhostPlusSwift
//
//  Created by david1000@gmail.com on 01/19/2021.
//  Copyright (c) 2021 david1000@gmail.com. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
import GhostPlusSwift

class MainViewController: UIViewController {

    let webview : WKWebView = WebKitManager.shared.createWKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
          
        self.initWebView()
        
    }
    
    func initWebView() {
        
        self.view.addSubview(webview)
        
        webview.snp.makeConstraints {
            $0.width.equalTo(self.view.snp_width)
            $0.height.equalTo(self.view.snp_height)
        }
        
        webview.uiDelegate = self
        webview.navigationDelegate = self
        
        self.loadMain(urlString: "http://www.crewghost.com")
        
    }
    
    func loadMain(urlString:String) -> Void{
        let url:URL = URL(string:urlString)!
        self.webview.load(URLRequest.init(url: url ))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MainViewController : WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
     
        let url = navigationAction.request.url
        
        print("[ Decide ] url: \(String(describing: url))")
        
        /// 앱 스킴
        ///
        if let url = url, url.scheme == Config.WebView.AppScheme {
            
        }
        
        ///
        /// 앱스토어
        ///
        if WebKitManager.shared.decidePolicyForAppStore(navigationAction) == false {
            decisionHandler(.cancel)
            return
        }
        
        ///
        /// 전화
        ///
        if WebKitManager.shared.decidePolicyForTel(navigationAction) == false {
            decisionHandler(.cancel)
            return
        }
        
        ///
        /// 이메일
        ///
        if WebKitManager.shared.decidePolicyForEmail(navigationAction) == false {
            decisionHandler(.cancel)
            return
        }
        
        if WebKitManager.shared.decidePolicyForISP(navigationAction) == false {
            decisionHandler(.cancel)
            return 
        }
        
        ///
        /// unknown scheme url (for iOS10 higher)
        ///
        if let url = url, url.scheme != nil && (url.scheme != Config.WebView.AppScheme && url.scheme?.lowercased().starts(with: "http") == false && url.absoluteString.starts(with: "about:blank") == false) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                // Fallback on earlier versions
            }
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
         
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        let url = webView.url
        print("[ Load Start ] url: \(String(describing: url))")
        
        // show loading
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let url = navigationResponse.response.url
        print("[ Decide Response ] url: \(String(describing: url))")
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //let url = webView.url
        //log.info("[ Load Start Content ] url: \(String(describing: url))")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let url = webView.url
        print("[ Load Finish ] url: \(String(describing: url))")
        
 
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        let url = webView.url
        print("[ Server Redirect ] url: \(String(describing: url))")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        let url = webView.url
        print("[ Navigation Fail ] url: \(String(describing: url))")
        
       
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let url = webView.url
       print("[ Load Fail ] url: \(String(describing: url))")
        
    }
    
    
}

extension MainViewController : WKUIDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        print("[ Window Open ] url: \(String(describing: navigationAction.request.url))")
        webView.load(navigationAction.request)
        return nil
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        print("[ Window Close ] url: \(String(describing: webView.url))")
        webView.evaluateJavaScript("history.back();", completionHandler: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        //guard let viewController = UIViewController.currentViewController() else { return }
        WebKitManager.runJavaScriptAlertPanel(viewControllerToPresent: self, message: message, completionHandler: completionHandler)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        //guard let viewController = UIViewController.currentViewController() else { return }
        WebKitManager.runJavaScriptConfirmPanel(viewControllerToPresent: self , message: message, completionHandler: completionHandler)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
       // guard let viewController = UIViewController.currentViewController() else { return }
        WebKitManager.runJavaScriptTextInputPanel(viewControllerToPresent: self, prompt: prompt, defaultText: defaultText, completionHandler: completionHandler)
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("[ WebView Terminate ] url: \(String(describing: webView.url))")
    }
    
    /// force touch disable
    @available(iOS 10.0, *)
    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        return false
    }
    
}
