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

class ConversationsListViewController: UIViewController, CommunicationManagerDelegate {
    @IBOutlet weak var conversationsListTV: UITableView!
    
    let request: NSFetchRequest<ConversationTmp> = {
        let returnRequest: NSFetchRequest<ConversationTmp> = ConversationTmp.fetchRequest()
        returnRequest.sortDescriptors = [NSSortDescriptor(key: "user.online", ascending: false), NSSortDescriptor(key: "lastMessageDate", ascending: false)]
        return returnRequest
    }()
    
    lazy var frc: NSFetchedResultsController<ConversationTmp> = NSFetchedResultsController(fetchRequest: request,
                                              managedObjectContext: StorageManager.sharedCoreDataStack.mainContext,
                                              sectionNameKeyPath: nil,  // TODO: replace it with online in the future
                                              cacheName: nil)
    
    let testStorageManager = StorageManager()
    
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
        
        communicator.delegate = communicationManager
        communicator.advertiser.delegate = communicationManager
        communicator.browser.delegate = communicationManager
        communicationManager.delegate = self
        communicator.advertiser.startAdvertisingPeer()
        communicator.browser.startBrowsingForPeers()
        
        
        let testUser = NSEntityDescription.insertNewObject(forEntityName: "UserTmp", into: StorageManager.sharedCoreDataStack.mainContext) as? UserTmp
        testUser?.name = "name of test User"
        testUser?.online = true
        
        let testConv = NSEntityDescription.insertNewObject(forEntityName: "ConversationTmp", into: StorageManager.sharedCoreDataStack.mainContext) as? ConversationTmp
        testConv?.lastMessageText = "text of the last test message"
        testConv?.lastMessageDate = Date(timeIntervalSince1970: 0)
        testConv?.hasUnreadMessages = true
        testConv?.user = testUser
        
        CoreDataStack.performSave(with: StorageManager.sharedCoreDataStack.mainContext)
        
        
        frc.delegate = self
        //        if let performFetchResult = try? frc.performFetch() {
        //            print(performFetchResult)
        //        } else {
        //            assert(false)
        //        }
        print(try! frc.performFetch())
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
    
    var conversations = [MCPeerID : Conversation]()
    
    var onlineConversations: [(key: MCPeerID, value: Conversation)] {
        return conversations.filter({ $0.value.online }).sorted { $0.value.date! > $1.value.date! }
    }
    
    var historyConversations: [(key: MCPeerID, value: Conversation)] {
        return conversations.filter({ $0.value.messages != nil && !$0.value.online }).sorted { $0.value.date! > $1.value.date! }
    }
    
    func updateViewFromModel() {
        conversationsListTV.reloadData()  // TODO: may be reload only speсific rows
    }
    
    let communicator = MultipeerCommunicator()
    let communicationManager = CommunicationManager()
    
    let decoder = JSONDecoder()
    
    @IBOutlet var profileButton: UIBarButtonItem!
    
    @IBAction func openProfile(_ sender: Any) {  // present VC from code (instead of creating segue)
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let profileVC = storyBoard.instantiateViewController(withIdentifier: "ProfileVC (inside NavigationVC)")
        present(profileVC, animated: true, completion: nil)
    }
    
    private func conversationAt(_ indexPath: IndexPath) -> Conversation? {
        switch indexPath.section {
        case 0:
            return onlineConversations[indexPath.row].value
        case 1:
            return historyConversations[indexPath.row].value
        default:
            return nil
        }
        
    }
    
    func logThemeChanging(selectedTheme: UIColor) {
        print("_ Selected theme is \(selectedTheme).")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "OpenConversation":
            if let conversation = sender as? ConversationTmp {
                segue.destination.title = conversation.user?.name
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return onlineConversations.count
        case 1:
            return historyConversations.count
        default:
            assert(false)
            return Int()
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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

        guard let conversation = conversationAt(indexPath) else { assert(false); return convCell }
        convCell.configureCell(from: conversation)
        return convCell
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        guard let sections = frc.sections else {
//            fatalError("No sections in fetchedResultsController")
//        }
//        return sections[section].name
//    }
//
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        guard let sections = frc.sections else {
//            fatalError("No sections in fetchedResultsController")
//        }
//        return sections.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let sections = frc.sections else {
//            fatalError("No sections in fetchedResultsController")
//        }
//        let sectionInfo = sections[section]
//        return sectionInfo.numberOfObjects
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ConvCell", for: indexPath)
//        let convCell = cell as! ConversationCell
//
//        let conversation = frc.object(at: indexPath)
//
//        convCell.configureCell(from: conversation)
//        return convCell
//    }
    
}

extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let conversation = conversationAt(indexPath) else { assert(false); return }
        performSegue(withIdentifier: "OpenConversation", sender: conversation)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//extension ConversationsListViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let conversation = frc.object(at: indexPath)
//        performSegue(withIdentifier: "OpenConversation", sender: conversation)
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//}

// uncomment if using obj-c ThemesVC
//extension ConversationsListViewController: ThemesViewControllerDelegate {
//    func themesViewController(_ controller: ThemesViewController, didSelectTheme selectedTheme: UIColor) {
//        logThemeChanging(selectedTheme: selectedTheme)
//    }
//}

extension ConversationsListViewController: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("_ Session with peer \(peerID.displayName) changed state to \(state.rawValue)")
        print("_ peerID \(peerID.displayName) connection to session: \(session.connectedPeers.contains(peerID))")
        if state == MCSessionState.notConnected {
            (communicator.delegate! as! CommunicationManager).sessions.removeValue(forKey: peerID)
            print("_ deleted session with peerID \(peerID.displayName)")
            DispatchQueue.main.async { [weak self] in 
                self?.updateViewFromModel()
            }
        }
        if state == MCSessionState.connected {
            print("_ Session is connected")
            conversations[peerID] = Conversation(name: peerID.displayName,  // TODO: make a separate method
                messages: nil,
                date: Date(),  // TODO: replace for nil
                online: true,
                hasUnreadMessages: false)
            DispatchQueue.main.async { [weak self] in  // TODO: may be use .sync() instead
                self?.updateViewFromModel()
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("_ session didReceive data \(data)")
        
        let messageFromJSON = try! decoder.decode(MessageForJSON.self, from: data)
        conversations[peerID]?.messages?.append(Message(text: messageFromJSON.text,
                                                                  isIncoming: true))
        DispatchQueue.main.async { [weak self] in  // TODO: may be use .sync() instead
            self?.updateViewFromModel()
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("_ session didReceive stream: \(stream)")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("_ session didStartReceivingResourceWithName \(resourceName)")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("_ session didFinishReceivingResourceWithName \(resourceName)")
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
}

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
