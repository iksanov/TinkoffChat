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
        // TODO: remove lastMessageDate attribute and calculate it instead
        returnRequest.sortDescriptors = [NSSortDescriptor(key: "user.online", ascending: false), NSSortDescriptor(key: "lastMessageDate", ascending: false)]
        return returnRequest
    }()
    
    lazy var frc: NSFetchedResultsController<ConversationTmp> = NSFetchedResultsController(
        fetchRequest: request,
        managedObjectContext: StorageManager.sharedCoreDataStack.mainContext,  // TODO: choose right context
        sectionNameKeyPath: "user.online",  // TODO: replace 1/0 with online/history
        cacheName: nil
    )
    
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
//        updateViewFromModel()
    }
    
    var conversations = [String : Conversation]()
    
//    private func updateViewFromModel() {  // TODO: think about execution on the main thread
//        DispatchQueue.main.async {
//            self.conversationsListTV.reloadData()  // TODO: may be reload only speсific rows
//        }
//    }
    
    private func updateOnlineStatusOnChatView() {
        if let chatVC = navigationController?.topViewController as? ChatViewController {
            chatVC.userIsOnline = MultipeerCommunicator.shared.checkIfUserAvaliable(userID: chatVC.userID)
        }
    }
    
    @IBOutlet var profileButton: UIBarButtonItem!
    
    @IBAction func openProfile(_ sender: Any) {  // present VC from code (instead of creating segue)
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let profileVC = storyBoard.instantiateViewController(withIdentifier: "ProfileVC (inside NavigationVC)")
        present(profileVC, animated: true, completion: nil)
    }
    
    func logThemeChanging(selectedTheme: UIColor) {
        print("_ Selected theme is \(selectedTheme).")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "OpenConversation":
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
        // TODO: remove hardcode
        print("_ didFoundUser \(userID)")
        // TODO: may be wrap with .perform()
        if let user = UserTmp.findOrInsertUser(with: userID, in: StorageManager.sharedCoreDataStack.mainContext) {
            user.online = true
            _ = ConversationTmp.findOrInsertConversation(with: user, in: StorageManager.sharedCoreDataStack.mainContext)
        }
        // TODO: find out if FRC updates TV when some attribute of its relationship changes
        // if not: add isOnline attribute to ConversationTmp entity
//        updateViewFromModel()
        updateOnlineStatusOnChatView()
    }
    
    func didLostUser(userID: String) {
        print("_ didLostUser \(userID)")
        // TODO: may be remove duplicated code from previous method
        if let user = UserTmp.findUser(with: userID, in: StorageManager.sharedCoreDataStack.mainContext) {
            user.online = false
        }
//        updateViewFromModel()
        updateOnlineStatusOnChatView()
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
        let dateNow = Date(timeIntervalSinceNow: 0)
        if let user = UserTmp.findOrInsertUser(with: userName, in: StorageManager.sharedCoreDataStack.mainContext),
            let newMessage = MessageTmp.insertMessage(from: user,
                                                      with: text,
                                                      which: isIncoming,
                                                      at: dateNow,
                                                      in: StorageManager.sharedCoreDataStack.mainContext) {
            user.conversation?.addToMessages(newMessage)
            user.conversation?.lastMessageDate = dateNow
            user.conversation?.hasUnreadMessages = true  // TODO: update unread messages info
        }
        // TODO: it is unnecessary only because the attribute lastMessageDate is changed when a new nessage is received
//        self.updateViewFromModel()
    }
}
