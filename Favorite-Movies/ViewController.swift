//
//  ViewController.swift
//  Favorite-Movies
//
//  Created by Lucinda Krahl on 3/26/17.
//  Copyright © 2017 LK. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var favoriteMovies: [Movie] = []
    
    @IBOutlet var mainTableView: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchMoviesSegue" {
            let controller = segue.destination as! SearchViewController
            controller.delegate = self
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let moviecell = mainTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        
        //let moviecell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as CustomTableViewCell!
        
        let idx: Int = indexPath.row
        
        moviecell.movieTitleLabel?.text = favoriteMovies[idx].title
        moviecell.movieYearLabel?.text = favoriteMovies[idx].year
        
        displayMovieImage(idx, moviecell: moviecell)
        return moviecell
    }
    
    func displayMovieImage(_ row: Int, moviecell: CustomTableViewCell) {
        let url: String = (URL(string: favoriteMovies[row].imageUrl)?.absoluteString)!
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {(data, response, error) -> Void in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async(execute: {
                let image = UIImage(data: data!)
                moviecell.movieImageView?.image = image
            })
        }).resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainTableView.reloadData()
        if favoriteMovies.count == 0 {
            favoriteMovies.append(Movie(id: "1", title: "Begin Again", year: "2003", imageUrl: "https://resizing.flixster.com/zhpjsAINE3sNQUn-YQ0Fa208wtk=/206x305/v1.bTsxMTE4MDg5MTtqOzE3MzY0OzEyMDA7ODAwOzEyMDA"))
        }
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

