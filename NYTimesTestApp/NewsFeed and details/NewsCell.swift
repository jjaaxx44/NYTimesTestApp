//
//  NewsCell.swift
//  NYTimesTestApp
//
//  Created by Abhishek Chaudhari on 18/08/18.
//  Copyright © 2018 Abhishek Chaudhari. All rights reserved.
//

import UIKit
import SDWebImage
enum DataError: Error {
    case DataMissingError
}

class NewsCell: UITableViewCell {
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var byLineLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //update cell with news object
    func updateCell(news: Results) throws{
        guard let media = news.media?.first else{
            throw DataError.DataMissingError
        }
        guard let mediaMetadata = media.mediaMetadata else{
            throw DataError.DataMissingError
        }

        for mediaData in mediaMetadata {
            if(mediaData.format == "Large Thumbnail"){
                guard let url = mediaData.url else{
                    throw DataError.DataMissingError
                }
                newsImageView.sd_setImage(with: URL(string: url), placeholderImage: nil, options: .progressiveDownload, completed: nil)
            }
        }
        titleLable.text = news.title
        byLineLabel.text = news.byline
    }
}
