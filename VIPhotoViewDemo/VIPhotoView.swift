//
//  VIPhotoView.swift
//  VIPhotoView
//
//  Created by 石峰铭 on 16/5/20.
//  Copyright © 2016年 shifengming. All rights reserved.
//

import UIKit
import Kingfisher


extension UIImage {
    func sizeThatFits(size: CGSize) -> CGSize {
        var imageSize = CGSizeMake(self.size.width / self.scale, self.size.height / self.scale)
        let widthRatio: CGFloat = imageSize.width / size.width
        let heightRatio: CGFloat = imageSize.height / size.height
        
        if widthRatio > heightRatio {
            imageSize = CGSizeMake(imageSize.width / widthRatio, imageSize.height / widthRatio)
        }else{
            imageSize = CGSizeMake(imageSize.width / heightRatio, imageSize.height / heightRatio)
        }
        return imageSize
    }
}

extension UIImageView {
    func contentSize() -> CGSize {
        return (self.image?.sizeThatFits(self.bounds.size))!
    }
}


class VIPhotoView: UIScrollView,UIScrollViewDelegate {

    var constainerView: UIView?
    var imageView: UIImageView?
    var rotating: Bool?
    var minSize: CGSize?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame:CGRect, imageurls:String) {
        self.init(frame: frame)
        self.initialize(frame, imageUrls: imageurls)
    }
    
    func initialize(frame: CGRect, imageUrls: String) {
        
        self.delegate = self
        self.bouncesZoom = true
        
        self.constainerView = UIView.init(frame: self.bounds)
        constainerView?.backgroundColor = UIColor.clearColor()
        self.addSubview(constainerView!)
        
        self.imageView = UIImageView()
        let placeHolderImage = UIImage(named: "5.pic_hd")
        print(imageUrls)
    
        imageView?.kf_setImageWithURL(NSURL(string: imageUrls)!, placeholderImage: placeHolderImage, optionsInfo: nil , progressBlock: { (receivedSize, totalSize) in
            
            print("downloading")
            print(receivedSize)
            print(totalSize)
            
            }, completionHandler: { (image, error, cacheType, imageURL) in
                
                self.imageView?.frame = (self.constainerView?.frame)!
                self.imageView?.contentMode = .ScaleAspectFit
                self.constainerView?.addSubview(self.imageView!)
                
                let imageSize = self.imageView?.contentSize()
                self.constainerView?.frame = CGRectMake(0, 0, (imageSize?.width)!, (imageSize?.height)!)
                self.imageView?.bounds = CGRectMake(0, 0, (imageSize?.width)!, (imageSize?.height)!)
                self.imageView?.center = CGPointMake((imageSize?.width)!/2, (imageSize?.height)!/2)
                
                self.contentSize = imageSize!
                self.minSize = imageSize!
                
                self.setMaxMinZoomScale()
                self.centerContent()
                self.setupGestureRecognizer()
                self.setupRotationNotification()
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.rotating == true {
            self.rotating = false
            
            let constainerSize = self.constainerView?.frame.size
            
            let containerSmallerThanSelf: Bool = (constainerSize!.width < CGRectGetWidth(self.bounds)) && (constainerSize!.height < CGRectGetHeight(self.bounds))
            
            let imageSize = self.imageView?.image?.sizeThatFits(self.bounds.size)
            let minZoomScale: CGFloat = (imageSize?.width)! / (self.minSize?.width)!
            self.minimumZoomScale = minZoomScale
            
            if containerSmallerThanSelf || self.zoomScale == self.minimumZoomScale {
                self.zoomScale = minimumZoomScale
            }
            
            self.centerContent()
        }
    }
    
    
    func setupRotationNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(orientationChanged), name: UIApplicationDidChangeStatusBarOrientationNotification, object: nil)
    }
    
    func setupGestureRecognizer() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapHandler(_:)))
        tap.numberOfTapsRequired = 2
        self.constainerView?.addGestureRecognizer(tap)
    }
    
    // MARK: UISCrollViewDelegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.constainerView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        self.centerContent()
    }
    
    // MARK: UITapGestureRecognizer
    func tapHandler(recognize : UITapGestureRecognizer) {
        if self.zoomScale > self.minimumZoomScale {
            self.setZoomScale(self.minimumZoomScale, animated: true)
        }else if self.zoomScale < self.maximumZoomScale {
            let location = recognize.locationInView(recognize.view)
            var zoomToRect: CGRect = CGRectMake(0, 0, 50, 50)
            zoomToRect.origin = CGPointMake(location.x - CGRectGetWidth(zoomToRect)/2, location.y - CGRectGetHeight(zoomToRect)/2)
            self.zoomToRect(zoomToRect, animated: true)
        }
    }
    
    func orientationChanged() {
        self.rotating = true
    }
    
    func setMaxMinZoomScale() {
        let imageSize: CGSize = (self.imageView?.image?.size)!
        let imagePresentationSize = self.imageView?.contentSize()
        let maxScale:CGFloat = imageSize.height / (imagePresentationSize?.height)! > imageSize.width / (imagePresentationSize?.width)! ? imageSize.height / (imagePresentationSize?.height)! : imageSize.width / (imagePresentationSize?.width)!
        self.maximumZoomScale = maxScale > 1 ? maxScale : 1
        self.minimumZoomScale = 1
    }
    
    func centerContent() {
        
        let frame = self.constainerView?.frame
        var top: CGFloat = 0
        var left: CGFloat = 0
        if self.contentSize.width < self.bounds.size.width {
            left = (self.bounds.size.width - self.contentSize.width) * 0.5
        }
        if self.contentSize.height < self.bounds.size.height {
            top = (self.bounds.size.height - self.contentSize.height) * 0.5
        }
        top -= (frame?.origin.y)!
        left -= (frame?.origin.x)!
        
        self.contentInset = UIEdgeInsetsMake(top, left, top, left)
    }
    
}
