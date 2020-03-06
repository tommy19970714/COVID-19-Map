//
//  NewsWebViewController.swift
//  CoronaMap
//
//  Created by Toshiki Tomihira on 2020/02/09.
//  Copyright © 2020 Toshiki Tomihira. All rights reserved.
//

import UIKit
import WebKit

class NewsWebViewController: UIViewController {
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var headerView: UIView!
    var webView: WKWebView!
    private var _observers = [NSKeyValueObservation]()
    var progressView: UIProgressView!
    var beginingPoint: CGPoint!
    var isViewShowed: Bool!
    var firstPageUrl: URL!
    
    func setUpProgressView() {
        self.progressView = UIProgressView(frame: CGRect(
            x: 0,
            y: headerView.frame.height,
            width: self.view.frame.width,
            height: 3.0))
        self.progressView.progressViewStyle = .bar
        self.view.addSubview(self.progressView)
        _observers.append(self.webView.observe(\.estimatedProgress, options: .new, changeHandler: { (webView, change) in
            self.progressView.alpha = 1.0
            self.progressView.setProgress(Float(change.newValue!), animated: true)
            if self.webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3,
                               delay: 0.3,
                               options: [.curveEaseOut],
                               animations: { [weak self] in
                                self?.progressView.alpha = 0.0
                    }, completion: {_ in
                        self.progressView.setProgress(0.0, animated: false)
                })
            }
        })
        )
    }
    
    @IBOutlet weak private var backButton: UIButton! {
        didSet {
            backButton.isEnabled = false
            backButton.alpha = 0.4
        }
    }
    @IBOutlet weak private var forwardButton: UIButton! {
        didSet {
            forwardButton.isEnabled = false
            forwardButton.alpha = 0.4
        }
    }
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction func tappedForwardButton(_ sender: UIButton) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    @IBAction func tappedReloadButton(_ sender: Any) {
        webView.reload()
    }
    
    override func loadView() {
        super.loadView()
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), configuration: webConfiguration)
        webView.allowsBackForwardNavigationGestures = true
        containerView.addSubview(webView)
        webView.topAnchor.constraint(equalToSystemSpacingBelow: containerView.topAnchor, multiplier: 0.0).isActive = true
        setUpProgressView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isViewShowed = false
        beginingPoint = CGPoint(x: 0, y: 0)
        _observers.append(webView.observe(\.canGoBack, options: .new){ _, change in
            if let value = change.newValue {
                 DispatchQueue.main.async {
                    self.backButton.isEnabled = value
                    self.backButton.alpha = value ? 1.0 : 0.4
                }
            }
        })
        
        _observers.append(webView.observe(\.canGoForward, options: .new){ _, change in
            if let value = change.newValue {
                 DispatchQueue.main.async {
                self.forwardButton.isEnabled = value
                self.forwardButton.alpha = value ? 1.0 : 0.4
                }
            }
        })
        
        _observers.append(webView.observe(\.isLoading, options: .new) {_, change in
            if let value = change.newValue {
                DispatchQueue.main.async {
                    self.reloadButton.isEnabled = !value
                    self.reloadButton.alpha = !value ? 1.0 : 0.4
                }
            }
        })
        
        _observers.append(webView.observe(\.title, options: .new) {_, change in
            if let value = change.newValue {
                DispatchQueue.main.async {
                    self.titleLabel.text = value
                }
            }
        })
        
        guard let url = firstPageUrl else { fatalError() }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
