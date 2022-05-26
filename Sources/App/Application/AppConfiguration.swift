//
//  AppConfiguration.swift
//  
//
//  Created by Azat Kaiumov on 25.05.22.
//

import Foundation


final class AppConfiguration {
    lazy var hostName: String = {
        
        return "0.0.0.0"
        return Self.getKeyFromBundle(key: "HostName")
    } ()
}

extension AppConfiguration {
    
    private static func getKeyFromBundle<T>(key: String) -> T {
        
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? T else {
            fatalError("\(key) must not be empty in plist")
        }
        
        return value
    }
}
