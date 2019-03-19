//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by MacBookPro on 25/02/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController, CommunicationManagerDelegate {
    
    @IBOutlet weak var conversationsListTV: UITableView!
    
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
            navigationController?.loadView()
        }
        
        communicator.delegate = communicationManager
        communicator.advertiser.delegate = communicationManager
        communicator.browser.delegate = communicationManager
        communicationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        profileButton.tintColor = UIBarButtonItem.appearance().tintColor
    }
    
    var conversations = [Conversation].init(Conversation.listOfConversations)
    
    var onlineConversations: [Conversation] {
        return conversations.filter({ $0.online }).sorted { $0.date! > $1.date! }
    }
    
    var historyConversations: [Conversation] {
        return conversations.filter({ $0.messages != nil && !$0.online }).sorted { $0.date! > $1.date! }
    }
    
    let communicator = MultipeerCommunicator()
    let communicationManager = CommunicationManager()
    
    @IBOutlet var profileButton: UIBarButtonItem!
    
    @IBAction func openProfile(_ sender: Any) {  // present VC from code (instead of creating segue)
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let profileVC = storyBoard.instantiateViewController(withIdentifier: "ProfileVC (inside NavigationVC)")
        present(profileVC, animated: true, completion: nil)
    }
    
    private func conversationAt(_ indexPath: IndexPath) -> Conversation? {
        switch indexPath.section {
        case 0:
            return onlineConversations[indexPath.row]
        case 1:
            return historyConversations[indexPath.row]
        default:
            return nil
        }
        
    }
    
    func logThemeChanging(selectedTheme: UIColor) {
        print("Selected theme is \(selectedTheme).")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "OpenConversation":
            if let conversation = sender as? Conversation {
                segue.destination.title = conversation.name
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
}

extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let conversation = conversationAt(indexPath) else { assert(false); return }
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
