//
//  MyTheme.swift
//  IOS Browser
//
//  Created by Zindal on 03/09/20.
//  Copyright © 2020 zindal. All rights reserved.
//

import Foundation
import SwiftTheme

private let lastThemeIndexKey = "lastedThemeIndex"
private let defaults = UserDefaults.standard

enum MyThemes: Int {
    
    case light = 0
    case dark = 1
    
    // MARK: -
    static var current: MyThemes { return MyThemes(rawValue: ThemeManager.currentThemeIndex)! }
    
    // MARK: - Switch Theme
    static func switchTo(theme: MyThemes) {
        ThemeManager.setTheme(index: theme.rawValue)
        self.saveTheme(theme: theme)
    }
    
    // MARK: - Save Theme
    static func saveTheme(theme: MyThemes) {
        defaults.set(theme.rawValue, forKey: lastThemeIndexKey)
    }
    
    // MARK: - Fetch Saved Theme
    static func getSaveTheme() -> MyThemes {
        guard let index = defaults.object(forKey: lastThemeIndexKey) as? Int else { return .light }
        return MyThemes(rawValue: index)!
    }
    
    static func isNight() -> Bool {
        return current == .dark
    }
        
}
