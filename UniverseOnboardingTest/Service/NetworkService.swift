//
//  NetworkService.swift
//  UniverseOnboardingTest
//
//  Created by Volodymyr Pysarenko on 05.06.2024.
//

import Foundation
import RxSwift
import RxCocoa

enum Endpoints: String {
    case onboarding = "onboarding"
}

final class NetworkService {
    
    private enum Error: Swift.Error {
        case invalidResponse(URLResponse?)
        case invalidJSON(Swift.Error)
    }

    static let shared = NetworkService()
    private let baseURL = "https://test-ios.universeapps.limited/"
    private let session = URLSession.shared
    
    func fetchData<T>(from endpoint: String) -> Observable<T> where T: Decodable {
        let url = URL(string: "\(self.baseURL)/\(endpoint)")!
        let request = URLRequest(url: url)
        
        return session.rx.response(request: request)
            .map { result -> Data in
                guard result.response.statusCode == 200 else {
                    throw Error.invalidResponse(result.response)
                }
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
//            .map { data in
//                do {
//                    let models = try JSONDecoder().decode(T.self, from: data)
//                    return models
//                }
//                catch let error {
//                    throw Error.invalidJSON(error)
//                }
//            }
            .observe(on: MainScheduler.instance)
            .asObservable()
    }
}
