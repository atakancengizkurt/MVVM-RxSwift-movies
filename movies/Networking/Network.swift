//
//  Network.swift
//  movies
//
//  Created by Atakan Cengiz KURT on 13.02.2021.
//

import Foundation
import RxCocoa
import RxSwift


// MARK: Network Path - Protocol
protocol NetworkPath {
    var url:String { get }
    
    var method:HTTPMethod { get }
}


// MARK: Config - Enum
enum Config {
    static var baseURL: String {
        return "https://api.themoviedb.org/3/tv/"
    }
    
    static var api_key: String {
        return "a3ada2248131697e6791fa8a480b7155"
    }
    
    static var imagePathURL: String {
        return "https://image.tmdb.org/t/p/original/"
    }
    
    
}


// MARK: Network Error - Enum
enum NetworkError {
    case urlCannotBeFormed
    case responseCodeIsNotSatisfied
    case mimeTypeIsNotSatisfied
    case responseDataIsNil
    case responseDataCannotBeConvertedToJSON
    case urlRequestCannotBeFormed
    case downloadedURLIsNull
    case builtInError(error:NSError)
    
    var error:NSError {
        switch self {
        case .urlCannotBeFormed:
            return NSError(domain: "Network-Error", code: 10000, userInfo: ["desc" : "URL Cannot Be Formed"])
        case .responseCodeIsNotSatisfied:
            return NSError(domain: "Network-Error", code: 10001, userInfo: ["desc" : "Response Code is not satisfied"])
        case .mimeTypeIsNotSatisfied:
            return NSError(domain: "Network-Error", code: 10002, userInfo: ["desc" : "Mime type not satisfied"])
        case .responseDataIsNil:
            return NSError(domain: "Network-Error", code: 10003, userInfo: ["desc" : "Response Data is Null"])
        case .responseDataCannotBeConvertedToJSON:
            return NSError(domain: "Network-Error", code: 10004, userInfo: ["desc" : "Response data cannot be converted to json"])
        case .downloadedURLIsNull:
            return NSError(domain: "Network-Error", code: 10005, userInfo: ["desc" : "Downloaded URL is NULL"])
        case .urlRequestCannotBeFormed:
            return NSError(domain: "Network-Error", code: 10005, userInfo: ["desc" : "URL request cannot be formed"])
        case .builtInError(let error):
            return NSError(domain: "Network-Error", code: 10006, userInfo: ["desc" : error.localizedDescription])
        }
    }
}



// MARK: Network Request - Struct
struct NetworkRequest {
    let path:NetworkPath
    init(path:NetworkPath) {
        self.path = path
    }
}



//MARK: Network {Class}
class Network {
    fileprivate var session:URLSession = URLSession.shared
    fileprivate var dataTask:URLSessionDataTask?
    fileprivate var request:NetworkRequest!
    
    fileprivate init() {
        
    }
}

//MARK: Request
extension Network {
    static func requestPopular(request:NetworkRequest)->Observable<NetworkPopularResponse> {
        let nw = Network()
        nw.request = request
        guard let req = nw.urlRequest() else {
            let res = NetworkPopularResponse(result: nil, error: NetworkError.urlRequestCannotBeFormed.error)
            return Observable.of(res)
        }
        
        
        return Observable.create { observer -> Disposable in
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                
                nw.dataTask = nw.session.dataTask(with: req, completionHandler: { (data, response, error) in
                    
                    if let error = error {
                        Network.resolveObservableWithErrorPopular(error: error, obs: observer)
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                        Network.resolveObservableWithErrorPopular(error: NetworkError.responseCodeIsNotSatisfied.error, obs: observer)
                        return
                    }
                    
                    guard let response = response , let mime = response.mimeType, mime == "application/json" else {
                        Network.resolveObservableWithErrorPopular(error: NetworkError.mimeTypeIsNotSatisfied.error, obs: observer)
                        return
                    }
                    
                    guard let data = data else {
                        Network.resolveObservableWithErrorPopular(error: NetworkError.responseDataIsNil.error, obs: observer)
                        return
                    }
                    
                    
                    do {
                        let json = try JSONDecoder().decode(PopularMoviesResponse.self, from: data)
                        DispatchQueue.main.async { observer.onNext(NetworkPopularResponse(result: json, error: nil)) }
                    } catch let err {
                        Network.resolveObservableWithErrorPopular(error: err, obs: observer)
                    }
                    
                    
                    
                })
                nw.dataTask?.resume()
            }
            return Disposables.create()
        }
    }
    
    private static func resolveObservableWithErrorPopular(error:Error , obs:AnyObserver<NetworkPopularResponse>) {
        DispatchQueue.main.async {
            let res = NetworkPopularResponse(result: nil, error: error as NSError? )
            obs.onNext(res)
        }
    }
    
    
    static func requestDetail(request:NetworkRequest)->Observable<NetworkDetailResponse> {
        let nw = Network()
        nw.request = request
        guard let req = nw.urlRequest() else {
            let res = NetworkDetailResponse(result: nil, error: NetworkError.urlRequestCannotBeFormed.error)
            return Observable.of(res)
        }
        
        
        return Observable.create { observer -> Disposable in
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                
                nw.dataTask = nw.session.dataTask(with: req, completionHandler: { (data, response, error) in
                    
                    if let error = error {
                        Network.resolveObservableWithErrorDetail(error: error, obs: observer)
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                        Network.resolveObservableWithErrorDetail(error: NetworkError.responseCodeIsNotSatisfied.error, obs: observer)
                        return
                    }
                    
                    guard let response = response , let mime = response.mimeType, mime == "application/json" else {
                        Network.resolveObservableWithErrorDetail(error: NetworkError.mimeTypeIsNotSatisfied.error, obs: observer)
                        return
                    }
                    
                    guard let data = data else {
                        Network.resolveObservableWithErrorDetail(error: NetworkError.responseDataIsNil.error, obs: observer)
                        return
                    }
                    
                    
                    do {
                        let json = try JSONDecoder().decode(DetailResponse.self, from: data)
                        DispatchQueue.main.async { observer.onNext(NetworkDetailResponse(result: json, error: nil)) }
                    } catch let err {
                        Network.resolveObservableWithErrorDetail(error: err, obs: observer)
                    }
                    
                    
                    
                })
                nw.dataTask?.resume()
            }
            return Disposables.create()
        }
    }
    
    private static func resolveObservableWithErrorDetail(error:Error , obs:AnyObserver<NetworkDetailResponse>) {
        DispatchQueue.main.async {
            let res = NetworkDetailResponse(result: nil, error: error as NSError? )
            obs.onNext(res)
        }
    }

}

// MARK: Request Private methods
extension Network {
    fileprivate func urlRequest()->URLRequest? {
        switch self.request.path.method {
        case .get:
            return self.getRequest()
        }
    }
    
    private func getRequest()->URLRequest? {
        guard let reqMain:URLRequest = self.requestMain() else { return nil }
        return reqMain
    }
    
    private func requestMain()->URLRequest? {
        guard let url = URL(string: self.request.path.url) else { return nil }
        var req = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 10)
        req.httpMethod = self.request.path.method.stringify
        return req
    }
}

