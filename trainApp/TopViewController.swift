//
//  ViewController.swift
//  trainApp
//
//  Created by Arai Kousuke on 2021/10/10.
//

import UIKit
import Alamofire
import Kanna

class TopViewController: UIViewController {
    
    @IBOutlet weak var debugButton: UIButton!
    
    var departDate: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        debugButton.addTarget(self, action: #selector(debugButtonPressed(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
            jsonDecoder.dateDecodingStrategy = .iso8601
            guard let data = response.data else { return }
            if response.error != nil {
                print(response.error.debugDescription)
            } else {
                do {
                    let result = try jsonDecoder.decode(TrainSearchResult.self, from: data)
                    guard let resourceURI = result.ResultSet.ResourceURI else { return }
                    print(resourceURI)
                    self.fetchTrainDataFromUrl(resourceURI)
                } catch {
                    print(error)
                }
            }
        }
        
        
    }
    
    func fetchTrainDataFromUrl(_ url: String) {
                
        print("url", url)
        AF.request(url).responseString { response in

            switch response.result {
            case let .success(value):

                if let doc = try? HTML(html: value, encoding: .utf8) {
                    
//                    for value in doc.xpath("//p[@class='candidate_list_txt']") {
//                        print(value[0].)
//                    }
                    print(doc.xpath("//p[@class='candidate_list_txt']").first?.text)
                    self.departDate = String(doc.xpath("//p[@class='candidate_list_txt']").first?.text?.prefix(5) ?? "")
                    print(self.departDate)
                    

                }
            case let .failure(error):
                print(error)
            }
        }
        
    }


}

