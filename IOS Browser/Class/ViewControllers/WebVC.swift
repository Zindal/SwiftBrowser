//
//  WebViewController.swift
//  IOS Browser
//
//  Created by Zindal on 05/09/20.
//  Copyright © 2020 zindal. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import SwiftTheme

class WebVC: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var urlView: UIView!
    @IBOutlet var txtUrlLink: UITextField!
    @IBOutlet var btnSearch: UIButton!
    
    override func viewDidLoad() {
        webView.navigationDelegate = self
        loadWebView(urlStr: SearchEngineManager.defaultSearchEngine.engineHomeURL)
        
        // MARK: - Adding colors for theme selection
        setUpForTheme()

    }
    
    func setUpForTheme() {
        self.view.theme_backgroundColor = [ThemeColor.white,ThemeColor.black]
        urlView.layer.theme_borderColor = [ThemeColor.black,ThemeColor.white]
        txtUrlLink.theme_textColor = [ThemeColor.black,ThemeColor.white]
        btnSearch.theme_tintColor = [ThemeColor.black,ThemeColor.white]
    }

    // MARK: - Load WebView
    func loadWebView(urlStr:String) {
        if let url = URL.init(string: urlStr) {
            webView.load(URLRequest.init(url: url))
        }
    }

    @IBAction func btnSearchClicked(_ sender: Any) {
        
        guard txtUrlLink.text != "" else { return }
        
        if let url = URL(string: txtUrlLink.text ?? ""),UIApplication.shared.canOpenURL(url) {
            loadWebView(urlStr: (txtUrlLink.text ?? "").replacingOccurrences(of: " ", with: "%20"))
        }
        else {
            searchAsKeyword()
        }
        
    }
    
    func searchAsKeyword() {
        let urlStr = SearchEngineManager.defaultSearchEngine.engineHomeURL + SearchEngineManager.defaultSearchEngine.engineQuery + (txtUrlLink.text ?? "").replacingOccurrences(of: " ", with: "+")
        if URL.init(string: urlStr) != nil {
            loadWebView(urlStr: urlStr)
        }
    }
    
}

extension WebVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SearchEngineManager.searchEngineDidStartLoading?()
        txtUrlLink.text = webView.url?.absoluteString ?? ""
        activityIndicatorView.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicatorView.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicatorView.stopAnimating()
    }

}
