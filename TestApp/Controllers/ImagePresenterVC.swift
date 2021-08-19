//
//  ImagePresenterVC.swift
//  TestApp
//
//  Created by Михаил Красильник on 16.08.2021.
//

import UIKit

class ImagePresenterVC: UIViewController {

    var imageView = UIImageView()
    var imageURL = ""
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.frame = view.frame
        imageView.contentMode = .scaleAspectFit
        
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        view.addSubview(imageView)
        
        
        DispatchQueue.main.async {
            
            self.imageView.fetchData(url: self.imageURL)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }


    init(cellModel: CellModel) {
        
        imageURL = cellModel.fullImage
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
