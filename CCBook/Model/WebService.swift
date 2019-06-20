//
//  WebService.swift
//  ubmAppleBookClone
//
//  Created by c.c on 2019/6/13.
//  Copyright © 2019 c.c. All rights reserved.
//

import Foundation

class WebService: NSObject {
    
    static var shared: WebService {
        return WebService()
    }
    
    func fetchData(completion: @escaping (Array<InfoReleaseDetailDtoOutput>) -> Void) {
        let api = "https://api.u-bm.com/PartSearch/GetDetailsByIrids?irids=5805&irids=5804&irids=5803&irids=5802&irids=5800&irids=5786&irids=5784"
        let url = URL.init(string: api)!
        
        var request = URLRequest.init(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) {
            (optData, response, error) in
            
            guard error == nil else {
                assertionFailure(error!.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,httpResponse.statusCode == 200 else {
                print(response as Any)
                assertionFailure("httpResponse isnt 200")
                return
            }
            
            //print(String(data: data!, encoding: String.Encoding.utf8))
            guard let data = optData else {
                assertionFailure("异常 必须有数据返回")
                return;
            }
            
            let decoder = JSONDecoder()
            
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
            
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            if let outputResult = try? decoder.decode(Array<InfoReleaseDetailDtoOutput>.self, from: data) {
                DispatchQueue.main.async {
                    completion(outputResult)
                }
            } else {
                assertionFailure("异常 必须能被解析")
            }
        }
        
        task.resume()
    }
    
}
