//
//  ChatInputView.swift
//  ChatGPT
//
//  Created by Ray on 2023/3/14.
//

import SnapKit
import UIKit
import GrowingTextView
class ChatInputView: UIView {
    @IBOutlet var contentView: UIView!
    lazy var emojiView: ChatEmojiView = ChatEmojiView.getView()
    lazy var serviceView: ChatServiceView = ChatServiceView.getView()
    
    
    @IBOutlet weak var textView_height: NSLayoutConstraint!
    @IBOutlet weak var textView: GrowingTextView!
    
    enum KeyBoardStatus: Equatable {
        case showText
        case hide
        case showMore(type: ShowStatus)
        
        enum ShowStatus {
            /// 表情键盘
            case emoji
//            /// 服务键盘
            case service
            
            func keyboardHeight() -> CGFloat {
                switch self {
                case .emoji:
                    return 350
                case .service:
                    return 300
                }
            }
        }
        
    }
    
    var showStatus: KeyBoardStatus = .hide {
        didSet {
            // 做隐藏处理
            if oldValue == self.showStatus {
                return
            }
            
            switch oldValue {
            case .hide:
                
                break
            case .showText:
                self.textView?.resignFirstResponder()
                break
            case .showMore(type: let type):
                switch type {
                case .emoji:
                    self.emojiView.snp.updateConstraints { make in
                        make.top.equalTo(self.contentView.snp.bottom).offset(type.keyboardHeight())
                    }
                case .service:
                    self.serviceView.snp.updateConstraints { make in
                        make.top.equalTo(self.contentView.snp.bottom).offset(type.keyboardHeight())
                    }
                }
            }
            
            switch self.showStatus {
            case .hide:
                if self.textView?.isFirstResponder ?? false {
                    self.textView?.resignFirstResponder()
                } else {
                    self.animate(duation: 0.25, height: 0)
                }
                
            case .showText:
                break
            case .showMore(type: let type):
                switch type {
                case .emoji:
                    self.bringSubviewToFront(self.emojiView)
                    self.emojiView.snp.updateConstraints { make in
                        make.top.equalTo(self.contentView.snp.bottom).offset(0)
                    }
                case .service:
                    self.bringSubviewToFront(self.serviceView)
                    self.serviceView.snp.updateConstraints { make in
                        make.top.equalTo(self.contentView.snp.bottom).offset(0)
                    }
                }
                if self.textView?.isFirstResponder ?? false {
                    self.textView?.resignFirstResponder()
                } else {
                    self.animate(duation: 0.25, height: type.keyboardHeight())
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCommon()
    }
    @objc func willShowKeyBoard(notif: Notification) {
        self.showStatus = .showText
        print("notif.userInfo == \(notif.userInfo)")
        let endFrame = notif.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? NSValue
        
        let duartion = notif.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? NSNumber
        self.animate(duation: duartion?.floatValue ?? 0, height: endFrame?.cgRectValue.height ?? 0)
        
        
        
    }
    
    @objc func willHideKeyBoard(notif: Notification) {
        print("notif.userInfo == \(notif.userInfo)")
        let duartion = notif.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? NSNumber
        switch self.showStatus {
        case .hide:
            break
        case .showText:
            break
        case .showMore(type: let type):
            
            self.animate(duation: duartion?.floatValue ?? 0, height: type.keyboardHeight())
            return
        }
        
        self.animate(duation: duartion?.floatValue ?? 0, height: 0)
    }
    
    
    
    
    func animate(duation: Float, height: CGFloat) {
        print("duation == \(duation) height = \(height)")
        self.contentView.snp.updateConstraints { make in
            make.bottom.equalTo(-height)
        }
        UIView.animate(withDuration: TimeInterval(duation)) {
            self.superview?.layoutIfNeeded()
        }
    }
    
    func initCommon() {
        Bundle.init(for: Self.self).loadNibNamed("\(Self.self)", owner: self)
        
        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { make in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.willShowKeyBoard(notif:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.willHideKeyBoard(notif:)), name: UIApplication.keyboardWillHideNotification, object: nil)
        
        textView.minHeight = 30
        textView.maxHeight = 100
        textView.delegate = self
        textView.returnKeyType = .send
        
        self.configUI()
    }
    
    func configUI() {
//        textView.inputView =
        self.addSubview(self.emojiView)
        self.emojiView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            
            make.top.equalTo(self.contentView.snp.bottom).offset(KeyBoardStatus.ShowStatus.emoji.keyboardHeight())
            make.height.equalTo(KeyBoardStatus.ShowStatus.emoji.keyboardHeight())
        }
        
        self.addSubview(self.serviceView)
        self.serviceView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            
            make.top.equalTo(self.contentView.snp.bottom).offset(KeyBoardStatus.ShowStatus.service.keyboardHeight())
            make.height.equalTo(KeyBoardStatus.ShowStatus.service.keyboardHeight())
        }
        
    }
    
    
    @IBAction func leftBtnClick(_ sender: Any) {
        self.showStatus = .hide
    }
    
    @IBAction func emojiClick(_ sender: Any) {
        self.showStatus = .showMore(type: KeyBoardStatus.ShowStatus.emoji)
    }
    
    @IBAction func serviceClick(_ sender: Any) {
        self.showStatus = .showMore(type: KeyBoardStatus.ShowStatus.service)
    }
    
}

extension ChatInputView : GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        self.textView_height.constant = height
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            print("发送消息 ====\(textView.text)")
            self.textView.text = ""
            self.textView.resignFirstResponder()
            return false
        }
        return true
    }
}
