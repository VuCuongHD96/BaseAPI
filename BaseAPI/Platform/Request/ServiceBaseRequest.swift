//
//  ServiceBaseRequest.swift
//  MobioSDKSwift
//
//  Created by Sun on 23/02/2022.
//

import UIKit

class ServiceBaseRequest {
    
    var urlString = ""
    var params = [String: Any]()
    
    init(urlString: String, params: [String: Any]) {
        self.urlString = urlString
        self.params = params
    }
}
