//
//  ResponseParse.swift
//  MobioSDKSwift
//
//  Created by Sun on 22/03/2022.
//

import Foundation

struct ResponseParse {
    
    typealias Dictionary = [String : Any]
    
    static func parseJson(from data: Data?) -> Dictionary {
        guard let data = data else {
            return [String: Any]()
        }
        if let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) {
            if let dataDictionary = jsonData as? Dictionary {
                return dataDictionary
            }
        }
        return [String: Any]()
    }
}
