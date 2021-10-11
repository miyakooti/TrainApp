//
//  ViewController.swift
//  trainApp
//
//  Created by Arai Kousuke on 2021/10/10.
//

import UIKit
import Alamofire
import Kanna

class ViewController: UIViewController {
    
    var departDate = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTrainData()
    }
    
    func fetchTrainData() {
        
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

