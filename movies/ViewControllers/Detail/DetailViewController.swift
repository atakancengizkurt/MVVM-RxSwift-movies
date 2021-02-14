//
//  DetailViewController.swift
//  movies
//
//  Created by Atakan Cengiz KURT on 13.02.2021.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher



class DetailViewController: UIViewController, UIGestureRecognizerDelegate {
    fileprivate let bag = DisposeBag()
    var viewModel: DetailViewModel = DetailViewModel()

    @IBOutlet weak var favoriteButtonOutlet: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seasonsCountLabel: UILabel!
    @IBOutlet weak var totalEpisodesLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.addListeners()
    }
    
   

    func addListeners(){
        self.viewModel.requestDetail(id: self.viewModel.movie?.id)
        
        self.viewModel.detail.subscribe { (detail) in
            self.loadUI(detail: detail)
        }.disposed(by: bag)
        
        
        self.viewModel.isFavorite.subscribe { (isFavorite) in
            self.checkFavorite(isFavorite)
        }.disposed(by: bag)

    }
    
    
    func loadUI(detail: DetailResponse){
        if let imgUrl = detail.poster_path{
            self.imageView.kf.setImage(with: URL(string: Config.imagePathURL + imgUrl), placeholder: UIImage(named: "placeholder"))
        }else{
            self.imageView.image = UIImage(named: "placeholder")
        }
        
        self.titleLabel.text = detail.name
        self.genresLabel.text = detail.getGenres()
        self.seasonsCountLabel.text = detail.number_of_seasons?.description
        self.totalEpisodesLabel.text = detail.number_of_episodes?.description
        
        self.checkFavorite(self.viewModel.isFavorite(self.viewModel.movie?.id))
       
    }
    
    func checkFavorite(_ isFavorite: Bool){
        if isFavorite{
            self.favoriteButtonOutlet.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else{
            self.favoriteButtonOutlet.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
  
    
    @IBAction func favoriteButtonAction(_ sender: Any) {
        self.viewModel.actionFavorite(self.viewModel.movie?.id)
    }
    

}
