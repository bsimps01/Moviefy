//
//  MovieCell.swift
//  Moviefy
//
//  Created by Adriana González Martínez on 4/7/20.
//  Copyright © 2020 Adriana González Martínez. All rights reserved.
//

import UIKit
import Kingfisher

class MovieCell: UICollectionViewCell {
    
    static var identifier: String = "MovieCell"
    
    @IBOutlet weak var coverImg: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContents(movie: Movie) {
        topLabel.text = movie.title
        bottomLabel.text = movie.releaseDate
        let imageURL : URL?
        let imageBase = Request.baseImageURL
        imageURL = imageBase.appendingPathComponent(movie.posterPath)
        coverImg.kf.setImage(with: imageURL)
    }
    
    override func prepareForReuse() {
        coverImg.kf.cancelDownloadTask()
        coverImg.image = nil
        topLabel.text = nil
        bottomLabel.text = nil
    }
}
