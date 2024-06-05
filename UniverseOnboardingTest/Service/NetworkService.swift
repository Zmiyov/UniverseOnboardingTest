//
//  NetworkService.swift
//  UniverseOnboardingTest
//
//  Created by Vladimir Pisarenko on 05.06.2024.
//

import Foundation
import RxSwift

final class NetworkService {
    static let shared = NetworkService()
    private let baseURL = "https://test-ios.universeapps.limited/"
    
    func fetchData() -> Observable<OnboardingModelContainer> {
        return Observable.create { observer in
            let task = URLSession.shared.dataTask(with: URL(string: "\(self.baseURL)/onboarding")!) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }

                guard let data = data else {
                    observer.onError(NSError(domain: "Data Error", code: 0, userInfo: nil))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let models = try decoder.decode(OnboardingModelContainer.self, from: data)
                    observer.onNext(models)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}
