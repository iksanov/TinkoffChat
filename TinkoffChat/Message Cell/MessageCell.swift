//
//  MessageCell.swift
//  TinkoffChat
//
//  Created by MacBookPro on 28/02/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell, MessageCellConfiguration {  // TODO: regulate cell's height
    
    var textOfMessage: String? = nil

    @IBOutlet weak var messageLabel: UILabel!
    
    func configureCell(from message: Message) {  // TODO: realign for a single line message
        self.textOfMessage = message.textOfMessage
        messageLabel.text = self.textOfMessage
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 30  // TODO: add internal background view instead
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
