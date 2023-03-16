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
    private var badgeBtn: UIButton = {
        let m = self
        print("self == \(self)")
        let btn = UIButton()
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(badgeBtnAction), for: .touchUpInside)
        return btn
    }()
    
    @objc func badgeBtnAction() {
        print("fff====")
       print("self == \(self)")
        
        let m: (ViewController) -> () -> ViewController = {
            item in
            let funf: () -> ViewController = {
                
                return item
            }
            return funf
        }
        
        let jj = m(self)()
        
        print("jj == \(jj)")
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        NetWork.sendMsg(text: "")
        inputViewF.sendCall = {
            [weak self] text in
            if let msg = text, !msg.isEmpty {
                let msgModel = MessageBodyModel.init()
                msgModel.content = msg
                self?.dataArray.append(msgModel)
                self?.tableView.reloadData()
                let messages = self?.dataArray ?? []
                if !messages.isEmpty {
                    self?.provider.request(.sendMsg(messages: messages)) { result in
                        switch result {
                        
                        case .success(let value):
                            let json = try? value.mapString()
                            
                            let model = ChatCompletion.init(respone: value)
                            let list = model?.choices ?? []
                            for item in list {
                                let msgB = item.mapTo()
                                self?.dataArray.append(msgB)
                            }
                            self?.tableView.reloadData()
                            print("dataArray === \(self?.dataArray)")
                            print("json === \(json)")
                            break
                        case .failure(let error):
                            break
                        }
                    }
                }
                
            }
            
            
        }
        
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "ChatListItemCell", bundle: nil), forCellReuseIdentifier: "ChatListItemCell")
        
//        <Sequence: Swift.Sequence, Cell: UICollectionViewCell, Source: ObservableType>
//        let jj = self.tableView.rx.items(cellIdentifier: "ChatListItemCell", cellType: ChatListItemCell.self)
//        viewModel.dataArray.bind(to: <#T##[MessageBodyModel]...##[MessageBodyModel]#>)
        
        
        
        
        self.view.addSubview(badgeBtn)
        badgeBtn.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(20)
            make.height.width.equalTo(100)
        }
        
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListItemCell", for: indexPath) as! ChatListItemCell
        cell.model = self.dataArray[indexPath.row]
        return cell
    }
    
    
}

import ObjectMapper

extension ObjectMapper.Mappable {
    init?(respone:Moya.Response, context: MapContext? = nil) {
        guard let json = try? respone.mapJSON() as? [String: Any] else {
            return nil
        }
        if let obj: Self = Mapper(context: context).map(JSON: json) {
            self = obj
        } else {
            return nil
        }
    }
}
