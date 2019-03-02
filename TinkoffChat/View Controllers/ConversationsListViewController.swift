//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by MacBookPro on 25/02/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    @IBOutlet weak var conversationsListTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conversationsListTV.dataSource = self
        conversationsListTV.delegate = self
        conversationsListTV.register(UINib(nibName: "ConversationCell", bundle: Bundle.main), forCellReuseIdentifier: "ConvCell")
        title = "Tinkoff Chat"
    }
    
    let convList = ConversationsList()
    
    // TODO: check how to create segue from code
    
    private func conversationAt(_ indexPath: IndexPath) -> ConversationPreview? {
        switch indexPath.section {
        case 0:
            return convList.onlineConversations[indexPath.row]
        case 1:
            return convList.historyConversations[indexPath.row]
        default:
            return nil
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenConversation", let conversation = sender as? ConversationPreview {
            segue.destination.title = conversation.name
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

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
        
        guard let conversation = conversationAt(indexPath) else { assert(false) }
        convCell.configureCell(from: conversation)
        return convCell
    }
}

extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let conversation = conversationAt(indexPath) else { assert(false) }
        performSegue(withIdentifier: "OpenConversation", sender: conversation)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
