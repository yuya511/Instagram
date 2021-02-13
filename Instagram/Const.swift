//
//  Const.swift
//  Instagram
//
//  Created by 山本優也 on 2021/02/09.
//

import Foundation


//Firebase関連の定数を別ファイルにまとめている→管理しやすくするため
//構造体をの中で「static」とつけることで、インスタンス化しなくてもプロパティを取得できる
struct Const {
    //Storage内の画像ファイルの保存場所を定義
    static let ImagePath = "images"
    //Firestore内の投稿データ(投稿者名・キャプション・投稿日時)の保存場所を定義
    static let PostPath = "posts"
    //Firestore内の投稿データの保存場所
    static let TextPath = "texts"
}
