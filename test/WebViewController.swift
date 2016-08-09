//
//  WebViewController.swift
//  test
//
//  Created by Jun Yan on 8/8/16.
//  Copyright © 2016 Superbet. All rights reserved.
//

import UIKit

public class WebViewController : UIViewController {
    
    var webView: UIWebView?
    let url: NSURL
    
    init(withURL url: NSURL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        webView = UIWebView(frame: self.view.frame)
        self.view.addSubview(webView!)
        webView?.loadRequest(NSURLRequest(URL: url))
    }
}
