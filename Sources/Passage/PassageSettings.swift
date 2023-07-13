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

public struct Settings : Codable {
    public var version: String
}

internal class PassageSettings : PassageAuthSettings {
    
    // MARK: - Properties
    internal var appId: String?
    internal var authOrigin: String?
    internal var apiUrl: String? = "https://auth.passage.id"
    internal var version: String
    internal var language: String?
    
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
            if let language = unwrappedConfig["language"] {
                self.language = language
            }
            else {
                self.apiUrl = "https://auth.passage.id"
            }
        }
        
        #if SWIFT_PACKAGE
        do {
            let settingsUrl = Bundle.module.url(forResource: "settings", withExtension: "json")
            let settingsData = try Data(contentsOf: settingsUrl!)
            let decoder = JSONDecoder()
            let settings = try decoder.decode(Settings.self, from: settingsData)
            self.version = settings.version
        } catch {
            version = "unknown"
        }
        #else
        self.version = "1.0.0"
        #endif
    }
    
    
    
}
