//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by MacBookPro on 28/02/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var messagesTV: UITableView!
    
    let messagesList = MessagesList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTV.dataSource = self
        messagesTV.register(UINib(nibName: "InMessageCell", bundle: Bundle.main), forCellReuseIdentifier: "InMessageCell")
        messagesTV.register(UINib(nibName: "OutMessageCell", bundle: Bundle.main), forCellReuseIdentifier: "OutMessageCell")
        messagesTV.allowsSelection = false
        messagesTV.rowHeight = UITableView.automaticDimension
        messagesTV.estimatedRowHeight = 150
        messagesTV.separatorStyle = .none
        // TODO: add spacing between cells
    }
}

extension ConversationViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesList.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messagesList.messages[indexPath.row]
        let messageCellIdentifier = message.isIncoming ? "InMessageCell" : "OutMessageCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: messageCellIdentifier, for: indexPath)
        let messageCell = cell as! MessageCell
        messageCell.configureCell(from: message)
        return messageCell
    }
}
