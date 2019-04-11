//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by MacBookPro on 28/02/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ChatViewController: UIViewController {
    
    @IBOutlet weak var messagesTV: UITableView!
    @IBOutlet var inputTextView: UITextView!
    @IBOutlet var sendButton: UIButton!
    
//    let messagesList = MessagesList()
//    lazy var messages = messagesList.messages
    var messages: [Message] {
        if let viewControllers = navigationController?.viewControllers,
            let convListVC = viewControllers[viewControllers.count - 2] as? ConversationsListViewController,
            let conv = convListVC.conversations[userId],
            let messages = conv.messages {
            return messages
        } else {
            return [Message]()
        }
    }
    
    var userId = "username_here"
    var userIsOnline = true {
        didSet {
            if userIsOnline {
                enableSendButton()
            } else {
                disableSendButton()
            }
        }
    }
    
    private func enableSendButton() {
        DispatchQueue.main.async {
            self.sendButton.isEnabled = true
            self.sendButton.backgroundColor = #colorLiteral(red: 0, green: 0.9776198268, blue: 0.2574992478, alpha: 1)
        }
    }
    
    private func disableSendButton() {
        DispatchQueue.main.async {
            self.sendButton.isEnabled = false
            self.sendButton.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = userId
        messagesTV.dataSource = self
        messagesTV.register(UINib(nibName: "InMessageCell", bundle: Bundle.main), forCellReuseIdentifier: "InMessageCell")
        messagesTV.register(UINib(nibName: "OutMessageCell", bundle: Bundle.main), forCellReuseIdentifier: "OutMessageCell")
        messagesTV.allowsSelection = false
        messagesTV.rowHeight = UITableView.automaticDimension
        messagesTV.estimatedRowHeight = 150
        messagesTV.separatorStyle = .none
        // TODO: add spacing between cells
        
        inputTextView.layer.cornerRadius = 11.0
        inputTextView.layer.borderWidth = 1.0  // TODO: make it dependent on the textView height
        inputTextView.layer.borderColor = UIColor.gray.cgColor
        
        sendButton.layer.cornerRadius = 4.0  // TODO: move to static constants struct
        sendButton.adjustsImageWhenDisabled = true
    }
    
    @IBAction func sendMessageAction(_ sender: Any) {
        MultipeerCommunicator.shared.sendMessage(string: inputTextView.text, to: userId, completionHandler: nil)
        inputTextView.text = ""
    }
}

extension ChatViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let messageCellIdentifier = message.isIncoming ? "InMessageCell" : "OutMessageCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: messageCellIdentifier, for: indexPath)
        let messageCell = cell as! MessageCell
        messageCell.configureCell(from: message)
        return messageCell
    }
}
