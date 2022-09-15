//
//  PassageSettings.swift
//  Shiny
//
//  Created by blayne bayer on 8/15/22.
//  Copyright © 2022 Apple. All rights reserved.
//
import Foundation
import os
protocol PassageAuthSettings {
    var appId: String? { get set }
    var authOrigin: String? { get set }
    var apiUrl: String? { get set }
}

internal class PassageSettings : PassageAuthSettings {
    
    // MARK: - Properties
    internal var appId: String?
    internal var authOrigin: String?
    internal var apiUrl: String? = "https://auth.passage.id"
    
    internal static let shared = PassageSettings()
    
    private init() {
        
        var config: [String: String]?
        
        if let infoPlistPath = Bundle.main.url(forResource: "Passage", withExtension: "plist") {
            do {
                let infoPlistData = try Data(contentsOf: infoPlistPath)
                
                if let dict = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? [String: String] {
                    config = dict
                }
            } catch {
                Logger().log("Error reading Passage.plist: \(error)")
            }
        }
        
        if let unwrappedConfig = config {
            if let appId = unwrappedConfig["appId"] {
                self.appId = appId
            }
            if let authOrigin = unwrappedConfig["authOrigin"] {
                self.authOrigin = authOrigin
            }
            if let apiUrl = unwrappedConfig["apiUrl"] {
                self.apiUrl = apiUrl
            }
            else {
                self.apiUrl = "https://auth.passage.id"
            }
        }
    }
    
}
