//
//  DeviceManager.swift
//  GhostPlusSwift
//
//  Created by DAVID IL YONG CHUN on 2021/01/19.
//

import Foundation
import DeviceCheck

public class DeviceUtil {
    
    public static let sharedInstance:DeviceUtil  = DeviceUtil() ;
    
    /**
               Generate Device UUID Token
     */
    public func generateDeviceUUID() -> String {
        
        var uuidString = ""
        if #available(iOS 11.0, *) {
            let currentDevice = DCDevice.current
            if currentDevice.isSupported {
                currentDevice.generateToken {
                    (data , error) in
                    guard let data = data else {
                        return
                    }
                    uuidString = data.base64EncodedString()
                }
            }
        } else {
            uuidString = UIDevice.current.identifierForVendor!.uuidString
        }
        
        return uuidString
     
    }
    
    
}
