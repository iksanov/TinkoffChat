//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by MacBookPro on 28/02/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import UIKit
import CoreData

class ChatViewController: UIViewController {
    
    @IBOutlet weak var messagesTV: UITableView!
    @IBOutlet var inputTextView: UITextView!
    @IBOutlet var sendButton: UIButton!
    
    lazy var request: NSFetchRequest<MessageTmp> = {
        let returnRequest: NSFetchRequest<MessageTmp> = MessageTmp.fetchRequest()
        returnRequest.predicate = NSPredicate(format: "conversation.user.name == %@", userID)
        returnRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return returnRequest
    }()
    
    lazy var frc: NSFetchedResultsController<MessageTmp> = NSFetchedResultsController(
        fetchRequest: request,
        managedObjectContext: StorageManager.sharedCoreDataStack.mainContext,  // TODO: choose right context
        sectionNameKeyPath: nil,
        cacheName: nil
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = userID
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
        
        frc.delegate = self
        try! frc.performFetch()
        messagesTV.reloadData()
    }
    
    @IBAction func sendMessageAction(_ sender: Any) {
        MultipeerCommunicator.shared.sendMessage(string: inputTextView.text, to: userID, completionHandler: nil)
        inputTextView.text = ""
    }
    
////    let messagesList = MessagesList()
////    lazy var messages = messagesList.messages
//    var messages: [Message] {
//        if let viewControllers = navigationController?.viewControllers,
//            let convListVC = viewControllers[viewControllers.count - 2] as? ConversationsListViewController,
//            let conv = convListVC.conversations[userID],
//            let messages = conv.messages {
//            return messages
//        } else {
//            return [Message]()
//        }
//    }
    
    var userID = "username_here"
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
}

// TODO: not to copy/paste code from ConversationListVC
extension ChatViewController: UITableViewDataSource {

//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messages.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let message = messages[indexPath.row]
//        let messageCellIdentifier = message.isIncoming ? "InMessageCell" : "OutMessageCell"
//        let cell = tableView.dequeueReusableCell(withIdentifier: messageCellIdentifier, for: indexPath)
//        let messageCell = cell as! MessageCell
//        messageCell.configureCell(from: message)
//        return messageCell
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = frc.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        return sections[section].name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = frc.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = frc.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = frc.object(at: indexPath)
        let messageCellIdentifier = message.isIncoming ? "InMessageCell" : "OutMessageCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: messageCellIdentifier, for: indexPath)
        let messageCell = cell as! MessageCell
        messageCell.configureCell(from: message)
        return messageCell
    }
}

// TODO: not to copy/paste code from ConversationListVC
extension ChatViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        messagesTV.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert: messagesTV.insertSections([sectionIndex], with: .automatic)
        case .delete: messagesTV.deleteSections([sectionIndex], with: .automatic)
        default: break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            messagesTV.insertRows(at: [newIndexPath!], with: .automatic)
        case .move:
            messagesTV.deleteRows(at: [indexPath!], with: .automatic)
            messagesTV.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            messagesTV.reloadRows(at: [indexPath!], with: .automatic)
        case .delete:
            messagesTV.deleteRows(at: [indexPath!], with: .automatic)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        messagesTV.endUpdates()
    }
}
