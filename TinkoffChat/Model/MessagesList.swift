//
//  MessagesList.swift
//  TinkoffChat
//
//  Created by MacBookPro on 01/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//
//
//import Foundation
//
//class MessagesList {
//    lazy var messages = getMessagesFromPlainText(MessagesList.plainText)
//
//    private func getMessagesFromPlainText(_ text: String) -> [Message] {
//        var listOfMessages = [Message]()
//        let listOfWords = text.split(separator: " ")
//
//        var startIndex = 0
//        var endIndex = 10
//        while endIndex < listOfWords.count {
//            let isIncoming = (Int.random(in: 0...1) == 0) ? false : true
//            let messageText = listOfWords[startIndex..<endIndex].joined(separator: " ")
//            listOfMessages.append(Message(text: messageText, isIncoming: isIncoming))
//            startIndex += 10
//            endIndex += 10
//        }
//        return listOfMessages
//    }
//}
//
//extension MessagesList {
//    static let plainText = "lorem dolor sed viverra ipsum nunc aliquet bibendum enim facilisis gravida neque convallis a cras semper auctor neque vitae tempus quam pellentesque nec nam aliquam sem et tortor consequat id porta nibh venenatis cras sed felis eget velit aliquet sagittis id consectetur purus ut faucibus pulvinar elementum integer enim neque volutpat ac tincidunt vitae semper quis lectus nulla at volutpat diam ut venenatis tellus in metus vulputate eu scelerisque felis imperdiet proin fermentum leo vel orci porta non pulvinar neque laoreet suspendisse interdum consectetur libero id faucibus nisl tincidunt eget nullam non nisi est sit amet facilisis magna etiam tempor orci eu lobortis elementum nibh tellus molestie nunc non blandit massa enim nec dui nunc mattis enim ut tellus elementum sagittis vitae et leo duis ut diam quam nulla porttitor massa id neque aliquam vestibulum morbi blandit cursus risus at ultrices mi tempus imperdiet nulla malesuada pellentesque elit eget gravida"
//}
