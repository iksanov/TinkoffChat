//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by MacBookPro on 25/02/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    @IBOutlet weak var conversationListTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conversationListTV.dataSource = self
        conversationListTV.register(UINib(nibName: "ConversationCell", bundle: Bundle.main), forCellReuseIdentifier: "ConvCell")
        title = "Tinkoff Chat"
    }
    
    let convList = ConversationsList()
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return convList.onlineConversations.count
        case 1:
            return convList.historyConversations.count
        default:
            assert(false)
            return Int()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {  // TODO: type of table (plain/grouped)
        switch section {
        case 0:
            return "Online"
        case 1:
            return "History"
        default:
            assert(false)
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConvCell", for: indexPath)
        let convCell = cell as! ConversationCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        convCell.dateLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        switch indexPath.section {  // TODO: remove duplicated code
        case 0:
            guard let name = convList.onlineConversations[indexPath.row].name else { assert(false) }
            convCell.nameLabel.text = name
            
            if let message = convList.onlineConversations[indexPath.row].message {
                if convList.onlineConversations[indexPath.row].hasUnreadMessages {
                    convCell.messageLabel.font = UIFont.boldSystemFont(ofSize: convCell.messageLabel.font.pointSize)
                } else {
                    convCell.messageLabel.font = UIFont.preferredFont(forTextStyle: .body)
                }
                convCell.messageLabel.text = message
            } else {
                convCell.messageLabel.font = UIFont.italicSystemFont(ofSize: convCell.messageLabel.font.pointSize)
                convCell.messageLabel.text = "No messages yet"
            }
            
            guard let date = convList.onlineConversations[indexPath.row].date else { assert(false) }
            convCell.dateLabel.text = dateFormatter.string(from: date)
            
            if convList.onlineConversations[indexPath.row].online {
                convCell.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.9058823529, blue: 0.3176470588, alpha: 0.5471693065)
            } else {
                convCell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            
        case 1:
            guard let name = convList.historyConversations[indexPath.row].name else { assert(false) }
            convCell.nameLabel.text = name
            
            guard let message = convList.historyConversations[indexPath.row].message else { assert(false) }
            convCell.messageLabel.text = message
            convCell.messageLabel.font = UIFont.preferredFont(forTextStyle: .body)
            
            guard let date = convList.historyConversations[indexPath.row].date else { assert(false) }
            convCell.dateLabel.text = dateFormatter.string(from: date)
            
            if convList.historyConversations[indexPath.row].hasUnreadMessages {
                convCell.messageLabel.font = UIFont.boldSystemFont(ofSize: convCell.messageLabel.font.pointSize)
            } else {
                convCell.messageLabel.font = UIFont.preferredFont(forTextStyle: .body)
            }
            
            if convList.historyConversations[indexPath.row].online {
                convCell.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.9058823529, blue: 0.3176470588, alpha: 0.5471693065)
            } else {
                convCell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        default:
            assert(false)
        }
        return convCell
    }
}
