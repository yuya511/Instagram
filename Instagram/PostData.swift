//
//  PostData.swift
//  Instagram
//
//  Created by 山本優也 on 2021/02/09.
//

import UIKit
import Firebase

//NSObjectはクラスとして最低限備えたクラス
class PostData: NSObject {
    //投稿ID
    var id: String
    //投稿者名
    var name: String?
    //キャプション
    var caption: String?
    //日付
    var date: Date?
    //いいねをした人のIDの配列
    var likes: [String] = []
    //自分がいいねしているかのフラグ
    var isLiked: Bool = false
    
    //イニシャライザで初期値を設定
    //Firebaseからデータを取得すると「QueryDocumentSnapshot」クラスのデータが渡されてきます
    init(document: QueryDocumentSnapshot) {
        //documentIDプロパティがユニークなIDとして作られた投稿ID
        self.id = document.documentID
        //data()メソッドで辞書形式のデータを取り出すことができる
        let postDic = document.data()
        //↓辞書形式で取り出している
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
