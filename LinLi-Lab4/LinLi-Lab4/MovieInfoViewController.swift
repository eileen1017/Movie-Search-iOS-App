//
//  MovieInfoViewController.swift
//  LinLi-Lab4
//
//  Created by Lin Li on 10/20/18.
//  Copyright © 2018 Lin Li. All rights reserved.
//

import UIKit



class MovieInfoViewController: UIViewController {
    
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
        let homepage:String?
    }
    
    var movieId : Int?
    var movieOverview: String?
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var overviewBTN: UIButton!
    @IBOutlet weak var FavoriteBTN: UIButton!
    @IBOutlet weak var sourceLabel: UILabel!
    
    
    @IBAction func backBTN(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func shareSelected(_ sender: Any) {
        
        let img = createImage(view.frame, fromView: view)
        let googlesearch = "https://www.google.com/search?q=\(titleLabel.text!)"
        if websiteLabel.text != "N/A" {
            let activityViewController = UIActivityViewController(activityItems: [img, websiteLabel.text!], applicationActivities: nil)
            present(activityViewController,animated: true, completion: nil)
        } else {
            let activityViewController = UIActivityViewController(activityItems: [img, googlesearch], applicationActivities: nil)
            present(activityViewController,animated: true, completion: nil)
        }
        
    }
    
    func createImage(_ rect: CGRect, fromView:UIView) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: rect.width, height: rect.height), true, 1)
        fromView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    @IBAction func favoriteSelected(_ sender: Any) {
        
        var favorited = UserDefaults.standard.array(forKey: "favorited") as? [String]
        favorited = favorited ?? []
        if (favorited?.contains(titleLabel.text!))! {
            let alert = UIAlertController(title: "Error!", message: "You have already added to your favorites. Check it in Favorites." , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style: .default, handler:nil))
            present(alert, animated:true, completion:nil)
        } else {
            favorited?.append(titleLabel.text!)
            UserDefaults.standard.set(favorited, forKey: "favorited")
            let alert = UIAlertController(title: "Congrats!", message: "You have successfully added this movie to your favorites. Check it in Favorites." , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style: .default, handler:nil))
            present(alert, animated:true, completion:nil)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchMovies()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOverview" {
            let destination = segue.destination as? PopUpViewController
            destination!.overviewString = movieOverview
        }
        if segue.identifier == "showRecommend" {
            let destination = segue.destination as? RecommendViewController
            destination!.movieId = movieId
        }
        
        
    }
    
    func fetchMovies() {
        //let apiKey = "0ce1c9525a732f1bc15f4313aab2b145"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(String(describing: movieId!))?api_key=0ce1c9525a732f1bc15f4313aab2b145")
        let request = NSURLRequest(url: url! as URL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: {(dataOrNil, response, error) in
            if let data = dataOrNil {
                let movieInfo = try! JSONDecoder().decode(Movie.self, from: data)
                let imageURL = "https://image.tmdb.org/t/p/w500/"
                
                if movieInfo.poster_path != nil {
                    let img = imageURL + movieInfo.poster_path!
                    let imgURL = URL(string: img)
                    let data = try? Data(contentsOf: imgURL!)
                    self.movieImage.image = UIImage(data:data!)
                } else {
                    self.movieImage.image = UIImage(named:"unfound")
                }
                
                self.titleLabel.text = movieInfo.title
                
                if movieInfo.homepage != nil {
                    self.websiteLabel.text = movieInfo.homepage
                } else {
                    self.websiteLabel.text = "N/A"
                }
                
                self.dateLabel.text = movieInfo.release_date
                self.rateLabel.text = String(movieInfo.vote_average)
                self.movieOverview = movieInfo.overview
                self.sourceLabel.text = "Source: https://www.themoviedb.org/"
                self.navItem.title = movieInfo.title
            }
            
        })
        
        task.resume()
        
    }
    

}
