//
//  ChatServiceItemCell.swift
//  ChatGPT
//
//  Created by Ray on 2023/3/15.
//

import UIKit

class ChatServiceItemCell: UICollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectedBackgroundView = UIView.init()
//        self.backgroundView?.backgroundColor = .gray
        self.selectedBackgroundView?.backgroundColor = .gray
    }

    
}
