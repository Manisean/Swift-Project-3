//
//  PostViewController.swift
//  Project3
//
//  Created by Mark Hunnewell on 5/2/24.
//

import Foundation
import UIKit
import Alamofire

class PostViewController: UIViewController {
    
    var chitKey: String?
    var chitClient: String?
    
    @IBOutlet weak var postText: UITextField!
    @IBOutlet weak var clientLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        
        clientLabel.text = chitClient
        
        dateMaker()
        
    }
    
    @IBAction func postMsg(_ sender: UIButton) {
        let parameters = ["key": chitKey!, "client": chitClient!, "message": postText.text ?? ""]
        
        AF.request("https://www.stepoutnyc.com/chitchat", method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder(destination: .httpBody)).responseDecodable(of: ChitChatResponse.self) { _ in }
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    func dateMaker() {
        let date = Date()
        let day = date.formatted(Date.FormatStyle().weekday())
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd MMM YY HH:mm:ss"
        let dateString = dateFormat.string(from: date)
        let dates = "\(day), \(dateString) GMT"
        
        dateLabel.text = dates
    }
    
}
