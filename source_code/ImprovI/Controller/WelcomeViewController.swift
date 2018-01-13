//
//  WelcomeViewController.swift
//  ImprovI
//
//  Created by Macmini on 2/26/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class WelcomeViewController: BaseViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnSignIn.layer.cornerRadius = 8
        btnSignIn.layer.masksToBounds = true
        btnSignUp.layer.cornerRadius = 8
        btnSignUp.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.initIntroImage()
    }
    
    func initIntroImage() {
        let names = ["intro1", "intro2", "intro3", "intro4"]
        let images = names.map{return UIImage(named: $0 + ".png")}
        
        for i in 0..<4 {
            if let image = images[i] {
                let imgView = UIImageView(image: image)
                imgView.contentMode = .scaleAspectFit
                imgView.frame = CGRect(x: CGFloat(i)*self.scrollView.bounds.width, y: 10, width: self.scrollView.bounds.width, height: self.scrollView.bounds.height-10)
                scrollView.addSubview(imgView)
            }
        }
        scrollView.contentSize = CGSize(width: 4.0*self.scrollView.bounds.width, height: self.scrollView.bounds.height)
    }
    
    @IBAction func onPageChanged(_ sender: UIPageControl) {
        scrollView.setContentOffset(CGPoint(x: self.scrollView.bounds.size.width * CGFloat(sender.currentPage), y: 0), animated: true)
    }
}

extension WelcomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) { // any offset changes
        pageControl.currentPage = Int(scrollView.contentOffset.x / self.scrollView.bounds.width)
    }
}
