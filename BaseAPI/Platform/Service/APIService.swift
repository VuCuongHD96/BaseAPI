//
//  APIService.swift
//
//

import Foundation
import UIKit

class APIService {
    
    typealias Handler<T: Codable> = (_ value: T?, _ error: Error?) -> Void
    
    static let shared = APIService()
    private var session: URLSession
    var maxRetryTime = 3
    
    init() {
        session = URLSession.configured()
    }
    
    func request<T: Codable>(input: ServiceBaseRequest, completion: @escaping Handler<T>) {
        
        func startRetry(input: ServiceBaseRequest, counter: Int, error: BaseError) {
            if counter < maxRetryTime {
                callApi(input: input, counter: counter + 1)
                return
            }
            completion(nil, error)
        }
        
        func callApi(input: ServiceBaseRequest, counter: Int = 0) {
            let params = input.params
            
            guard let url = URL(string: input.urlString) else {
                return
            }
            let data = try? JSONSerialization.data(withJSONObject: params, options: [])
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = data
            session.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    startRetry(input: input, counter: counter, error: BaseError.unexpectedError)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    startRetry(input: input, counter: counter, error: BaseError.unexpectedError)
                    return
                }
                print("\n\n-------- START REQUEST INPUT")
                print("url = ", input.urlString)
                print("param = ")
                DictionaryPrinter.printBeauty(with: params)
                print("------------ END REQUEST INPUT\n")
                print("------------ START Response --------")
                let statusCode = httpResponse.statusCode
                if statusCode == 200 {
                    let dictionaryResponse = ResponseParse.parseJson(from: data)
                    DictionaryPrinter.printBeauty(with: dictionaryResponse)
                    let result = JSONManager.decode(T.self, from: data!)
                    print("------ debug ------ retry ----- 200")
                    completion(result, nil)
                    return
                }
                print("------ debug ------ retry ----- error code = ", statusCode)
                let baseError = BaseError.httpError(httpCode: statusCode)
                startRetry(input: input, counter: counter, error: baseError)
                print("------------ END Response --------")
            }.resume()
        }
        
        callApi(input: input)
    }
}
