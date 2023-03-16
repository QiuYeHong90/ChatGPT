//
//  ChatEmojiItemCell.swift
//  ChatGPT
//
//  Created by Ray on 2023/3/15.
//

import UIKit

class ChatEmojiItemCell: UICollectionViewCell {
    lazy var flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCommon()
    }
    func initCommon() {
        // 设置collectionView属性
        self.backgroundColor = .red
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = false
        collectionView.register(UINib.init(nibName: "ChatEmojiIconCell", bundle: nil), forCellWithReuseIdentifier: "ChatEmojiIconCell")
        
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = .init(top: 0, left: 0, bottom: self.safeAreaInsets.bottom, right: 0)
        
        // 将collectionView添加到视图中
        self.addSubview(collectionView)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        flowLayout.sectionInset = .init(top: 0, left: 0, bottom: self.safeAreaInsets.bottom, right: 0)
        self.collectionView.reloadData()
    }
    
}


extension ChatEmojiItemCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatEmojiIconCell", for: indexPath) as! ChatEmojiIconCell
        cell.textLab.text = "\(indexPath.row)"
        let red = CGFloat(arc4random()%255) / 255.0
        let green = CGFloat(arc4random()%255) / 255.0
        let blue = CGFloat(arc4random()%255) / 255.0
        cell.backgroundColor = UIColor.init(red: red, green: green, blue: blue, alpha: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.bounds.size.width / 4
        return CGSize.init(width: width, height: width)
    }
}
