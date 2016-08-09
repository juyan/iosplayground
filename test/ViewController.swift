//
//  ViewController.swift
//  test
//
//  Created by Jun Yan on 8/7/16.
//  Copyright © 2016 Superbet. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class ViewController : UIViewController {
    
    @IBOutlet var searchInput : UITextField!
    @IBOutlet var tableView: UITableView!
    
    private let apiKey = "AIzaSyCi3NeN2cfDNkXZHjNSukfxupSWptq6UNg"
    private let engineId = "016162742301786444656:kklkndkbri0"
    private let pageSize = 10
    private let cellReuseId = "SearchResultView"
    
    private var results: [SearchResultModel] = []
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(nibName: "ViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.whiteColor()
        searchInput.placeholder = "Search for what you want on Apple.com"
        searchInput.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .SingleLine
        tableView.registerNib(UINib.init(nibName: "SearchCell", bundle: nil),
                                forCellReuseIdentifier: cellReuseId)
        tableView.rowHeight = 90
        navigationItem.title = "Search"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text {
            search(text.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()))
        }
        return true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let link = results[indexPath.row].link {
            if let url = NSURL(string: link) {
                let webVC = WebViewController(withURL: url)
                self.navigationController?.pushViewController(webVC, animated: true)
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : FixedSizeTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellReuseId) as! FixedSizeTableViewCell
        cell.title.text = results[indexPath.row].title
        cell.snippet?.text = results[indexPath.row].snippet
        
        let imageUrl: NSURL?
        
        if let url = results[indexPath.row].imageUrl {
            imageUrl = NSURL(string: url)
        } else {
            imageUrl = nil
        }
        cell.thumbnail?.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(named: "PlaceHolder"))
        return cell
    }
}

extension ViewController {
    func search(query: String) {
        Alamofire.request(
            .GET,
            "https://www.googleapis.com/customsearch/v1",
            parameters: [
                "q": query,
                "cx": engineId,
                "key": apiKey,
                "num": pageSize
            ]
        ).validate()
            .responseJSON(completionHandler: {
                [weak self] (response) in
                if let json = response.result.value as? [String:AnyObject] {
                    if let elements = json["items"] as? [[String:AnyObject]] {
                        self?.results = elements.map({
                            element in
                            SearchResultModel(json: element)
                        })
                        self?.tableView.reloadData()
                    } else {
                        print(json)
                    }
                } else {
                    print(response.result.error)
                }
            })
    }
}

