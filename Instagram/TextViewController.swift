//
//  TextViewController.swift
//  Instagram
//
//  Created by 山本優也 on 2021/02/12.
//

import UIKit
import Firebase
import SVProgressHUD

class TextViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    var row:PostData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func textButton(_ sender: Any) {
        
//        let textRef = Firestore.firestore().collection(Const.TextPath).document()
//
//        let name = Auth.auth().currentUser?.displayName
//        let TextDic = [
//            "name": name!,
//            "text": self.textField.text!,
//            "date": FieldValue.serverTimestamp(),//サバー上の時計を使用して日時を保存する指定
//        ] as [String : Any]
//        //辞書型の形にまとめてsetDataでFirestoreに保存できる
//        textRef.setData(TextDic)
//
        //更新データを作成する
        var updateValue: FieldValue
        let name = Auth.auth().currentUser?.displayName
        updateValue = FieldValue.arrayUnion(["\(name!):\(textField.text!)"])
        //likesに更新データを書き込む
        let postRef = Firestore.firestore().collection(Const.PostPath).document(row.id)
        postRef.updateData(["text": updateValue])
        
        //コメントのデータを渡す
        let HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        HomeViewController.texts = textField.text!
        print("DEBUG_PRINT: コメントを追加しました")
        SVProgressHUD.showSuccess(withStatus: "コメントを追加しました")
        
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
