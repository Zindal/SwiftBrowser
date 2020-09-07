//
//  SearchEnginePickerVC.swift
//  IOS Browser
//
//  Created by Zindal on 03/09/20.
//  Copyright © 2020 zindal. All rights reserved.
//

import UIKit
import SwiftTheme

typealias DefaultCallback = (()->())

class SearchEnginePickerVC: UIViewController {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tableView: UITableView!
    static let cellIdentifier = "SearchEngineListTblCell"
    var serachEngArr : [SearchEngineModel]! = []
    var enginePicked: DefaultCallback?
    @IBOutlet var btnDismiss: UIButton!
    var isFromSetting: Bool! = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Get list of search engine
        getListOfSearchEngine()
        
        // MARK: - Adding colors for theme selection
        setUpForTheme()
        
        // MARK: - Show dismiss button when from setting
        btnDismiss.isHidden = !isFromSetting
        
    }

    // MARK: - Retrive List of Search Engine NOTE: Static Value right now.
    func getListOfSearchEngine() {
        self.serachEngArr = SearchEngineManager.setUpModelClass()
        tableView.reloadData()
    }
    
    func setUpForTheme() {
        self.view.theme_backgroundColor = [ThemeColor.customWhite,ThemeColor.black]
        lblTitle.theme_textColor = [ThemeColor.black,ThemeColor.white]
        btnDismiss.theme_setTitleColor([ThemeColor.black,ThemeColor.white], forState: .normal)
    }

    @IBAction func btnDismissClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SearchEnginePickerVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serachEngArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: SearchEnginePickerVC.cellIdentifier) as? SearchEngineListTblCell {
            let model = serachEngArr[indexPath.row]
            cell.setUpCell(model)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = serachEngArr[indexPath.row]
        SearchEngineManager.defaultSearchEngine = model
        tableView.reloadData()
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                self.enginePicked?()
            }
        }
    }
    
}
