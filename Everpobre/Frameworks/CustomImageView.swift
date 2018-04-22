//
//  CustomImageView.swift
//  Everpobre
//
//  Created by Javi on 5/4/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView{
    let objectVinculated : UIView
    var posX: Float
    var posY: Float
    var rotation: Float
    var scale: Float
    
    var imageView : UIImageView = {
        let imageV = UIImageView()
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.backgroundColor = UIColor.red
        return imageV
    }()
    
    var topImageConstraint: NSLayoutConstraint!
    var leftImageConstraint: NSLayoutConstraint!
    var bottomImageConstraint: NSLayoutConstraint!
    var rightImageConstraint: NSLayoutConstraint!
    var relativePoint: CGPoint!
    
    init(view: UIView, image: UIImage, posX: Float, posY: Float, rotation: Float, scale: Float) {
        objectVinculated = view
        self.imageView.image = image
        self.posX = posX
        self.posY = posY
        self.rotation = rotation
        self.scale = scale
        super.init(image: image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUIStyle(){
        
        objectVinculated.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            
            imageView.widthAnchor.constraint(equalToConstant: 250),
            imageView.heightAnchor.constraint(equalToConstant: 250)
            
        ])
        
        topImageConstraint = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: objectVinculated, attribute: .top, multiplier: 1, constant: CGFloat(self.posX))
        topImageConstraint.isActive = true

//        bottomImageConstraint = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: objectVinculated, attribute: .bottom, multiplier: 1, constant: -20)
        
        leftImageConstraint = NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: objectVinculated, attribute: .left, multiplier: 1, constant: CGFloat(self.posY))
        leftImageConstraint.isActive=true
//
//        rightImageConstraint = NSLayoutConstraint(item: imageView, attribute: .right, relatedBy: .equal, toItem: objectVinculated, attribute: .right, multiplier: 1, constant: -20)
//
        if (self.rotation != 0 ){
            objectVinculated.transform = CGAffineTransform.init(rotationAngle: CGFloat(self.rotation))
        }
        
        if (self.scale != 0 ){
            objectVinculated.transform = CGAffineTransform.init(scaleX: CGFloat(self.scale), y: CGFloat(self.scale))
        }
        
        var imgConstraints : [NSLayoutConstraint] = []
        imgConstraints.append(contentsOf: [topImageConstraint,leftImageConstraint])
        
        // Gestures
        let moveViewGesture = UILongPressGestureRecognizer(target: self, action: #selector(userMoveImage))
        let rotateViewGesture = UIRotationGestureRecognizer(target: self, action: #selector(userRotateImage))
        let pinchViewGesture = UIPinchGestureRecognizer(target: self, action: #selector(userPinchImage))

        imageView.addGestureRecognizer(moveViewGesture)
        imageView.addGestureRecognizer(rotateViewGesture)
        imageView.addGestureRecognizer(pinchViewGesture)
        
        imageView.isUserInteractionEnabled = true
    }
    
    @objc func userMoveImage(longPressGesture:UILongPressGestureRecognizer)
    {
        switch longPressGesture.state {
        case .began:
            relativePoint = longPressGesture.location(in: longPressGesture.view)
            UIView.animate(withDuration: 0.1, animations: {
                self.imageView.transform = CGAffineTransform.init(scaleX: CGFloat(self.scale) + 0.2, y: CGFloat(self.scale) + 0.2)
            })
            
        case .changed:
            let location = longPressGesture.location(in: objectVinculated)
            
            leftImageConstraint.constant = location.x - relativePoint.x
            topImageConstraint.constant = location.y - relativePoint.y
            posX = Float((location.x - relativePoint.x))
            posY = Float((location.y - relativePoint.y))
            
        case .ended, .cancelled:
            
            UIView.animate(withDuration: 0.1, animations: {
                self.imageView.transform = CGAffineTransform.init(scaleX: CGFloat(self.scale) - 0.2, y: CGFloat(self.scale) - 0.2)
            })
            
        default:
            break
        }
    }
    
    @objc func userRotateImage(rotationPressGesture: UIRotationGestureRecognizer){
        if let view = rotationPressGesture.view {
            view.transform = view.transform.rotated(by: rotationPressGesture.rotation)
            self.rotation = Float(rotationPressGesture.rotation)
            rotationPressGesture.rotation = 0
        }
    }
    
    @objc func userPinchImage(pinchPressGesture: UIPinchGestureRecognizer){
        
        objectVinculated.bringSubview(toFront: self.imageView)
        pinchPressGesture.view?.transform = (pinchPressGesture.view?.transform)!.scaledBy(x: pinchPressGesture.scale , y: pinchPressGesture.scale)
        self.scale = Float(pinchPressGesture.scale)
        pinchPressGesture.scale = 1.0
    }

}


