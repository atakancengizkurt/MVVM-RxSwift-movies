//
//  PopularTvShowsTableViewController.swift
//  movies
//
//  Created by Atakan Cengiz KURT on 13.02.2021.
//

import UIKit
import RxCocoa
import RxSwift

class PopularTvShowsTableViewController: UITableViewController {
    fileprivate let bag = DisposeBag()
    fileprivate var popularTvShowsViewModel:PopularTvShowsViewModel = PopularTvShowsViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.addListeners()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    
    fileprivate func registerCell(){
        let nibMovieTableViewCell = UINib(nibName: "MovieTableViewCell", bundle: nil)
        tableView.register(nibMovieTableViewCell, forCellReuseIdentifier: "MovieTableViewCell")
    }
    
    
    fileprivate func addListeners(){
        self.popularTvShowsViewModel.requestPopular()
        self.tableView.dataSource = nil
        self.loadTableView()
        
        self.tableView
            .rx
            .modelSelected(Movie.self)
            .subscribe(onNext: { [weak self] movie in
                
                if let selectedRowIndexPath = self?.tableView.indexPathForSelectedRow {
                    self?.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
                }
                
                if let vc: DetailViewController = Storyboards.detailViewController.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
                    vc.viewModel.movie = movie
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            })
            .disposed(by: bag)
        
        
        
        tableView
            .rx
            .willDisplayCell
            .subscribe(onNext: { cell, indexPath in
                if indexPath.row > self.popularTvShowsViewModel.moviesArray.count - 2{
                    self.popularTvShowsViewModel.requestPopular()
                }
            })
            .disposed(by: bag)
    }
    
    func loadTableView(){
        
        popularTvShowsViewModel.movies.bind(to: tableView.rx.items(cellIdentifier: "MovieTableViewCell", cellType: MovieTableViewCell.self)) { (row,item,cell) in
            cell.initCell(movie: item)
        }.disposed(by: bag)
        
    }
    
    
    
    
    
    
    
}
