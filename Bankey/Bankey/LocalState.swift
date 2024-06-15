//
//  LocalState.swift
//  Bankey
//
//  Created by 藤門莉生 on 2024/06/15.
//

import Foundation

public class LocalState {
    private enum Keys: String {
        case hasOnboarded
    }
    
    public static var hasOnboarded: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.hasOnboarded.rawValue)
        }
        
        set(newValue) {
            UserDefaults.standard.setValue(newValue, forKey: Keys.hasOnboarded.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
}
