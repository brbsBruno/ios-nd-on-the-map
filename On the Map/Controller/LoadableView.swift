//
//  LoadableView.swift
//  On the Map
//
//  Created by Bruno Barbosa on 17/02/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    var activityIndicator: UIActivityIndicatorView!
    
    init(for view: UIView) {
        super.init(frame: view.frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        activityIndicator.style = .whiteLarge
        activityIndicator.hidesWhenStopped = true
        
        let container = UIView()
        container.frame = frame
        container.backgroundColor = UIColor.init(white: 0.0, alpha: 0.3)
        
        activityIndicator.center = container.center
        container.addSubview(activityIndicator)
        addSubview(container)
    }
}

protocol LoadableView {
    var loadingView: LoadingView! { get set }
    
    func showLoadingView()
    func dismissLoadingView()
}

extension LoadableView where Self: UIViewController {
    
    func showLoadingView() {
        view.addSubview(loadingView)
        loadingView.activityIndicator.startAnimating()
    }
    
    func dismissLoadingView() {
        loadingView.activityIndicator.stopAnimating()
        loadingView.removeFromSuperview()
    }
}
