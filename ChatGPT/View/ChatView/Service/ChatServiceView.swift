//
//  ChatServiceView.swift
//  ChatGPT
//
//  Created by Ray on 2023/3/15.
//

import UIKit

class ChatServiceView: UIView {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    typealias Model = Int
    var dataArray: [Model] = [1,2,3,4,5,6,7,8,]
    
    
    static func getView()-> ChatServiceView {
        return Bundle.main.loadNibNamed("\(self)", owner: nil)!.first as! ChatServiceView
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initCommon()
    }
    
    func initCommon() {
        // 设置流式布局
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets.zero
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "ChatServiceItemCell", bundle: nil), forCellWithReuseIdentifier: "ChatServiceItemCell")

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 设置每一个 item 大小
        let itemWidth = self.bounds.size.width / 4 // 每一行4个item
        let itemHeight = itemWidth // 高度设置为宽度的1.2倍
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        collectionView.reloadData()
    }
}

extension ChatServiceView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatServiceItemCell", for: indexPath) as! ChatServiceItemCell
        cell.textLabel.text = "\(indexPath.row)"
        cell.isSelected = false
        return cell
    }
    
    
}

extension ChatServiceView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.reloadData()
    }
    
    
    
    
}
