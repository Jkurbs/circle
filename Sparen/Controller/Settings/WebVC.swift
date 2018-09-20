//
//  WebVC.swift
//  Sparen
//
//  Created by Kerby Jean on 9/13/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class WebVC: UIViewController {

    var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        webView = UIWebView(frame: view.frame)
        webView.backgroundColor = .white
        view.addSubview(webView)
        
        let url = URL(string: "https://sparenapp.com/privacy.html")
        
        if let url = url {
            let request = URLRequest(url: url)
            let session = URLSession.shared
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    dispatch.async {
                        self.webView.loadRequest(request)
                    }
                } else {
                    print("error:", error!.localizedDescription)
                }
            }
            task.resume()
        }
    }
}
