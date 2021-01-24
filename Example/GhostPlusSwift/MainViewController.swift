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
         
        
        self.view.addSubview(webview)
        
        webview.snp.makeConstraints {
            $0.width.equalTo(self.view.snp_width)
            $0.height.equalTo(self.view.snp_height)
        }
        
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

