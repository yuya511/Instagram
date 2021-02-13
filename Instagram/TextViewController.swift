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
        if textField.text!.isEmpty {
            return
        } else {
            //更新データを作成する
            var updateValue: FieldValue
            let name = Auth.auth().currentUser?.displayName
            updateValue = FieldValue.arrayUnion(["\(name!):\(textField.text!)"])
            //likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(row.id)
            postRef.updateData(["text": updateValue])
            
            print("DEBUG_PRINT: コメントを追加しました")
            SVProgressHUD.showSuccess(withStatus: "コメントを追加しました")
            
            self.dismiss(animated: true, completion: nil)
        }
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
