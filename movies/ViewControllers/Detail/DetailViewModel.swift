//
//  DetailViewModel.swift
//  movies
//
//  Created by Atakan Cengiz KURT on 13.02.2021.
//

import Foundation
import RxSwift
import RxCocoa

class DetailViewModel: NSObject{
    fileprivate let bag = DisposeBag()
    var movie : Movie?
    
    var detail = PublishSubject<DetailResponse>()
    var isFavorite = PublishSubject<Bool>()
    
    override init() {
        super.init()
    }
    
   
    
    
}


extension DetailViewModel{
    func requestDetail(id: Int?) {
        if let id = id{
            let request = NetworkRequest(path: DetailNetwork.id(id: id))
            Network.requestDetail(request: request).subscribe(onNext: {response in
                if let detail = response.result{
                    self.detail.onNext(detail)
                }
            }).disposed(by: self.bag)
        }
    }
    
    
    func isFavorite(_ id : Int?) -> Bool{
        if let id = id{
            return CoreDataManager.favoritesArray.contains(id)
        }
        return false
    }
    
    func actionFavorite(_ id: Int?){
        if let id = id {
            if isFavorite(id){
                CoreDataManager.sharedInstance.deleteFavorite(id)
            }else{
                CoreDataManager.sharedInstance.addFavorite(id)
            }
            self.isFavorite.onNext(isFavorite(id))
        }
   
    }
    
}
