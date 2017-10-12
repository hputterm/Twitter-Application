//
//  ImageViewController.swift
//  actualSmashtag
//
//  Created by Harry Putterman on 9/20/17.
//  Copyright © 2017 Harry Putterman. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    var imageData: URL?{
        didSet{
            image = nil
            getImageFromURL()
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.05
            scrollView.maximumZoomScale = 3.0
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }
    /**
    Fetches an image from the URL and sets the variable for image so it will display.
    */
    private func getImageFromURL(){
        if let url = imageData {
            DispatchQueue.global(qos: .userInitiated).async {[weak self] in
                let imageContents = try? Data(contentsOf: url)
                if let data = imageContents, url == self?.imageData{
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    fileprivate var imageView = UIImageView()
    /**
    Centers an image in the scrollview.  Not working currently so not being used.  Needs to be fixed.
    */
    private func scaleAndCenter(){
        if let scrollViewWithImage = scrollView,image != nil{
            scrollViewWithImage.zoomScale = max(scrollViewWithImage.bounds.size.height/image!.size.height, scrollViewWithImage.bounds.size.width/image!.size.width)
            scrollViewWithImage.contentOffset = CGPoint(x: (image!.size.width-scrollViewWithImage.bounds.size.width)/2,y: (image!.size.height-scrollViewWithImage.bounds.size.height)/2)
        }
    }
    private var image: UIImage?{
        get{
            return imageView.image
        }
        set{
            imageView.contentMode = .scaleAspectFit
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            //scaleAndCenter()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil{
            getImageFromURL()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //scaleAndCenter()
    }
}
extension ImageViewController : UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
