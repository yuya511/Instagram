//
//  PostData.swift
//  Instagram
//
//  Created by 山本優也 on 2021/02/09.
//

import UIKit
import Firebase

class PostData: NSObject {
    var id: String
    var name: String?
    var caption: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        
        let postDic = document.data()
        
        self.name = postDic["name"] as? String
        
        self.caption = postDic["caption"] as? String
        
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        
        if let likes = postDic["likes"] as? [String] {
            self.likes = likes
        }
        if let myid = Auth.auth().currentUser?.uid {
            //likesの配列のなかにmyidが含まれていないかチェックすることで、自分がいいねしているか判断
            if self.likes.firstIndex(of: myid) != nil {
                //myidがあれば、いいねを押していると判断
                self.isLiked = true
            }
        }
    }
}
