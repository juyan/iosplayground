//
//  SearchResultModel.swift
//  test
//
//  Created by Jun Yan on 8/7/16.
//  Copyright © 2016 Superbet. All rights reserved.
//

import Foundation

public struct SearchResultModel {
    let title: String
    let snippet: String?
    let imageUrl: String?
    let link: String?
}

extension SearchResultModel {
    public init(json: [String:AnyObject]) {
        self.title = json["title"] as! String
        self.snippet = json["snippet"] as? String
        self.link = json["link"] as? String
        
        if let pageMap = json["pagemap"] as? [String:AnyObject] {
            if let thumbnail = pageMap["cse_thumbnail"] as? [[String:AnyObject]] {
                if thumbnail.count > 0 {
                    self.imageUrl = thumbnail[0]["src"] as? String
                } else {
                    self.imageUrl = nil
                }
            } else {
                self.imageUrl = nil
            }
        } else {
            self.imageUrl = nil
        }
    }
}