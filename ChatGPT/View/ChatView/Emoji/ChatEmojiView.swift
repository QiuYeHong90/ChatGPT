//
//  EmojiView.swift
//  ChatGPT
//
//  Created by Ray on 2023/3/15.
//

import UIKit



class ChatEmojiView: UIView {
    
    static func getView()-> ChatEmojiView {
        return Bundle.main.loadNibNamed("\(self)", owner: nil)!.first as! ChatEmojiView
    }
    
}
