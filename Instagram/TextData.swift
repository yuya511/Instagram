//
//  TextData.swift
//  Instagram
//
//  Created by 山本優也 on 2021/02/12.
//

import Foundation
import Firebase

class TextData: NSObject {
    //投稿ID
    var id: String
    //投稿者名
    var name: String?
    //コメントの追加
    var text: String?
    //日付
    var date: Date?
    
    init(document: QueryDocumentSnapshot) {
        //documentIDプロパティがユニークなIDとして作られた投稿ID
        self.id = document.documentID
        //data()メソッドで辞書形式のデータを取り出すことができる
        let textDic = document.data()
        
        //↓辞書形式で取り出している
        self.name = textDic["name"] as? String
        self.text = textDic["text"] as? String
        let timestamp = textDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        
    }
}

