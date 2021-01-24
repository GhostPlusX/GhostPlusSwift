//
//  ViewController.swift
//  GhostPlusSwift
//
//  Created by david1000@gmail.com on 01/19/2021.
//  Copyright (c) 2021 david1000@gmail.com. All rights reserved.
//

import UIKit
import GhostPlusSwift

class ViewController: UIViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uuid:String = DeviceUtil.sharedInstance.generateDeviceUUID()
        NSLog("UUID String \(uuid)")
        
        KeychainManager.sharedInstance.accessGroup = "GhostPlusSwift" 
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

