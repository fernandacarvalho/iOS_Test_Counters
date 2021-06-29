//
//  SuccessAnimation.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 29/06/21.
//

import Foundation
import UIKit

public protocol SuccessAnimationDelegate: NSObjectProtocol {
    func animationDidEnd()
    func willRemoveAnimationFromSuperview()
}

public class SuccessAnimation: UIView, CAAnimationDelegate
{
    fileprivate var circleLayer: CAShapeLayer!
    fileprivate var imageView: UIImageView!
    private let viewFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    private weak var delegate: SuccessAnimationDelegate?
    
    public init(delegate: SuccessAnimationDelegate) {
        super.init(frame: viewFrame)
        
        self.delegate = delegate
        backgroundColor = .green
        let circleH = viewFrame.size.width/2
        let circleX = viewFrame.size.width/2
        let circleY = ((viewFrame.size.height - circleH)/2) + viewFrame.size.width/4
        let path = UIBezierPath(arcCenter: CGPoint(x: circleX, y: circleY), radius: circleX/2, startAngle: 0.0, endAngle: CGFloat(.pi * 2.0), clockwise: true)
        setupCircleLayer(with: path, andLineWidth: 5.0)
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupCircleLayer(with circlePath: UIBezierPath, andLineWidth lineWidth: CGFloat) {
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.clear.cgColor
        circleLayer.lineWidth = lineWidth
        circleLayer.strokeEnd = 0.0
        layer.addSublayer(circleLayer)
        animateCircle(byDuration: 1.0, withColor: .white)
    }
    
    fileprivate func animateCircle(byDuration duration: TimeInterval, withColor color: UIColor) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.delegate = self
        let time: CGFloat = 100
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = time / 100
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        circleLayer.strokeEnd = time / 100
        circleLayer.strokeColor = color.cgColor
        circleLayer.add(animation, forKey: "animateCircle")
    }
    
    fileprivate func setupImage() {
        guard let image = UIImage(systemName: "checkmark") else {
            delegate?.animationDidEnd()
            return
        }
        
        imageView = UIImageView()
        imageView.image = image
        imageView.tintColor = .white
        imageView.frame = CGRect(x: 0, y: 0, width: viewFrame.size.width/5, height: viewFrame.size.width/5)
        imageView.center.y = UIScreen.main.bounds.midY
        imageView.center.x = UIScreen.main.bounds.midX
        imageView.alpha = 0
        addSubview(imageView)
        animateImage()
    }
    
    fileprivate func animateImage() {
        UIView.animate(withDuration: 1.0) {
            self.imageView.alpha = 1
        } completion: { (true) in
            self.removeSuccessAnimation()
        }
    }
    
    fileprivate func removeSuccessAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0.3, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.alpha = 0
            self.delegate?.willRemoveAnimationFromSuperview()
        }, completion: {_ in
            self.removeFromSuperview()
            self.delegate?.animationDidEnd()
        })
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        circleLayer.removeAllAnimations()
        setupImage()
    }
}

