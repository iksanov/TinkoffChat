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
        // TODO: think about unfaulting, batchSize and other optimizations
        // TODO: in another FRC too
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
    
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = titleLabel
        titleLabel.text = userID
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        colorizeTitle()
        
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
    
    var userID = "username_here"
    var userIsOnline = true {
        didSet {
            if userIsOnline {
                enableSendButton()
                colorizeTitle()
            } else {
                disableSendButton()
                decolorizeTitle()
            }
        }
    }
    
    private func enableSendButton() {
        DispatchQueue.main.async {
            self.sendButton.isEnabled = true
            self.changeSendButtonWithAnimation(to: #colorLiteral(red: 0, green: 0.9776198268, blue: 0.2574992478, alpha: 1))
        }
    }
    
    private func disableSendButton() {
        DispatchQueue.main.async {
            self.sendButton.isEnabled = false
            self.changeSendButtonWithAnimation(to: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        }
    }
    
    private func changeSendButtonWithAnimation(to color: UIColor) {
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.sendButton.backgroundColor = color
                        self.sendButton.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        }, completion: { completed in
            UIView.animate(withDuration: 0.5,
                           animations: {
                            self.sendButton.transform = .identity
            }, completion: nil)
        })
    }
    
    private func changeTitleWithAnimation(to color: UIColor, withfontSizeScaledBy scale: CGFloat) {
        UIView.transition(with: self.titleLabel,
                          duration: 1.0,
                          options: [.transitionCrossDissolve],
                          animations: {
                            self.titleLabel.textColor = color
                            if scale != 1.0 {
                                self.titleLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
                            } else {
                                self.titleLabel.transform = .identity
                            }
                            
        }, completion: nil)
    }
    
    private func colorizeTitle() {
        DispatchQueue.main.async {
            self.changeTitleWithAnimation(to: #colorLiteral(red: 0.2509849133, green: 0.863148441, blue: 0.1686274558, alpha: 1), withfontSizeScaledBy: 1.1)
        }
    }
    
    private func decolorizeTitle() {
        DispatchQueue.main.async {
            self.changeTitleWithAnimation(to: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), withfontSizeScaledBy: 1.0)
        }
    }
    
    
}

// TODO: not to copy/paste code from ConversationListVC
extension ChatViewController: UITableViewDataSource {
    
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
