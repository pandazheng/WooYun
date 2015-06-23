//
//  DetailViewController.swift
//  WooYun
//
//  Created by panda zheng on 15/6/22.
//  Copyright (c) 2015年 panda zheng. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var detailUrl : String?
    
    @IBOutlet weak var webView : UIWebView!
    @IBOutlet weak var indicator : UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "漏洞详情"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
    }
    
    func loadData()
    {
        self.indicator.startAnimating()
        
        var urlString = detailUrl
        
        let url : NSURL = NSURL(string: urlString!)!
        let request : NSURLRequest = NSURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
            self.indicator.stopAnimating()
            
            if error == nil
            {
                self.webView.loadData(data, MIMEType: "text/html", textEncodingName: "utf-8", baseURL: url)
            }
            else
            {
                self.webView.loadHTMLString(error.localizedDescription, baseURL: url)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
