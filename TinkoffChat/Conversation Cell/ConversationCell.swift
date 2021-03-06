//
//  ConversationCellView.swift
//  TinkoffChat
//
//  Created by MacBookPro on 25/02/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, ConversationCellConfiguration {  // TODO: properties can store nothing
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var name: String? = nil
    var message: String? = nil
    var date: Date? = nil
    var online: Bool = false
    var hasUnreadMessages: Bool = false
    
    func configureCell(from convPreview: ConversationTmp) {
        print("_ configureCell")
        self.name = convPreview.user?.name
        if let lastMessage = convPreview.messages?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]).last as? MessageTmp,
            let lastMessageText = lastMessage.text {
            self.message = lastMessageText
        }
        self.date = convPreview.lastMessageDate
        self.online = convPreview.user?.online ?? false
        self.hasUnreadMessages = convPreview.hasUnreadMessages

        drawCell()
    }
    
    private func drawCell() {
        nameLabel.text = name
        
        if let textOfMessage = message {
            if hasUnreadMessages {
                messageLabel.font = UIFont.boldSystemFont(ofSize: messageLabel.font.pointSize)
            } else {
                messageLabel.font = UIFont.preferredFont(forTextStyle: .body)
            }
            messageLabel.text = textOfMessage
        } else {
            messageLabel.font = UIFont.italicSystemFont(ofSize: messageLabel.font.pointSize)
            messageLabel.text = "No messages yet"
        }
        
        dateLabel.font = UIFont.preferredFont(forTextStyle: .body)
        let currentCalendar = Calendar.current
        let dateFormatter = DateFormatter()
        if let dateValue = date {
            let isToday = currentCalendar.isDateInToday(dateValue)
            if isToday {
                dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
            } else {
                dateFormatter.setLocalizedDateFormatFromTemplate("dd MMM")
            }
            dateLabel.text = dateFormatter.string(from: dateValue)
        } else {
            dateLabel.text = ""
        }
        
        backgroundColor = online ? #colorLiteral(red: 0.9882352941, green: 0.9058823529, blue: 0.3176470588, alpha: 0.5471693065) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
