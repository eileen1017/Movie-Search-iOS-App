//
//  SecondViewController.swift
//  LinLi-Lab4
//
//  Created by Lin Li on 10/20/18.
//  Copyright © 2018 Lin Li. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    struct APIResults:Decodable {
        let page: Int
        let total_results: Int
        let total_pages: Int
        let results: [Movie]
    }
    struct Movie: Decodable {
        let id: Int!
        let poster_path: String?
        let title: String
        let release_date: String
        let vote_average: Double
        let overview: String
        let vote_count:Int!
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    var movies: [NSDictionary]?
    var movieId: Int?
    var mInfo = [Movie]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        self.loadingSpinner.isHidden = true
        let layout = self.movieCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        layout.minimumInteritemSpacing = 5
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        mInfo = []
        movieCollectionView.reloadData()
        let movieSearch = searchBar.text?.replacingOccurrences(of: " ", with: "%20")
        self.loadingSpinner.startAnimating()
        self.loadingSpinner.isHidden = false
        
        if movieSearch != "" {
            DispatchQueue.global(qos: .userInteractive).async {
                self.fetchMovies(movieTitle: movieSearch!)
                DispatchQueue.main.async {
                    self.movieCollectionView.reloadData()
                    self.loadingSpinner.stopAnimating()
                    self.loadingSpinner.isHidden = true
                }
            }
        } else {
            self.loadingSpinner.stopAnimating()
            self.loadingSpinner.isHidden = true
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let m = mInfo[indexPath.row]
        
        let imageURL = "https://image.tmdb.org/t/p/w500/"
        let title = m.title
        
        if m.poster_path != nil {
            let img = imageURL + m.poster_path!
            let imgURL = URL(string: img)
            let data = try? Data(contentsOf: imgURL!)
            cell.movieImage.image = UIImage(data:data!)
        } else {
            cell.movieImage.image = UIImage(named:"unfound")
        }
        cell.movieTitle.text = title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        movieId = mInfo[indexPath.row].id
        performSegue(withIdentifier: "SearchMovie", sender: movieId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchMovie" {
            let destination = segue.destination as? MovieInfoViewController
            destination!.movieId = movieId
            
        }
    }

    func fetchMovies(movieTitle:String) {
        //let apiKey = "0ce1c9525a732f1bc15f4313aab2b145"
        let url = NSURL(string:"https://api.themoviedb.org/3/search/movie?api_key=0ce1c9525a732f1bc15f4313aab2b145&query=\(movieTitle)&page=1")
        let request = NSURLRequest(url: url! as URL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: {(dataOrNil, response, error) in
            if let data = dataOrNil {
                
                let movieResult = try! JSONDecoder().decode(APIResults.self, from: data)
                let movieInfo = movieResult.results
                for i in (movieInfo) {
                    self.mInfo.append(i)
                }
                self.movieCollectionView.reloadData()
                self.loadingSpinner.stopAnimating()
                self.loadingSpinner.isHidden = true
                
            }
        })
        
        task.resume()
        
    }
    
    
    
}

