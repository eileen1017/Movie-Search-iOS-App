//
//  FavoriteViewController.swift
//  LinLi-Lab4
//
//  Created by Lin Li on 10/20/18.
//  Copyright © 2018 Lin Li. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var movieTableView: UITableView!
    var movieTitles: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.dataSource = self
        movieTableView.delegate = self
        
        var favorited = UserDefaults.standard.array(forKey: "favorited") as? [String]
        favorited = favorited ?? []
        movieTitles = favorited
        movieTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func clearSelected(_ sender: Any) {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        movieTitles?.removeAll()
        movieTableView.reloadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        var favorited = UserDefaults.standard.array(forKey: "favorited") as? [String]
        favorited = favorited ?? []
        movieTitles = favorited
        movieTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieTitles!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as! FavoritesCell
        cell.favoritesLabel.text = movieTitles?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            movieTitles?.remove(at: indexPath.row)
            var favorited = UserDefaults.standard.array(forKey: "favorited") as! [String]
            favorited.remove(at: indexPath.row)
            UserDefaults.standard.set(favorited, forKey: "favorited")
            movieTableView.reloadData()
        }
    }


    
}
