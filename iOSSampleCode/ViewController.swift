//
//  ViewController.swift
//  UseWebAPISample
//
//  Created by 先生 on 2020/12/10.
//

import UIKit
// Codableの継承を忘れないこと！
struct User: Codable {
    let id: String
    let name: String
    let remarks: String
}

class ViewController: UIViewController {

    // 表示先ラベル
    @IBOutlet weak var resultDispLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // HTTPリクエストで受け取ったJSONから作成したユーザ情報の一時保存場所
    var uesrs_info:String="";

    // 画面上のボタンをクリックしたときの操作
    @IBAction func clickRequestWebAPI(_ sender: UIButton) {
        // 接続先のURL文字列
        let urlString = "http://172.16.13.21/khanh/sample/sample.php"

        // アクセスしたい先のURL情報をURL文字列から作成する
        // urlはNSURL型
        guard let url = URLComponents(string: urlString) else { return }

        // HTTPメソッドを実行するタスクを作成（画面描画や操作とは別のスレッドで動く）
        let task = URLSession.shared.dataTask(with: url.url!)
        {
            (data, response, error) in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            guard let _data = data else { return }

            // JSONデコード
            let users:[User] = try! JSONDecoder().decode([User].self, from: _data)
            // ユーザーデータを１人分ずつ取り出していく
            for row in users {
                self.uesrs_info += "id:\(row.id) name:\(row.name) remarks:\(row.remarks)¥n"
            }
            // 画面描画の更新（画面描画用のスレッド(mainスレッド)上で動かす必要がある）
            DispatchQueue.main.sync {
                self.resultDispLabel.text = self.uesrs_info
            }
            
        }
        // 作成したタスクを実行
        task.resume()
    }
    
    // POSTのサンプル
    @IBAction func clickPostRequestWebAPI(_ sender: UIButton) {
        // 接続先のURL文字列
        let urlString = "http://172.16.13.21/khanh/sample/postsample.php"

        // アクセスしたい先のURL情報をURL文字列から作成する
        // urlはNSURL型
        guard let url = URLComponents(string: urlString) else { return }
        // POSTリクエストを作成する
        var request = URLRequest(url: url.url!)
        request.httpMethod = "POST"

        let id = "iOStest"
        let name = "abc"
        let lang = "日本語"
        
        // サーバーに送信するリクエストへ、入れておくデータを文字列で作る
        let bodyString : String = "id=\(id)"
            + "&" + "name=\(name)"
            + "&" + "language=\(lang)"
        // 作ったデータをリクエストの中に入れられる形式に変換
        let bodyData : Data = bodyString.data(using: .utf8)!
        // POSTするデータをBodyとして設定
        request.httpBody = bodyData
        // HTTPメソッドを実行するタスクを作成（画面描画や操作とは別のスレッドで動く）
        let task = URLSession.shared.dataTask(with: request)
        {
            (data, response, error) in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            guard let _data = data else { return }

            // 画面描画の更新（画面描画用のスレッド(mainスレッド)上で動かす必要がある）
            DispatchQueue.main.sync {
                self.resultDispLabel.text = String(data: _data, encoding: .utf8)
            }
            
        }
        // 作成したタスクを実行
        task.resume()

    }
    
}

