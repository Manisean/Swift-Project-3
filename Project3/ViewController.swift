//
//  ViewController.swift
//  Project3
//
//  Created by Mark Hunnewell on 4/27/24.
//

import Alamofire
import Foundation
import UIKit

let chitKey =  "f9e622f8-d6a6-43de-bee9-ae5bc0e4420f"
let chitClient = "mark.hunnewell@mymail.champlain.edu"

struct ChitChatResponse : Codable {
    var count: Int
    var date: String
    var messages: [ChatMessages] = []
    
    struct ChatMessages : Codable {
        var id: String
        var client: String
        var date: String
        var dislikes: Int
        var ip: String
        var likes: Int
        var loc: [String?]
        var message: String
        
        enum CodingKeys : String, CodingKey {
            case id = "_id"
            case client = "client"
            case date = "date"
            case dislikes = "dislikes"
            case ip = "ip"
            case likes = "likes"
            case loc = "loc"
            case message = "message"
        }
    }
}

class CustomCell: UITableViewCell {
    @IBOutlet weak var chitChatLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dislikeLabel: UILabel!
    @IBOutlet weak var clientLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var idLable: UILabel!
    
    @IBAction func likeBtn(_ sender: UIButton) {
        getLike()
    }
    
    @IBAction func dislikeBtn(_ sender: UIButton) {
        getDislike()
    }
    
    func getLike() {
        let parameters = ["key": chitKey, "client": chitClient]
        let url = "https://www.stepoutnyc.com/chitchat/like/\(idLable.text!)"
        
        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: ChitChatResponse.self) {_ in }
    }
    
    func getDislike() {
        let parameters = ["key": chitKey, "client": chitClient]
        let url = "https://www.stepoutnyc.com/chitchat/dislike/\(idLable.text!)"
        
        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: ChitChatResponse.self) {_ in }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var msgs: [ChitChatResponse.ChatMessages] = []
    var ret = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getChat(chitKey: chitKey, chitClient: chitClient) { result in
            self.ret = result.count
            
            for m in result.messages {
                self.msgs.append(m)
            }
            
            self.tableView.reloadData()
        }
    }
    
    func getChat(chitKey: String, chitClient: String, completion: @escaping (ChitChatResponse) -> Void) {
        let parameters = ["key": chitKey, "client": chitClient]
        
        AF.request("https://www.stepoutnyc.com/chitchat", method: .get, parameters: parameters).responseDecodable(of: ChitChatResponse.self) { response in
            
            //print(response)
            switch response.result {
            case .success(let chitChat):
                completion(chitChat)
            case .failure(_):
                print("error1")
            }
        }
    }
    
    @IBAction func newPost(_ sender: UIButton) {
        let postView = storyboard?.instantiateViewController(withIdentifier: "PostVC") as! PostViewController
        
        postView.chitKey = chitKey
        postView.chitClient = chitClient
        
        present(postView, animated: true)
    }
    
    @IBAction func refreshBtn(_ sender: UIButton) {
        reloadTable()
    }
    
    func reloadTable() {
        getChat(chitKey: chitKey, chitClient: chitClient) { result in
            self.ret = result.count
            self.msgs = []
            
            for m in result.messages {
                self.msgs.append(m)
            }
            
            //print(self.msgs)
            self.tableView.reloadData()
        }
    }
    
    
}


//MARK: TABLE VIEW DATA SOURCE
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return ret
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChitChat", for: indexPath) as! CustomCell
        
        cell.chitChatLabel.text = msgs[indexPath.row].message
        cell.dislikeLabel.text = String(msgs[indexPath.row].dislikes)
        cell.likeLabel.text = String(msgs[indexPath.row].likes)
        cell.clientLabel.text = msgs[indexPath.row].client
        cell.timeLabel.text = msgs[indexPath.row].date
        cell.idLable.text = msgs[indexPath.row].id
        
        return cell
    }
}

//MARK: TABLE VIEW DELEGATE
extension ViewController: UITableViewDelegate {
    
}


