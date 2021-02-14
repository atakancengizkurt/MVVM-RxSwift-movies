//
//  MovieTableViewCell.swift
//  movies
//
//  Created by Atakan Cengiz KURT on 13.02.2021.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieFavoriteImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func initCell(movie: Movie){
        
        if let imageUrl = movie.poster_path {
            self.movieImageView.kf.setImage(with: URL(string: Config.imagePathURL + imageUrl),placeholder: UIImage(named: "placeholder"))
        }else{
            self.movieImageView.image = UIImage(named: "placeholder")
        }
        
        self.movieRatingLabel.text = movie.vote_average?.description
        self.movieTitleLabel.text = movie.name
        
        
        if let id = movie.id{
            self.movieFavoriteImageView.image = CoreDataManager.favoritesArray.contains(id) ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        }else{
            self.movieFavoriteImageView.image = UIImage(systemName: "heart")
        }
        
    }
    
}
