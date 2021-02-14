//
//  PopularTvShowsViewModel.swift
//  movies
//
//  Created by Atakan Cengiz KURT on 13.02.2021.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: PopularTvShowsViewModel {Class}
class PopularTvShowsViewModel: NSObject{
    fileprivate let bag = DisposeBag()
    var pageNumber = 1
    var totalPage = 0
    
    var movies = PublishSubject<[Movie]>()
    var moviesArray = [Movie]()

    override init() {
        super.init()
    }
    
}

//MARK: Request
extension PopularTvShowsViewModel{
    func requestPopular() {
        let request = NetworkRequest(path: PopularTvShowsNetwork.page(page: pageNumber))
        Network.requestPopular(request: request).subscribe(onNext: {response in
            if let result = response.result{
                
                if let totalPages = result.total_pages{
                    self.totalPage = totalPages
                }
                if self.pageNumber != 1{
                    self.pageNumberIncrease()
                    if let movies = result.results{
                        self.moviesArray += movies
                        self.movies.onNext(self.moviesArray)
                    }
                }else{
                    self.pageNumberIncrease()
                    if let movies = result.results{
                        self.moviesArray = movies
                        self.movies.onNext(self.moviesArray)
                    }
                }
            }
        }).disposed(by: self.bag)
    }
    
    func pageNumberIncrease(){
        if totalPage > pageNumber{
            pageNumber += 1
        }
    }
    

    
}
