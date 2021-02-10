//
//  HomeViewController.swift
//  Instagram
//
//  Created by 山本優也 on 2021/02/08.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    //投稿データを格納する配列
    var postArray: [PostData] = []
    
    //Firestoreのリスナー
    var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        //カスタムセルを登録する
        //UINibでxibファイルを読み込む
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        //registerメソッドでxibファイルを登録する
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        //ログイン済みか確認
        if Auth.auth().currentUser != nil {
            // listenerを登録して投稿データの更新を監視する
            let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
            listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。\(error)")
                    return
                }
                //取得したdocumentを元にPostDateを作成し、postArrayの配列にする。
                self.postArray = querySnapshot!.documents.map { document in
                    print("DEBUG_PRINT: document取得　\(document.documentID)")
                    let postData = PostData(document: document)
                    return postData
                }
                //TableViewの表示を更新する
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DEBUG_PRINT: viewWillDisappear")
        //listenerを削除して監視を停止する
        listener?.remove()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        
        return cell
    }
}
