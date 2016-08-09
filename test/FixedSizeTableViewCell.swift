//
//  FixedSizeTableViewCell.swift
//  test
//
//  Created by Jun Yan on 8/7/16.
//  Copyright © 2016 Superbet. All rights reserved.
//

import UIKit

public class FixedSizeTableViewCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var snippet: UILabel!
    @IBOutlet var thumbnail: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
}
