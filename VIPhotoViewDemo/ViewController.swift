//
//  ViewController.swift
//  VIPhotoView
//
//  Created by 石峰铭 on 16/5/20.
//  Copyright © 2016年 shifengming. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var viView: VIPhotoView? = nil
    var scrollView: UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setScrollView()
    }

    func setScrollView() {
        
        self.scrollView = UIScrollView(frame: CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height))
        self.scrollView?.backgroundColor = UIColor.blackColor()
        self.scrollView?.pagingEnabled = true
        
        self.scrollView?.contentSize = CGSizeMake(5*self.view.frame.size.width, 0)
        self.scrollView?.contentOffset = CGPointMake(0, 0)
        self.view.addSubview(self.scrollView!)
        
        let imageArr = ["http://a1.mzstatic.com/us/r30/Features49/v4/77/73/3b/77733b19-2fb6-be1a-6a5e-8e01c30d2c94/flowcase_796_390_2x.jpeg","http://img1.5253w.com/uploads/files/20160510/cd16b814995a5f0f023f94d490cb9a4c.jpg","http://a1.mzstatic.com/us/r30/Features49/v4/77/73/3b/77733b19-2fb6-be1a-6a5e-8e01c30d2c94/flowcase_796_390_2x.jpeg","http://img1.5253w.com/uploads/files/20160510/cd16b814995a5f0f023f94d490cb9a4c.jpg","http://a5.mzstatic.com/us/r30/Features49/v4/2f/7e/1c/2f7e1c3a-0431-bfc6-13fc-fe77f3a2fcef/flowcase_796_390_2x.jpeg"]
        
        for i in 0 ..< 5 {
            self.viView = VIPhotoView.init(frame: CGRectMake(CGFloat(i)*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height), imageurls: imageArr[i])
            self.viView!.contentMode = .ScaleAspectFit
            self.viView!.autoresizingMask = .FlexibleTopMargin
            self.scrollView?.addSubview(self.viView!)
            
            let imgIndexLbl = UILabel(frame: CGRectMake(CGFloat(i)*self.view.frame.size.width, self.view.frame.size.height - 64 - 40, self.view.frame.size.width, 20))
            imgIndexLbl.text = "\(i + 1)/5"
            imgIndexLbl.textAlignment = .Center
            imgIndexLbl.textColor = UIColor.whiteColor()
            self.scrollView?.addSubview(imgIndexLbl)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

