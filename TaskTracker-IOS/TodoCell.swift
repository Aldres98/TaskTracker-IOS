//
//  TodoCell.swift
//  TaskTracker-IOS
//
//  Created by Aldres on 25.07.2018.
//  Copyright © 2018 Aldres. All rights reserved.
//


import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var checkBox: UIView?
    @IBOutlet weak var todoText: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
