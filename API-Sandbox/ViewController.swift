//
//  ViewController.swift
//  API-Sandbox
//
//  Created by Dion Larson on 6/24/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator


class ViewController: UIViewController {

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var rightsOwnerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var json: JSON?
    var isButtonAvailable = false
    var randomMovie: Movie? {
        didSet {
            if randomMovie != nil {
                isButtonAvailable = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        exerciseOne()
//        exerciseTwo()
//        exerciseThree()
        
        let apiToContact = "https://itunes.apple.com/us/rss/topmovies/limit=25/json"
        // This code will call the iTunes top 25 movies endpoint listed above
        Alamofire.request(.GET, apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    self.json = JSON(value)
                    let randomMovieData = self.json!["feed"]["entry"][Int(arc4random_uniform(UInt32(25)))]
                    self.randomMovie = Movie(json: randomMovieData)
                    self.movieTitleLabel.text = self.randomMovie!.name
                    self.rightsOwnerLabel.text = self.randomMovie!.rightsOwner
                    self.releaseDateLabel.text = self.randomMovie!.releaseDate
                    self.priceLabel.text = String(self.randomMovie!.price)
                    self.loadPoster(self.randomMovie!.poster)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Updates the image view when passed a url string
    func loadPoster(urlString: String) {
        posterImageView.af_setImageWithURL(NSURL(string: urlString)!)
    }
    
    @IBAction func viewOniTunesPressed(sender: AnyObject) {
        if isButtonAvailable {
            UIApplication.sharedApplication().openURL(NSURL(string: randomMovie!.link)!)
        }
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        if isButtonAvailable {
            let randomMovieData = self.json!["feed"]["entry"][Int(arc4random_uniform(UInt32(25)))]
            self.randomMovie = Movie(json: randomMovieData)
            self.movieTitleLabel.text = self.randomMovie!.name
            self.rightsOwnerLabel.text = self.randomMovie!.rightsOwner
            self.releaseDateLabel.text = self.randomMovie!.releaseDate
            self.priceLabel.text = String(self.randomMovie!.price)
            self.loadPoster(self.randomMovie!.poster)
        }
    }
}

