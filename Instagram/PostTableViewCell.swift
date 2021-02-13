//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 山本優也 on 2021/02/09.
//

import UIKit
import FirebaseUI

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var detaLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var textButton: UIButton!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //PostDataの内容をセルに表示
    func setPostData(_ postData: PostData) {
        //画像を表示
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray//ダウンロード中のぐるぐるプロパティ
        //Clooud Storageの画像の保存場所を指定
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        //sd_setImageで表示できる
        postImageView.sd_setImage(with: imageRef)
        
        //キャプションの表示
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        
        //日時の表示
        self.detaLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.detaLabel.text = dateString
        }
        
        //いいね数を表示
        //likesに配列で入っている
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        //いいねボタンの表示
        //isLikedがあるかどうかで画像を変更
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
    }
//    func setTextData(_ textData: TextData) {
//        //キャプションの表示
//        self.textlabel.text = "\(textData.name!) : \(textData.text!)"
//    }

}
