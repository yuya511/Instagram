//
//  TabBarController.swift
//  Instagram
//
//  Created by 山本優也 on 2021/02/08.
//

import UIKit
import Firebase // Firebaseのインポート

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        //タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        //タブバーの背景色
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        //UITabBarControllerDelegateプロトコルのメソッドをこのクラスで処理する
        self.delegate = self
        
    }
    
    //タブバーのアイコンがタップされた時に呼ばれるdelegateメソッドを処理する。
    //タブ切り替えをしてよいかどうかを返すメソッドでfalseで切り替えない、trueで切り替える
    //第２引数に(viewControlle)に切り替え先のviewControllerインスタンスが入っている
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        //真ん中のカメラボタンが押されたかの判定
        //is演算子右辺に値、左辺に型を取り合っていればtrueを返す
        if viewController is ImageSelectViewController {
            //ストーリボードのImageSelectViewControllerを読み込む
            let ImageSelectViewController = storyboard!.instantiateViewController(withIdentifier: "ImageSelect")
            //presentメソッドでモーダル画面遷移を行う
            present(ImageSelectViewController, animated: true)
            //通常のタブの切替を許可しない
            return false
        } else {
            //その他のViewControllerは通常のタブ切り替えを実施
            return true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil {
            //ログインしていないときの処理
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
        }
    }
    


}
