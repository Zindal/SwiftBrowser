//
//  HomeViewModelClass.swift
//  IOS Browser
//
//  Created by Zindal on 03/09/20.
//  Copyright © 2020 zindal. All rights reserved.
//

import Foundation
import UIKit

class SearchEngineManager: NSObject {
    
    static var searchEngineDidStartLoading: DefaultCallback?
    
    static var defaultSearchEngine: SearchEngineModel! {
        didSet {
            self.saveDefaultEngineValue(code: defaultSearchEngine.engineCode)
        }
    }
    
    // MARK: - SetUp Static Model Class, We can use API also.
    static func setUpModelClass() -> [SearchEngineModel] {
        let dictArr = [
            ["logoImg": #imageLiteral(resourceName: "google"), "engineName": "Google", "engineHomeURL": "https://www.google.com","engineCode":"GGL","engineQuery":"/search?q="],
            ["logoImg": #imageLiteral(resourceName: "bing"), "engineName": "Bing", "engineHomeURL": "https://www.bing.com","engineCode":"BNG","engineQuery":"/search?q="],
            ["logoImg": #imageLiteral(resourceName: "duckGo"), "engineName": "DuckDuckGo", "engineHomeURL": "https://www.duckduckgo.com","engineCode":"DGO","engineQuery":"/?q="]
        ]
        var serachEngArr : [SearchEngineModel]! = []
        for dict in dictArr {
            let model = SearchEngineModel.init(dict: dict)
            serachEngArr.append(model)
        }
        return serachEngArr
    }
    
    static func getDefaultSearchEngingIfSelected() -> (status:Bool,model:SearchEngineModel?) {
        let defaults = UserDefaults.standard
        if let code = defaults.object(forKey: "defaultEngine") as? String {
            let model = SearchEngineManager.setUpModelClass().filter { $0.engineCode == code }
            defaultSearchEngine = model.first
            return (true,model.first!)
        }
       return (false,nil)
    }
    
    static func saveDefaultEngineValue(code:String) {
        let defaults = UserDefaults.standard
        defaults.set(code, forKey: "defaultEngine")
    }

}
