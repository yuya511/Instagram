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
        tableView.rowHeight = UITableView.automaticDimension
        
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
            //投稿データを読み込むために、まずデータベースの参照場所と取得順序を指定したクエリを作成する
            let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
            //addSnapshotListennerメソッドに指定したクロージャは投稿データが更新されたり、追加されたりするたびに呼ばれる
            listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。\(error)")
                    return
                }
                //取得したdocumentを元にPostDateを作成し、postArrayの配列にする。
                //querySnapshotに最新のデータが入っている
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
    
    //ホーム画面が閉じられる時に呼ばれるメソッド
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
        
        //セル内のボタンをアクションをソースコードで設定する
        //コードでアクションを設定
        cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)
        
        //コメントのアクションを設定
        cell.textButton.addTarget(self, action: #selector(texthandle(_:forEvent:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました")
        
        //タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        //配列からタップされたセルのインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        //likesを更新する
        if let myid = Auth.auth().currentUser?.uid {
            //更新データを作成する
            var updateValue: FieldValue
            if postData.isLiked {
                //すでにいいね_場合は、いいね解除のためmyidを取り除く更新データを作成
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                //今回新たにいいねを押した場合は、myidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            //likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes": updateValue])
        }
    }
    
    @objc func texthandle(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: コメント追加ボタンがタップされました")
        
        //タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        //配列からタップされたセルのインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        let TextViewController = self.storyboard?.instantiateViewController(withIdentifier: "Text") as! TextViewController
        TextViewController.row = postData
        self.present(TextViewController, animated: true, completion: nil)
    }
}
