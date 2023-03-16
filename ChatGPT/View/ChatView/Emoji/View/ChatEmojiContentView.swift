//
//  ChatEmojiContentView.swift
//  ChatGPT
//
//  Created by Ray on 2023/3/15.
//

import UIKit

class ChatEmojiContentView: UIView {
    lazy var flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
    var cellDict: [String: String] = [:]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initCommon()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initCommon()
    }
    
    func initCommon() {
        // 设置collectionView属性
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = .zero
        
        // 将collectionView添加到视图中
        self.addSubview(collectionView)
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.snp.makeConstraints { make in
            make.left.right.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.reloadData()
    }
    
    func registCell(identifier: String) {
        if self.cellDict[identifier] == nil {
            collectionView.register(ChatEmojiItemCell.self, forCellWithReuseIdentifier: identifier)
            self.cellDict[identifier] = identifier
        }
        
    }
}

extension ChatEmojiContentView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "ChatEmojiItemCell_\(indexPath.row)"
        self.registCell(identifier: identifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ChatEmojiItemCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.bounds.size
    }
}
