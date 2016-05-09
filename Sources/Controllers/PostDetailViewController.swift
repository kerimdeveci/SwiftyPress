//
//  PostDetailController.swift
//  SwiftyPress
//
//  Created by Basem Emara on 3/30/16.
//
//

import UIKit
import WebKit
import ZamzamKit
import Timepiece
import Stencil
import RealmSwift

class PostDetailViewController: UIViewController, WKNavigationDelegate {
    
    static var segueIdentifier = "PostDetailSegue"
    static var detailTemplateFile = "post.html"
    
    var realm: Realm?
    var model: Post!
    
    lazy var favoriteBarButton: UIBarButtonItem = {
        return UIBarButtonItem(imageName: "star",
            target: self,
            action: #selector(favoriteTapped),
            bundleIdentifier: AppConstants.bundleIdentifier)
    }()
    
    lazy var commentBarButton: UIBarButtonItem = {
        return UIBarButtonItem(imageName: "comments",
            target: self,
            action: #selector(commentsTapped),
            bundleIdentifier: AppConstants.bundleIdentifier)
    }()
    
    /// Web view for display content detail
    lazy var webView: WKWebView = {
        // Create preferences on how the web page should be loaded
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        // Create a configuration for the preferences
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        webView.navigationDelegate = self
        
        self.view.addSubview(webView)
        
        return webView
    }()
    
    /// Template used to bind data
    lazy var template: Template? = {
        // Retrieve text from template
        guard let templateString = NSBundle.stringOfFile(
            PostDetailViewController.detailTemplateFile,
            inDirectory: AppGlobal.userDefaults[.baseDirectory])
                else { return nil }
        
        // Compile template
        return Template(templateString: templateString)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            realm = try Realm()
        } catch {
            // TODO: Log error
        }
        
        // Add toolbar buttons
        toolbarItems = [
            UIBarButtonItem(imageName: "safari", target: self, action: #selector(browserTapped), bundleIdentifier: AppConstants.bundleIdentifier),
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(imageName: "related", target: self, action: #selector(relatedTapped), bundleIdentifier: AppConstants.bundleIdentifier),
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            commentBarButton,
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            favoriteBarButton,
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(shareTapped))
        ]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Render template to web view
        webView.loadHTMLString(loadTemplate(), baseURL:
            NSURL(string: AppGlobal.userDefaults[.baseURL]))
        
        refreshFavoriteIcon()
        
        navigationController?.toolbarHidden = false
    }
    
    func loadTemplate() -> String {
        guard let template = template else { return model.content }
        
        do {
            // Bind data to template
            return try template.render(Context(dictionary: [
                "title": model.title,
                "content": model.content,
                "date": model.date?.stringFromFormat("MMMM dd, yyyy"),
                "isAffiliate": true
            ]))
        } catch {
            // Error returns raw unformatted content
            return model.content
        }
    }
    
    func refreshFavoriteIcon() {
        // Update favorite indicator
        favoriteBarButton.image = UIImage(named: model.favorite ? "star-filled" : "star",
            inBundle: AppConstants.bundle)
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Start the network activity indicator when the web view is loading
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
  
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        // Stop the network activity indicator when the loading finishes
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
  
    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.Allow)
    }
    
    func shareTapped() {
        guard let link = NSURL(string: model.link) else { return }
        
        let share = [model.title.decodeHTML(), link]
        let activity = UIActivityViewController(activityItems: share, applicationActivities: nil)
        presentViewController(activity, animated: true, completion: nil)
    }
    
    func favoriteTapped() {
        do {
            try realm?.write {
                model.favorite = !model.favorite
            }
            
            refreshFavoriteIcon()
        } catch {
            // TODO: Log error
        }
    }
    
    func commentsTapped() {
        presentSafariController("\(AppGlobal.userDefaults[.baseURL])/mobile-comments/?postid=\(model.id)")
    }
    
    func relatedTapped() {
        presentSafariController("\(AppGlobal.userDefaults[.baseURL])/mobile-related/?postid=\(model.id)")
    }
    
    func browserTapped() {
        UIApplication.sharedApplication().openURL(NSURL(string: model.link)!)
    }

}