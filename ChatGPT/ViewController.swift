//
//  ViewController.swift
//  ChatGPT
//
//  Created by Ray on 2023/3/14.
//

import RxCocoa
import RxSwift
import Moya
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var inputViewF: ChatInputView!
    @IBOutlet weak var inputViewF_bottom: NSLayoutConstraint!
    var viewModel: ChatListViewModel = .init()
    var provider = MoyaProvider<NetWork>()
    var dataArray: [MessageBodyModel] = []
    var disposeBag = DisposeBag.init()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        NetWork.sendMsg(text: "")
        inputViewF.sendCall = {
            [weak self] text in
            if let msg = text, !msg.isEmpty {
                self?.viewModel.sendMsg(msg: msg)
            }
            
            
        }
        tableView.register(UINib.init(nibName: "ChatListItemCell", bundle: nil), forCellReuseIdentifier: "ChatListItemCell")
        

        viewModel.dataArray.bind(to: self.tableView.rx.items(cellIdentifier: "ChatListItemCell", cellType: ChatListItemCell.self)){
            (indx, model, cell) in
            cell.model = model
            
        }.disposed(by: disposeBag)
        
        self.tableView.rx.modelSelected(MessageBodyModel.self).subscribe { event in
            print("=== \(event.element)")
        }.disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected.subscribe { event in
            print("=== \(event.element)")
        }.disposed(by: disposeBag)
    }


}



