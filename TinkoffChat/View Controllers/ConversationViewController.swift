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
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        let messageCellIdentifier = message.ifIncoming ? "in"
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        let convCell = cell as! ConversationCell  // TODO: try to downcast to the protocol instead
    }


}
