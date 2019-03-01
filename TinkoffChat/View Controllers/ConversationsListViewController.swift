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
        let convCell = cell as! ConversationCell  // TODO: try to downcast to the protocol instead
        
        switch indexPath.section {  // TODO: remove duplicated code
        case 0:
            let conversation = convList.onlineConversations[indexPath.row]
            convCell.configureCell(from: conversation)
        case 1:
            let conversation = convList.historyConversations[indexPath.row]
            convCell.configureCell(from: conversation)
        default:
            assert(false)
        }
        return convCell
    }
}
