//
//  HomeVC.swift
//  IOS Browser
//
//  Created by Zindal on 03/09/20.
//  Copyright © 2020 zindal. All rights reserved.
//

import UIKit
import WebKit
import SwiftTheme

class HomeVC: UIViewController {

    @IBOutlet var bottomView: UIView!
    @IBOutlet var btnGoBack: UIButton!
    @IBOutlet var btnGoForward: UIButton!
    @IBOutlet var btnAddNew: UIButton!
    
    @IBOutlet var barButtonSetting: UIBarButtonItem!
    @IBOutlet var containerView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    var viewControllers: [WebVC] = []
    var pageController: UIPageViewController!
    var selectedIndex: Int! = 0

    override func viewDidLoad() {
        super.viewDidLoad()
                
        // MARK: - Check if user already has selected default search engine
        checkForDefaultSearchEngine()

        // MARK: - Update tabs
        SearchEngineManager.searchEngineDidStartLoading = {
            self.collectionView.reloadData()
        }
        
        // MARK: - Adding colors for theme selection
        setUpForTheme()
       
    }
    
    func setUpForTheme() {
        barButtonSetting.theme_tintColor = [ThemeColor.black,ThemeColor.white]
        navigationController?.navigationBar.theme_barTintColor = [ThemeColor.white,ThemeColor.black]
        bottomView.theme_backgroundColor = [ThemeColor.white,ThemeColor.black]
        btnGoBack.theme_tintColor = [ThemeColor.black,ThemeColor.white]
        btnGoForward.theme_tintColor = [ThemeColor.black,ThemeColor.white]
        btnAddNew.theme_tintColor = [ThemeColor.black,ThemeColor.white]
    }
    
    // MARK: - SetUp Page Controller for Tabs
    func setUpPageController() {
                
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self
        
        pageController.view.frame = CGRect(x:0,y:0,width: containerView.frame.size.width,height: containerView.frame.size.height);
        addChild(pageController)
        containerView.addSubview(pageController.view)
        pageController.didMove(toParent: self)

        let views = ["pageController": pageController.view] as [String: AnyObject]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[pageController]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[pageController]|", options: [], metrics: nil, views: views))
        
        viewControllers.append(createNewWebView())
        self.switchViewController(index: 0)
        self.collectionView.reloadData()
        
    }
    
    // MARK: - Switch Controller for Tabs
    func switchViewController(index:Int) {
        self.selectedIndex = index
        pageController.setViewControllers([viewControllers[index]], direction: .forward, animated: false)
    }

    // MARK: - Check for default search engine, if not selected open search engine picker
    func checkForDefaultSearchEngine() {
        let value = SearchEngineManager.getDefaultSearchEngingIfSelected()
        if !value.status {
            openSearchEnginePicker()
        }
        else{
            setUpPageController()
        }
    }
    
    // MARK: - Open Search Engine Picker
    func openSearchEnginePicker() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchEnginePickerVC") as! SearchEnginePickerVC
        vc.enginePicked = {
            self.setUpPageController()
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)

    }
        
    // MARK: - Get Current Tab
    func selectedWebVC() -> WebVC {
        return self.viewControllers[selectedIndex]
    }
    
    // MARK: - Create New Tab
    func createAndUpdateWebView() {
        let webVC = createNewWebView()
        viewControllers.append(webVC)
        collectionView.reloadData()
    }
    
    func createNewWebView() -> WebVC {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let webVC = sb.instantiateViewController(withIdentifier: "WebVC") as! WebVC
        return webVC
    }
    
    @objc func closeTab(sender:UIButton) {
        guard let cell = sender.superview?.superview as? TabCollectionCell else { return }
        guard let index = collectionView.indexPath(for: cell)?.row else { return }
        viewControllers[index].removeFromParent()
        viewControllers.remove(at: index)
        collectionView.reloadData()
        if viewControllers.count == 0 {
            self.btnAddNewTabClicked(self)
        }
        else {
            self.switchViewController(index: self.viewControllers.count - 1)
        }
    }
    
    @IBAction func btnSettingClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnPreviousClicked(_ sender: Any) {
        if selectedWebVC().webView.canGoBack {
            selectedWebVC().webView.goBack()
        }
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        if selectedWebVC().webView.canGoForward {
            selectedWebVC().webView.goForward()
        }
    }
    
    @IBAction func btnAddNewTabClicked(_ sender: Any) {
        createAndUpdateWebView()
        self.switchViewController(index: self.viewControllers.count - 1)
    }
    
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCollectionCell", for: indexPath) as? TabCollectionCell {
            
            cell.layer.cornerRadius = 5.0
            cell.layer.borderWidth = 1.0
            cell.layer.theme_borderColor = [ThemeColor.black,ThemeColor.white]
            
            let webVC = viewControllers[indexPath.row]
            cell.lblHostName.text = webVC.webView?.url?.host ?? "New Tab"
            cell.btnCancel.addTarget(self, action: #selector(self.closeTab(sender:)), for: .touchUpInside)
            cell.lblHostName.theme_textColor = [ThemeColor.black,ThemeColor.white]
            return cell
            
        }
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.switchViewController(index: indexPath.row)
    }
    
}

extension HomeVC : UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = viewControllers.firstIndex(of: viewController as! WebVC) {
            if index > 0 {
                return viewControllers[index - 1]
            } else {
                return nil
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = viewControllers.firstIndex(of: viewController as! WebVC) {
            if index < viewControllers.count - 1 {
                return viewControllers[index + 1]
            } else {
                return nil
            }
        }
        
        return nil
    }
}
