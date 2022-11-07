//
//  URLSession+.swift
//  MobioSDKSwift
//
//  Created by Sun on 24/02/2022.
//

import Foundation

extension URLSession {
    
    static func configured() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 5
        configuration.timeoutIntervalForResource = 5
        configuration.allowsCellularAccess = true
        configuration.httpAdditionalHeaders = [
            "Content-Type": "application/json; charset=utf-8"
        ]
        let session = URLSession.init(configuration: configuration, delegate: nil, delegateQueue: nil)
        return session
    }
}
