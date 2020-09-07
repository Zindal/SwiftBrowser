//
//  SettingsVC.swift
//  IOS Browser
//
//  Created by Zindal on 07/09/20.
//  Copyright © 2020 zindal. All rights reserved.
//

import Foundation
import UIKit
import SwiftTheme

class SettingsVC: UITableViewController {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnDismiss: UIButton!
    
    @IBOutlet var btnSwitch: UISwitch!
    @IBOutlet var lblCurrentEngine: UILabel!
    
    @IBOutlet var labelDefaultEngine: UILabel!
    @IBOutlet var labelDarkTheme: UILabel!
    override func viewDidLoad() {
        
        // MARK:- Set status of switch
        btnSwitch.setOn(MyThemes.isNight(), animated: false)
        
        // MARK:- Setup Theme
        setUpTheme()
    }
    
    func setUpTheme() {
        lblTitle.theme_textColor = [ThemeColor.black,ThemeColor.white]
        btnDismiss.theme_setTitleColor([ThemeColor.black,ThemeColor.white], forState: .normal)
        self.view.theme_backgroundColor = [ThemeColor.customWhite,ThemeColor.black]
    }
    
    @IBAction func tapOpenSearchEnginePicker(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchEnginePickerVC") as! SearchEnginePickerVC
        vc.enginePicked = {
            self.lblCurrentEngine.text = "Current : " + SearchEngineManager.defaultSearchEngine.engineHomeURL
        }
        vc.modalPresentationStyle = .fullScreen
        vc.isFromSetting = true
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func switchTheme(_ sender: Any) {
        MyThemes.switchTo(theme: btnSwitch.isOn ? .dark : .light)
    }
    
    @IBAction func btnDismissClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
