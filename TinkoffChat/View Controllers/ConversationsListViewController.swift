//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by MacBookPro on 25/02/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import CoreData

class ConversationsListViewController: UIViewController {
    
    @IBOutlet weak var conversationsListTV: UITableView!
    
    let request: NSFetchRequest<ConversationTmp> = {
        let returnRequest: NSFetchRequest<ConversationTmp> = ConversationTmp.fetchRequest()
        returnRequest.sortDescriptors = [NSSortDescriptor(key: "user.online", ascending: false), NSSortDescriptor(key: "lastMessageDate", ascending: false)]
        return returnRequest
    }()
    
    lazy var frc: NSFetchedResultsController<ConversationTmp> = NSFetchedResultsController(
        fetchRequest: request,
        managedObjectContext: StorageManager.sharedCoreDataStack.mainContext,  // TODO: choose right context
        sectionNameKeyPath: nil,  // TODO: replace it with online in the future
        cacheName: nil
    )
    
//    let testStorageManager = StorageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conversationsListTV.dataSource = self
        conversationsListTV.delegate = self
        conversationsListTV.register(UINib(nibName: "ConversationCell", bundle: Bundle.main), forCellReuseIdentifier: "ConvCell")
        conversationsListTV.rowHeight = UITableView.automaticDimension
        conversationsListTV.estimatedRowHeight = 88
        title = "Tinkoff Chat"
        
        if let themeNameRawValue: ThemeName.RawValue = UserDefaults.standard.value(forKey: "appTheme") as? ThemeName.RawValue,
            let themeName = ThemeName(rawValue: themeNameRawValue) {
            ThemeManager.setTheme(withName: themeName)
            navigationController?.loadView()  // TODO: don't do like this
        }
        
        MultipeerCommunicator.shared.delegate = self
        
        
//        let testUser = NSEntityDescription.insertNewObject(forEntityName: "UserTmp", into: StorageManager.sharedCoreDataStack.mainContext) as? UserTmp
//        testUser?.name = "name of test User"
//        testUser?.online = true
//
//        let testMessage = NSEntityDescription.insertNewObject(forEntityName: "MessageTmp", into: StorageManager.sharedCoreDataStack.mainContext) as? MessageTmp
//        testMessage?.date = Date(timeIntervalSinceNow: 0)
//        testMessage?.isIncoming = false
//        testMessage?.text = "text of test message"
//        testMessage?.unread = true
//
//        let testConv = NSEntityDescription.insertNewObject(forEntityName: "ConversationTmp", into: StorageManager.sharedCoreDataStack.mainContext) as? ConversationTmp
//        testConv?.lastMessageText = "text of the last test message"
//        testConv?.lastMessageDate = Date(timeIntervalSinceNow: 0)
//        testConv?.hasUnreadMessages = true
//        testConv?.user = testUser
//        if let message = testMessage {
//            testConv?.addToMessages(message)
//        }
//
//        CoreDataStack.performSave(with: StorageManager.sharedCoreDataStack.mainContext)
        
        frc.delegate = self
        try! frc.performFetch()
        conversationsListTV.reloadData()
    }
    
    
    // TODO: may be add refresh button that will delete all sessions and reconnect to everyone again
    // (that will solve the problem of unrelevant dialogs right after reopening app after background mode)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("_ viewWillAppear")
        profileButton.tintColor = UIBarButtonItem.appearance().tintColor
        updateViewFromModel()
    }
    
    var conversations = [String : Conversation]()
    
    var onlineConversations: [(key: String, value: Conversation)] {
        return conversations.filter({ $0.value.online }).sorted { $0.value.date! > $1.value.date! }
    }
    
    var historyConversations: [(key: String, value: Conversation)] {
        return conversations.filter({ $0.value.messages != nil && !$0.value.online }).sorted { $0.value.date! > $1.value.date! }
    }
    
    private func updateViewFromModel() {  // TODO: think about execution on the main thread
//        DispatchQueue.main.async {
//            self.conversationsListTV.reloadData()  // TODO: may be reload only speсific rows
//        }
    }
    
    private func updateChatViewFromModel() {
        if let chatVC = navigationController?.topViewController as? ChatViewController {
            chatVC.userIsOnline = MultipeerCommunicator.shared.checkIfUserAvaliable(userID: chatVC.userID)
            DispatchQueue.main.async {
                chatVC.messagesTV.reloadData()
            }
        }
    }
    
    @IBOutlet var profileButton: UIBarButtonItem!
    
    @IBAction func openProfile(_ sender: Any) {  // present VC from code (instead of creating segue)
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let profileVC = storyBoard.instantiateViewController(withIdentifier: "ProfileVC (inside NavigationVC)")
        present(profileVC, animated: true, completion: nil)
    }
    
//    private func conversationAt(_ indexPath: IndexPath) -> Conversation? {
//        switch indexPath.section {
//        case 0:
//            return onlineConversations[indexPath.row].value
//        case 1:
//            return historyConversations[indexPath.row].value
//        default:
//            return nil
//        }
//
//    }
    
    func logThemeChanging(selectedTheme: UIColor) {
        print("_ Selected theme is \(selectedTheme).")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "OpenConversation":
//            if let conversation = sender as? Conversation {
//                if let convVC = segue.destination as? ChatViewController {
//                    convVC.userID = conversation.name ?? "Unknown User"
//                }
//            }
            if let conversation = sender as? ConversationTmp {
                if let convVC = segue.destination as? ChatViewController, let userName = conversation.user?.name {
                    convVC.userID = userName
                }
            }
        case "OpenThemeChooser":
            if let navigationVC = segue.destination as? UINavigationController, let themesVC = navigationVC.topViewController as? ThemesViewController {
//                themesVC.delegate = self   // for obj-c ThemesViewController
                themesVC.closureForThemeSetting = { [weak self] (theme: UIColor) in self?.logThemeChanging(selectedTheme: theme) }  // for swift ThemesViewController
            }
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ConversationsListViewController: UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return onlineConversations.count
//        case 1:
//            return historyConversations.count
//        default:
//            assert(false)
//            return Int()
//        }
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0:
//            return "Online"
//        case 1:
//            return "History"
//        default:
//            assert(false)
//            return nil
//        }
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ConvCell", for: indexPath)
//        let convCell = cell as! ConversationCell
//
//        guard let conversation = conversationAt(indexPath) else { assert(false); return convCell }
//        convCell.configureCell(from: conversation)
//        return convCell
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConvCell", for: indexPath)
        let convCell = cell as! ConversationCell

        let conversation = frc.object(at: indexPath)

        convCell.configureCell(from: conversation)
        return convCell
    }
    
}

//extension ConversationsListViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let conversation = conversationAt(indexPath) else { assert(false); return }
//        performSegue(withIdentifier: "OpenConversation", sender: conversation)
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//}

extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversation = frc.object(at: indexPath)
        performSegue(withIdentifier: "OpenConversation", sender: conversation)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// uncomment if using obj-c ThemesVC
//extension ConversationsListViewController: ThemesViewControllerDelegate {
//    func themesViewController(_ controller: ThemesViewController, didSelectTheme selectedTheme: UIColor) {
//        logThemeChanging(selectedTheme: selectedTheme)
//    }
//}

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationsListTV.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                           didChange sectionInfo: NSFetchedResultsSectionInfo,
                           atSectionIndex sectionIndex: Int,
                           for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert: conversationsListTV.insertSections([sectionIndex], with: .automatic)
        case .delete: conversationsListTV.deleteSections([sectionIndex], with: .automatic)
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
            conversationsListTV.insertRows(at: [newIndexPath!], with: .automatic)
        case .move:
            conversationsListTV.deleteRows(at: [indexPath!], with: .automatic)
            conversationsListTV.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            conversationsListTV.reloadRows(at: [indexPath!], with: .automatic)
        case .delete:
            conversationsListTV.deleteRows(at: [indexPath!], with: .automatic)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationsListTV.endUpdates()
    }
}

extension ConversationsListViewController: CommunicatorDelegate {
    func didFoundUser(userID: String, userName: String?) {
        // TODO: make a separate method (add conversation to model)
        // TODO: remove hardcord
        conversations[userID] = Conversation(name: userID,
                                             messages: [Message(text: "Some text", isIncoming: true),
                                                        Message(text: "Another text", isIncoming: false)],
                                             date: Date(),
                                             online: true,
                                             hasUnreadMessages: false)
        updateViewFromModel()
        updateChatViewFromModel()
    }
    
    func didLostUser(userID: String) {
        conversations.removeValue(forKey: userID)
        updateViewFromModel()
        updateChatViewFromModel()
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    
    func failedToStartAdvertising(error: Error) {
        
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        let isIncoming: Bool
        let userName: String
        if toUser == MultipeerCommunicator.myDeviceName {
            isIncoming = true
            userName = fromUser
        } else if fromUser == MultipeerCommunicator.myDeviceName {
            isIncoming = false
            userName = toUser
        } else {
            assert(false, "_ receiving message error")
            return
        }
        let newMessage = Message(text: text, isIncoming: isIncoming)
        conversations[userName]?.messages?.append(newMessage)
        DispatchQueue.main.async {
            self.updateViewFromModel()
            self.updateChatViewFromModel()
        }
    }
}
