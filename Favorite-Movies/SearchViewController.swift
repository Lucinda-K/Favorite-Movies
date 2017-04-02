//
//  SearchViewController.swift
//  Favorite-Movies
//
//  Created by Lucinda Krahl on 4/2/17.
//  Copyright © 2017 LK. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchTableView: UITableView!
    
    var delegate: ViewController!
    
    var searchResults: [Movie] = []
    
    @IBAction func search(sender: UIButton) {
        print("Searching...")
        
        var searchTerm = searchTextField.text!
        if searchTerm.characters.count > 2 {
            retrieveMovieByTerm(searchTerm: searchTerm)
        }
    }
    
    @IBAction func addFavMovie (sender: UIButton) {
        
        
        print("Item #\(sender.tag) was added to favorite movies")
        self.delegate.favoriteMovies.append(searchResults[sender.tag])
    }
    
    func retrieveMovieByTerm(searchTerm: String) {
        let url = "https://www.omdbapi.com/?s=\(searchTerm)&type=movie&r=json"
        HTTPHandler.getJson(urlString: url, completionHandler: parseDataIntoMovies)
    }
    
    func parseDataIntoMovies(data: Data?) -> Void {
        if let data = data{
            let object = JSONParser.parse(data: data)
            if let object = object {
                self.searchResults = MovieDataProcessor.mapJsonToMovies(object: object, moviesKey: "Search")
                DispatchQueue.main.async {
                    self.searchTableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Search Results"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // grouped verticle sections of the tableView
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // at init/appear ... this runs for each visible cell
        let moviecell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        
        let idx: Int = indexPath.row
        moviecell.favButton.tag = idx
        
        moviecell.movieTitleLabel?.text = searchResults[idx].title
        moviecell.movieYearLabel?.text = searchResults[idx].year
        
        displayMovieImage(idx, moviecell: moviecell)
        
        return moviecell
        
    }
    
    
    func displayMovieImage(_ row: Int, moviecell: CustomTableViewCell) {
        let url: String = (URL(string: searchResults[row].imageUrl)?.absoluteString)!
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}
