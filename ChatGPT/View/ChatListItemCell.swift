//
//  ChatListItemCell.swift
//  ChatGPT
//
//  Created by Ray on 2023/3/16.
//

import UIKit

class ChatListItemCell: UITableViewCell {
    
    @IBOutlet weak var rightHeaderImgView: UIImageView!
    @IBOutlet weak var leftHeaderImgView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet var contentLabel_right: NSLayoutConstraint!
    @IBOutlet var contentLabel_rightGreaterThanOrEqual: NSLayoutConstraint!
    @IBOutlet var contentLabel_left: NSLayoutConstraint!
    @IBOutlet var contentLabel_leftGreaterThanOrEqual: NSLayoutConstraint!
    @IBOutlet var contentLabelBgView: UIView!
    
    var isLeft: Bool = false {
        didSet {
            self.reloadUI()
        }
    }
    var commonHeaderImgView: UIImageView? {
        if self.isLeft {
            return self.leftHeaderImgView
        }
        return self.rightHeaderImgView
    }
    
    
    func reloadUI() {
        if self.isLeft {
            self.leftHeaderImgView.isHidden = false
            self.rightHeaderImgView.isHidden = true
            self.contentLabel_left.isActive = true
            self.contentLabel_leftGreaterThanOrEqual.isActive = false
            
            self.contentLabel_right.isActive = false
            self.contentLabel_rightGreaterThanOrEqual.isActive = true
        } else {
            self.leftHeaderImgView.isHidden = true
            self.rightHeaderImgView.isHidden = false
            self.contentLabel_left.isActive = false
            self.contentLabel_leftGreaterThanOrEqual.isActive = true
            
            self.contentLabel_right.isActive = true
            self.contentLabel_rightGreaterThanOrEqual.isActive = false
        }
        
        
    }
    
    var model: MessageBodyModel? {
        didSet {
            self.isLeft = model?.role ?? .assistant == .assistant
            self.contentLabel.text = model?.content
//            self.commonHeaderImgView?.image =
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.leftHeaderImgView.layer.cornerRadius = 20
        self.leftHeaderImgView.clipsToBounds = true
        self.leftHeaderImgView.backgroundColor = .red
        self.rightHeaderImgView.layer.cornerRadius = 20
        self.rightHeaderImgView.clipsToBounds = true
        self.rightHeaderImgView.backgroundColor = .blue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
