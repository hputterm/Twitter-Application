//
//  imageTableViewCell.swift
//  actualSmashtag
//
//  Created by Harry Putterman on 9/19/17.
//  Copyright © 2017 Harry Putterman. All rights reserved.
//

import UIKit
import Twitter
class imageTableViewCell: UITableViewCell {
    @IBOutlet weak var imageViewInTableView: UIImageView!
    var mediaForImage: MediaItem?{didSet{updateUI()}}
    /**
    Downloads the image and displays it withing the cell.
    */
    private func updateUI(){
        if let imageURL = mediaForImage?.url{
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let imageData = try? Data(contentsOf: imageURL), imageURL == self?.mediaForImage?.url{
                    DispatchQueue.main.async {
                        self?.imageViewInTableView?.image = UIImage(data: imageData)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self?.imageViewInTableView?.image = nil
                    }
                }
            }
        }
    }
}
