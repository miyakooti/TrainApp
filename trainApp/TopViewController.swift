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
    @IBOutlet weak var leftTimeLabel: UILabel!
    @IBOutlet weak var departTimeLabel: UILabel!

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
                
        AF.request(url).responseString { [weak self] response in
            switch response.result {
            case let .success(value):
                if let doc = try? HTML(html: value, encoding: .utf8) {
                    let departTime = String(doc.xpath("//p[@class='candidate_list_txt']").first?.text?.prefix(5) ?? "")
                    DispatchQueue.main.async {
                        self?.handleTrainData(departTime: departTime)
                    }
                }
            case let .failure(error):
                print(error)
            }
        }
        
    }
    
    func handleTrainData(departTime: String) {
        print("handleTrainDataしてるよーん")
        departTimeLabel.text = "\(departTime)発"
        print(departTime)
        print(departTime.prefix(2))
        print(departTime.suffix(2))
        
        guard let trainHour = Int(departTime.prefix(2)) else {return}
        print("あああ")
        guard let trainMinute = Int(departTime.suffix(2)) else {return}

        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HH:mm", options: 0, locale: Locale(identifier: "ja_JP"))
        
        guard let nowHour = Int(dateFormatter.string(from: now).prefix(2)),
              let nowMinute = Int(dateFormatter.string(from: now).suffix(2)) else {return}
        
        let leftTime = (trainHour - nowHour) * 60 + trainMinute - nowMinute
        
        print(leftTime)
        
        leftTimeLabel.text = String(leftTime)
        
        

        

        
    }
    


}

