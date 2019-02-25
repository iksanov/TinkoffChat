//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by MacBookPro on 25/02/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var conversationListTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conversationListTV.dataSource = self
        conversationListTV.register(UINib(nibName: "ConversationCell", bundle: Bundle.main), forCellReuseIdentifier: "ConvCell")
        title = "Tinkoff Chat"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConvCell", for: indexPath)
        let convCell = cell as! ConversationCell
        convCell.textLabel?.text = "Cell №\(indexPath.row)"
        return convCell
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
