//
//  ConversationCellView.swift
//  TinkoffChat
//
//  Created by MacBookPro on 25/02/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, ConversationCellConfiguration {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var name: String? = nil
    var message: String? = nil
    var date: Date? = nil
    var online: Bool = false
    var hasUnreadMessages: Bool = false
    
    func configureCell(from convPreview: ConversationPreview) {
        self.name = convPreview.name
        self.message = convPreview.message
        self.date = convPreview.date
        self.online = convPreview.online
        self.hasUnreadMessages = convPreview.hasUnreadMessages
        
        drawCell()
    }
    
    private func drawCell() {
        
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
