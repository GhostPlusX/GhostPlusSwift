//
//  KeychainManager.swift
//  GhostPlusSwift
//
//  Created by DAVID IL YONG CHUN on 2021/01/19.
//

import Foundation
import KeychainSwift

enum KeychainError : Error {
    case AccessGroupNotDefined
}

public class KeychainManager {
    
    public static let sharedInstance:KeychainManager = KeychainManager()
    
    var _accessGroup:String?
    
    let keychain = KeychainSwift()
    
    public var accessGroup : String? {
        get {
            return _accessGroup
        }
        set(value) {
            _accessGroup = value
            keychain.accessGroup = _accessGroup
        }
    }
   
    public func setKeychain(key:String , value:String?) throws -> Void {
        
        guard _accessGroup != nil  else  {
            throw KeychainError.AccessGroupNotDefined
        }
        
        keychain.set(value ?? "" , forKey: key)
        
    }
    
    public func getKeychain(key:String) ->Any  {
        return keychain.get( key )!
    }
    
    public func setKeychain(key:String , value:Bool? ) throws -> Void {
        guard _accessGroup != nil  else  {
            throw KeychainError.AccessGroupNotDefined
        }
        
        keychain.set(value ?? false ,  forKey: key)
    }
     
    public func setKeychain(key:String , value:Data? ) throws -> Void {
        guard _accessGroup != nil  else  {
            throw KeychainError.AccessGroupNotDefined
        }
        
        keychain.set(value ?? Data() ,  forKey: key)
    }
    
    
}


