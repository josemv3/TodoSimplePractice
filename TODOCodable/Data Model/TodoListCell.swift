//
//  TodoListCell.swift
//  TODOCodable
//
//  Created by Joey Rubin on 10/16/22.
//

import UIKit

class TodoListCell: UITableViewCell {
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
