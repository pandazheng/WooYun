//
//  QrViewController.swift
//  WooYun
//
//  Created by panda zheng on 15/6/22.
//  Copyright (c) 2015年 panda zheng. All rights reserved.
//

import UIKit

class QrViewController: UIViewController , UITableViewDataSource , UITableViewDelegate{
    
    var dataBug : NSArray = NSArray()
    
    @IBOutlet weak var tableView : UITableView!
    
    let Url = "http://apis.baidu.com/apistore/wooyun/confirm"
    
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "松开后自动刷新")
        tableView.addSubview(refreshControl)

        loadData()
    }
    
    //刷新数据
    func refreshData()
    {
        loadData()
        self.refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData()
    {
        var req = NSMutableURLRequest(URL: NSURL(string: Url)!)
        req.timeoutInterval = 6
        req.HTTPMethod = "GET"
        req.addValue("185a9b7258461613d884d37e9954c83b", forHTTPHeaderField: "apikey")
        NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue()) { (response : NSURLResponse!, data : NSData!, error : NSError!) -> Void in
            //let res = response as! NSHTTPURLResponse
            //println(res.statusCode)
            if let e = error
            {
                //println("请求失败")
                //alert 请求失败
                let controller = UIAlertController(title: "警告", message: "请求失败", preferredStyle: UIAlertControllerStyle.Alert)
                controller.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(controller, animated: true, completion: nil)
            }
            
            if let d = data
            {
                //println(d)
                let json : AnyObject! = NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions.AllowFragments, error: nil)
                if let ds = json as? NSArray
                {
                    self.dataBug = NSArray(array: ds)
                    //println(self.dataBug)
                    self.tableView.reloadData()              //一定要记住重载tableView
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataBug.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("QrDetailCell", forIndexPath: indexPath) as! UITableViewCell
        let cellData : NSDictionary = self.dataBug[indexPath.row] as! NSDictionary
        
        var title = cell.viewWithTag(1) as! UILabel
        var user_harmlevel = cell.viewWithTag(2) as! UILabel
        var corp_harmlevel = cell.viewWithTag(3) as! UILabel
        var date = cell.viewWithTag(4) as! UILabel
        
        title.text = cellData["title"] as? String
        //println(cellData["user_harmlevel"]!)
        //println(cellData["corp_harmlevel"]!)
        //user_harmlevel.text = cellData["user_harmlevel"] as? String
        let user_level = cellData["user_harmlevel"] as? String
        user_harmlevel.text = "用户等级: " + user_level!
        //corp_harmlevel.text = cellData["corp_harmlevel"] as? String
        let corp_level = cellData["corp_harmlevel"] as? String
        corp_harmlevel.text = "厂商等级: " + corp_level!
        date.text = cellData["date"] as? String
        //cell.textLabel?.text = cellData["title"] as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToDetail"
        {
            let indexPath = self.tableView.indexPathForSelectedRow()
            let cellData = self.dataBug[indexPath!.row] as! NSDictionary
            let webViewDetailController = segue.destinationViewController as! QrDetailViewController
            webViewDetailController.detailUrl = cellData["link"] as? String
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
