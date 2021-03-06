//
//  PostViewController.swift
//  Instagram
//
//  Created by 山本優也 on 2021/02/08.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {
    
    var image: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    //投稿ボタン
    @IBAction func handlePostButton(_ sender: Any) {
        //画像をJPEG形式に変換する
        let imageData = image.jpegData(compressionQuality: 0.75)
        
        //画像と投稿データの保存場所を定義する
        //Const.swiftで指定したPostPathをcollectionメソッドの引数に指定することで、Firestoreのpostsフォルダに新しい投稿データを
        //保存するように指定している
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        //Sorageに保存する画像の保存場所を定義している
        //Const.swiftで指定したImagePathをchildメソッドの引数に指定して、
        //どの投稿に対応する画像か結びつけるためにpostRefのdocumentIDを画像のファイル名に利用している
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
        
        //HUDで投稿処理中の表示を開始
        SVProgressHUD.show()
        
        //Storageに画像をアップロードする
        let metadata = StorageMetadata()
        //画像を保存する際のファイル形式→今回は、image/jpeg
        metadata.contentType = "image/jpeg"
        //アップロードのメソッド
        imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
            if error != nil {
                //画像をアップロード失敗
                print(error!)
                SVProgressHUD.showError(withStatus: "画像をアップロードが失敗しました")
                //投稿をキャンセルし、先頭画面に戻る
                //一気に先頭に戻るために必要なメソッド
                UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                return
            }
            
            //FireStoreに投稿データを保存する
            let name = Auth.auth().currentUser?.displayName
            let postDic = [
                "name": name!,
                "caption": self.textField.text!,
                "date": FieldValue.serverTimestamp(),//サバー上の時計を使用して日時を保存する指定
            ] as [String : Any]
            //辞書型の形にまとめてsetDataでFirestoreに保存できる
            postRef.setData(postDic)
            
            //HUDで投稿完了を表示する
            SVProgressHUD.showSuccess(withStatus: "投稿しました")
            
            //投稿処理が完了したので先頭画面に戻る 一気に先頭に戻る
            UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    //キャンセルボタン
    @IBAction func handleCancelButton(_ sender: Any) {
        //加工画面に戻る→一つ前に戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //受け取った画像をImageViewに設定する
        imageView.image = image
    }
    

}
