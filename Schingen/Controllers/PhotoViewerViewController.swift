//
//  PhotoViewerViewController.swift
//  Schingen
//
//  Created by Ozan Barış Günaydın on 10.11.2021.
//

import UIKit
import SDWebImage
import SwiftUI

class PhotoViewerViewController: UIViewController {

    private let url : URL
    
    init(with url: URL) {
        self.url = url
        super .init(nibName: nil, bundle: nil)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo"
        navigationItem.largeTitleDisplayMode = .never
        view.addSubview(imageView)
        view.backgroundColor = .black
        imageView.sd_setImage(with: self.url, completed: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
    }
}
