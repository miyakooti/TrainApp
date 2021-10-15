//
//  ViewController.swift
//  trainApp
//
//  Created by Arai Kousuke on 2021/10/10.
//

import UIKit
import Alamofire
import Kanna



// https://api.ekispert.jp/v1/json/search/course/light?key=LE_2McsphRXduecu&from=磯子&to=横浜
// 駅名検索のやつでプルダウンにして、そこから選択する形だったらいいね。

class ViewController: UIViewController {
    
    @IBOutlet weak var debugButton: UIButton!
    
    var departDate = ""

    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchTrainDataFromUrl
        debugButton.addTarget(self, action: #selector(debugButtonPressed(_:)), for: .touchUpInside)
    }
    
    @objc func debugButtonPressed(_ sender: UIButton) {
        
        let baseUrl = "https://api.ekispert.jp/v1/"
        let path = "json/search/course/light"
        let parameters = ["key": Secrets.accessKey, "from": "磯子", "to": "東京"]
        
        AF.request(baseUrl + path, method: .get, parameters: parameters, headers: [:])
            .validate()
            .responseJSON { response in
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
//                jsonDecoder.dateDecodingStrategy = .iso8601
                guard let data = response.data else { return }
                if response.error != nil {
                    print(response.error.debugDescription)
                } else {
                    do {
                        print("あ")
                        print(response)
                        print(data)
                        let result = try jsonDecoder.decode(TrainSearchResult.self, from: data)
                        print(result.ResultSet.ResourceURI)
                    } catch {
                        print("い")
                        print(error)
                    }
                    
//                    self.fetchTrainDataFromUrl()
                }
            }
        
        
    }
    
    func fetchTrainDataFromUrl() {
        
        let url = "https://roote.ekispert.net/ja/result?arr=%E6%A8%AA%E6%B5%9C&arr_code=23368&connect=true&day=12&dep=%E7%A3%AF%E5%AD%90&dep_code=23073&express=true&highway=true&hour=6&liner=true&local=true&locale=ja&minute10=4&minute1=9&plane=true&provider=&shinkansen=true&ship=true&sort=time&surcharge=3&ticket_type=0&transfer=2&type=dep&utf8=%E2%9C%93&via1=&via1_code=&via2=&via2_code=&yyyymm=202110"
        
        AF.request(url).responseString { response in

            switch response.result {
            case let .success(value):

                if let doc = try? HTML(html: value, encoding: .utf8) {
                    

                    for value in doc.xpath("//span[@class='dep_date']") {
                        print(value.text)
                    }
                    

                }
            case let .failure(error):
                print(error)
            }
        }
        
    }


}

