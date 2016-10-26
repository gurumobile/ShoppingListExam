//
//  LGProgressHUD.swift
//  LGProgressHUD
//
//  Created by jamy on 12/1/15.
//  Copyright © 2015 jamy. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

public enum showStyle {
    case success
    case error
    case warning
    case none
    case customImage(imageName:String)
}

public enum LGProgressIndeficatorType {
    case system
    case custom
    
    func indeficatorView() ->UIView {
        var indeficatorView: UIView?
        switch self{
        case .custom:
            indeficatorView = CustomIndeficatorView()
        case .system:
            indeficatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            indeficatorView!.sizeToFit()
            (indeficatorView as! UIActivityIndicatorView).color = UIColor.lightGray
        }
        return indeficatorView!
    }
}

// MARK: just call below class function
extension LGProgressHUD {
    // MARK: class function
    
    public class func dismiss(_ view: UIView = UIApplication.shared.keyWindow!) {
        DispatchQueue.main.async { () -> Void in
            for view in view.subviews {
                if view.isKind(of: LGProgressHUD.self) {
                    let hud = view as! LGProgressHUD
                    hud.hiddenView(0)
                }
            }
        }
    }
    
    public class func showHud(_ title: String = "", style: showStyle = .none, view: UIView = UIApplication.shared.keyWindow!) {
        DispatchQueue.main.async { () -> Void in
            let hud = LGProgressHUD()
            hud.show(title, style: style, view: view)
        }
    }

    public class func showHud(_ hiddenDelay: TimeInterval, title: String = "", style: showStyle = .none, view: UIView = UIApplication.shared.keyWindow!) {
        DispatchQueue.main.async { () -> Void in
            let hud = LGProgressHUD()
            hud.show(title, style: style, view: view)
            
            hud.hiddenView(hiddenDelay)
        }
    }
    
    public class func showHud(_ title: String = "", IndeficatorType: LGProgressIndeficatorType = .system, view: UIView = UIApplication.shared.keyWindow!) {
        DispatchQueue.main.async { () -> Void in
            let hud = LGProgressHUD()
            hud.indeficatorType = IndeficatorType
            hud.show(title, view: view)
        }
    }
    
    public class func showHud(_ hiddenDelay: TimeInterval, title: String = "", IndeficatorType: LGProgressIndeficatorType = .system, view: UIView = UIApplication.shared.keyWindow!) {
        DispatchQueue.main.async { () -> Void in
            let hud = LGProgressHUD()
            hud.indeficatorType = IndeficatorType
            hud.show(title, view: view)
            
            hud.hiddenView(hiddenDelay)
        }
    }
}


private let defaultAnimaitonHeight: CGFloat = 80

@available(iOS 8.0, *)
open class LGProgressHUD: UIView {
    
    let maxContentViewSize = CGSize(width: 3.0 * defaultAnimaitonHeight, height: 3.0 * defaultAnimaitonHeight)
    let topMargin: CGFloat = 10
    let horzriedMargin: CGFloat = 10
    
    var contentView = UIView()
    var titleLabel = UILabel()
    
    var imageView: UIImageView?
    var animationView: UIView?
    
    var hudColor: UIColor?
    var contentViewColor: UIColor?
    var titleColor: UIColor?
    
    var indeficatorType = LGProgressIndeficatorType.custom
    
    // MARK: - lifecycle
    init() {
        super.init(frame: UIScreen.main.bounds)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit {
        NSLog("deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func setup() {
        self.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        self.backgroundColor = UIColor.clear
    }
    
    fileprivate func setupContentView() {
        contentView.layer.cornerRadius = 8.0
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(hexString: "FFFFFF", alpha: 0.9)
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    fileprivate func setupTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.text = ""
        titleLabel.baselineAdjustment = .alignCenters
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        titleLabel.textColor = UIColor.white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
    }
    
    fileprivate func setupAnimateView() {
        if let animateView = self.animationView {
            contentView.addSubview(animateView)
            animateView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    fileprivate func setupImageView(_ image: UIImage) {
        imageView = UIImageView()
        imageView?.image = image
        imageView?.contentMode = .scaleAspectFit
        contentView.addSubview(imageView!)
        imageView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: show function
    open func show(_ view: UIView = UIApplication.shared.keyWindow!) {
        return show("", view: view)
    }
    
    open func show(_ title: String, view: UIView = UIApplication.shared.keyWindow!) {
        return show(title, style: .none, view: view)
    }
    
    open func show(_ style: showStyle, view: UIView = UIApplication.shared.keyWindow!) {
        return show("", style: style, view: view)
    }
    
    open func show(_ title: String, style: showStyle, view: UIView = UIApplication.shared.keyWindow!) {
        for subView in view.subviews {
            if subView.isKind(of: LGProgressHUD.self) {
                subView.removeFromSuperview()
            }
        }
        
        self.frame = view.bounds
        view.addSubview(self)
        view.bringSubview(toFront: self)
        
        setupContentView()
        
        if title.characters.count > 0 {
            setupTitleLabel()
            self.titleLabel.text = title
        }
        
        switch style {
        case .success:
            animationView = successfulAnimation()
        case .warning:
            animationView = WarningAnimation()
        case .error:
            animationView = ErrorAnimation()
        case let .customImage(imageName):
            if let image = UIImage(named: imageName) {
                self.setupImageView(image)
            }
        case .none:
            animationView = indeficatorType.indeficatorView()
        }
        
        setupAnimateView()
        updateLayout()
        showHudAnimated()
    }
    
    fileprivate func showHudAnimated() {
        self.alpha = 0;
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.alpha = 1.0;
        })
        
        let previousTransform = self.contentView.transform
        self.contentView.layer.transform = CATransform3DMakeScale(0.9, 0.9, 0.0);
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.contentView.layer.transform = CATransform3DMakeScale(1.1, 1.1, 0.0);
            }, completion: { (Bool) -> Void in
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.contentView.layer.transform = CATransform3DMakeScale(0.9, 0.9, 0.0);
                    }, completion: { (Bool) -> Void in
                        UIView.animate(withDuration: 0.1, animations: { () -> Void in
                            self.contentView.layer.transform = CATransform3DMakeScale(1.0, 1.0, 0.0);
                            if case let animate as AnimationView = self.animationView {
                                animate.animated()
                            } else if case let animate as UIActivityIndicatorView = self.animationView {
                                animate.startAnimating()
                            }
                            
                            }, completion: { (Bool) -> Void in
                                self.contentView.transform = previousTransform
                        }) 
                }) 
        }) 
    }
    
    // MARK: hidden
    
    open func hiddenView(_ delay: TimeInterval) {
        perform(#selector(LGProgressHUD.hiddenView as (LGProgressHUD) -> () -> ()), with: self, afterDelay: delay)
    }
    
    open func hiddenView() {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: { () -> Void in
            self.contentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }) { (_) -> Void in
                self.contentView.alpha = 0
                if let animated = self.animationView {
                    animated.removeFromSuperview()
                }
                if let imageView = self.imageView {
                    imageView.removeFromSuperview()
                }
                self.contentView.removeFromSuperview()
                self.removeFromSuperview()
        }
    }
    
    // MARK: layout
    
    fileprivate func updateLayout() {
        self.frame = UIScreen.main.bounds
        var verturlMargin: CGFloat = 0
        var contentWidth: CGFloat = defaultAnimaitonHeight + 2.0 * topMargin
        
        if let imageView = self.imageView {
            if contentView.subviews.contains(imageView) {
                contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: topMargin))
                contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: horzriedMargin))
                contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -horzriedMargin))
                let tempWidth = imageView.image?.size.height
                let width = tempWidth! > defaultAnimaitonHeight ? defaultAnimaitonHeight : tempWidth!
                imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width))
                verturlMargin = width + topMargin
            }
        }
        
        if let animationView = self.animationView {
            if contentView.subviews.contains(animationView) {
                contentView.addConstraint(NSLayoutConstraint(item: animationView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: topMargin))
                contentView.addConstraint(NSLayoutConstraint(item: animationView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0))
                contentView.addConstraint(NSLayoutConstraint(item: animationView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: defaultAnimaitonHeight))
                contentView.addConstraint(NSLayoutConstraint(item: animationView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: defaultAnimaitonHeight))
                verturlMargin = defaultAnimaitonHeight + topMargin
            }
        }
        
        if contentView.subviews.contains(titleLabel) {
            contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: horzriedMargin))
            contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -horzriedMargin))
            contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: verturlMargin))
            contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -topMargin))
            verturlMargin = verturlMargin + topMargin
            
            if let string = titleLabel.text {
                let str = string as NSString
                let strRect = str.boundingRect(with: CGSize(width: maxContentViewSize.width, height: 200), options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.truncatesLastVisibleLine.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue), attributes: [NSFontAttributeName : titleLabel.font], context: nil)
                verturlMargin = verturlMargin + strRect.height
                
                if strRect.width > contentWidth {
                    contentWidth = strRect.width < maxContentViewSize.width ? strRect.width : maxContentViewSize.width
                }
            }
        }
        
        self.addConstraint(NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: verturlMargin + topMargin))
        contentView.addConstraint(NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: contentWidth))
        
       // updateBlueEffect()
    }
    
    fileprivate func updateBlueEffect() {
        for subView in contentView.subviews {
            if subView.isKind(of: UIVisualEffectView.self) {
                subView.removeFromSuperview()
            }
        }
        
        let blueStyle = UIBlurEffectStyle.light
        let blueEffect = UIBlurEffect(style: blueStyle)
        let blueEffectView = UIVisualEffectView(effect: blueEffect)
        blueEffectView.autoresizingMask = contentView.autoresizingMask
      
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blueEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.autoresizingMask = blueEffectView.autoresizingMask
        blueEffectView.contentView.addSubview(vibrancyEffectView)
        
        self.contentView.insertSubview(blueEffectView, at: 0)
        blueEffectView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: blueEffectView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: blueEffectView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: blueEffectView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: blueEffectView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0))
    }
    
}

// MARK: - UIColor Extension
extension UIColor {
    
    convenience init?(hexString: String, alpha: Float = 1) {
        var hex = hexString
        
        if hex.hasPrefix("#") {
            hex = hex.substring(from: hex.characters.index(hex.startIndex, offsetBy: 1))
        }
        
        if let _ = hex.range(of: "(^[0-9A-Fa-f]{6}$)|(^[0-9A-Fa-f]{3}$)", options: .regularExpression) {
            if hex.lengthOfBytes(using: String.Encoding.utf8) == 3 {
                let redHex = hex.substring(to: hex.characters.index(hex.startIndex, offsetBy: 1))
                let greenHex = hex.substring(with: (hex.characters.index(hex.startIndex, offsetBy: 1) ..< hex.characters.index(hex.startIndex, offsetBy: 2)))
                let blueHex = hex.substring(from: hex.characters.index(hex.startIndex, offsetBy: 2))
                hex = redHex + redHex + greenHex + greenHex + blueHex + blueHex
            }
            let redHex = hex.substring(to: hex.characters.index(hex.startIndex, offsetBy: 2))
            let greenHex = hex.substring(with: (hex.characters.index(hex.startIndex, offsetBy: 2) ..< hex.characters.index(hex.startIndex, offsetBy: 4)))
            let blueHex = hex.substring(with: (hex.characters.index(hex.startIndex, offsetBy: 4) ..< hex.characters.index(hex.startIndex, offsetBy: 6)))
            
            var redInt:   CUnsignedInt = 0
            var greenInt: CUnsignedInt = 0
            var blueInt:  CUnsignedInt = 0
            
            Scanner(string: redHex).scanHexInt32(&redInt)
            Scanner(string: greenHex).scanHexInt32(&greenInt)
            Scanner(string: blueHex).scanHexInt32(&blueInt)
            
            self.init(red: CGFloat(redInt) / 255.0, green: CGFloat(greenInt) / 255.0, blue: CGFloat(blueInt) / 255.0, alpha: CGFloat(alpha))
        }
        else
        {
            self.init()
            return nil
        }
    }
    
    convenience init?(hex: Int, alpha: Float = 1) {
        let hexString = NSString(format: "%2X", hex)
        self.init(hexString: hexString as String, alpha: alpha)
    }
}

// MARK: animation layer

 class AnimationView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
     func angle(_ value: Double) -> CGFloat {
        return CGFloat((value) / 180.0 * M_PI)
    }
    
    func setup() {
        
    }
    
    func animated() {
        
    }
}

class CustomIndeficatorView: AnimationView {
    var circleLayer: CAShapeLayer!
    var maskLayer: CALayer!
    
    var circlePath: CGPath {
        let path = UIBezierPath()
        let startAngle = angle(0)
        let endAngle = angle(700)
        path.addArc(withCenter: CGPoint(x: defaultAnimaitonHeight / 2, y: defaultAnimaitonHeight / 2), radius: defaultAnimaitonHeight / 2.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        return path.cgPath
    }
    
    override func setup() {
        circleLayer = CAShapeLayer()
        circleLayer.position = CGPoint.zero
        circleLayer.path = circlePath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor(hexString: "00FF00")?.cgColor
        circleLayer.lineCap = kCALineCapRound
        circleLayer.lineWidth = 5.0
    }
    
    override func animated() {
        maskLayer = CALayer()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = CGRect(x: -4, y: -4, width: defaultAnimaitonHeight + 8, height: defaultAnimaitonHeight + 8)
        
        maskLayer.addSublayer(gradientLayer)
        maskLayer.mask = circleLayer
        self.layer.addSublayer(maskLayer)
        
        let roteAnimation = CABasicAnimation(keyPath: "transform.rotation")
        roteAnimation.fromValue = 0
        roteAnimation.toValue = 2.0 * M_PI
        roteAnimation.duration = 1
        roteAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        roteAnimation.repeatCount = HUGE
        roteAnimation.fillMode = kCAFillModeForwards
        roteAnimation.isRemovedOnCompletion = false
        gradientLayer.add(roteAnimation, forKey: "rote")
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 1.0
        animationGroup.repeatCount = HUGE
        animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animationGroup.fillMode = kCAFillModeForwards
        animationGroup.isRemovedOnCompletion = false
        
        let strokeStart = CABasicAnimation(keyPath: "strokeStart")
        strokeStart.fromValue = 0.025
        strokeStart.toValue = 0.525

        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.fromValue = 0.475
        strokeEnd.toValue = 0.975
        
        animationGroup.animations = [strokeStart, strokeEnd]
        self.circleLayer.add(animationGroup, forKey: "stroke")
    }
}

class successfulAnimation: AnimationView {
    
    var circleLayer: CAShapeLayer!
    var animateLayer: CAShapeLayer!
    
    var animatePath: CGPath {
        let path = UIBezierPath()
        let startAngle = angle(60)
        let endAngle = angle(200)
        path.addArc(withCenter: CGPoint(x: defaultAnimaitonHeight / 2, y: defaultAnimaitonHeight / 2), radius: defaultAnimaitonHeight / 2.0, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addLine(to: CGPoint(x: 36.0 - 10.0 ,y: 60.0 - 10.0))
        path.addLine(to: CGPoint(x: 85.0 - 20.0, y: 30.0 - 20.0))
        return path.cgPath
    }
    
    var circlePath: CGPath {
        let path = UIBezierPath()
        let startAngle = angle(0)
        let endAngle = angle(360)
        path.addArc(withCenter: CGPoint(x: defaultAnimaitonHeight / 2, y: defaultAnimaitonHeight / 2), radius: defaultAnimaitonHeight / 2.0, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        return path.cgPath
    }
    
    override func setup() {
        circleLayer = CAShapeLayer()
        circleLayer.position = CGPoint.zero
        circleLayer.path = circlePath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor(hexString: "F2A665")?.cgColor
        circleLayer.lineCap = kCALineCapRound
        circleLayer.lineWidth = 4.0
        
        animateLayer = CAShapeLayer()
        animateLayer.position = CGPoint.zero
        animateLayer.path = animatePath
        animateLayer.fillColor = UIColor.clear.cgColor
        animateLayer.strokeColor = UIColor.green.cgColor
        animateLayer.lineCap = kCALineCapRound
        animateLayer.lineWidth = 4.0
        animateLayer.actions = [
            "strokeStart": NSNull(),
            "strokeEnd": NSNull(),
            "transform": NSNull()
        ]
        
        self.layer.addSublayer(circleLayer)
        self.layer.addSublayer(animateLayer)
        animateLayer.strokeStart = 0.0
        animateLayer.strokeEnd = 0.0
    }
    
    override func animated() {
        let strokeStart = CABasicAnimation(keyPath: "strokeStart")
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        let facetor = 0.04
        strokeEnd.fromValue = 0.0
        strokeEnd.toValue = 0.95
        strokeEnd.duration = 10.0 * facetor
        strokeEnd.timingFunction = CAMediaTimingFunction(controlPoints: 0.3, 0.6, 0.8, 1.2)
        
        strokeStart.fromValue = 0.0
        strokeStart.toValue = 0.70
        strokeStart.duration = 7.0 * facetor
        strokeStart.beginTime = CACurrentMediaTime() + 3.0 * facetor
        strokeStart.fillMode = kCAFillModeBackwards
        strokeStart.timingFunction = CAMediaTimingFunction(controlPoints: 0.3, 0.6, 0.8, 1.2)
        
        animateLayer.strokeStart = 0.70
        animateLayer.strokeEnd = 0.95
        animateLayer.add(strokeEnd, forKey: "strokeEnd")
        animateLayer.add(strokeStart, forKey: "strokeStart")
        
        let strokeColor = CABasicAnimation(keyPath: "strokeColor")
        strokeColor.fromValue = UIColor(hexString: "F7D58B")?.cgColor
        strokeColor.toValue = UIColor(hexString: "F2A665")?.cgColor
        strokeColor.duration = 1.5
        strokeColor.repeatCount = HUGE
        strokeColor.autoreverses = true
        strokeColor.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        circleLayer.add(strokeColor, forKey: "strokeColor")
    }
}


class WarningAnimation: AnimationView {
    
    var circleLayer: CAShapeLayer!
    var animateLayer: CAShapeLayer!
    
    var animatePath: CGPath {
        let path = UIBezierPath()
        let startAngle = angle(90)
        let endAngle = angle(450)
        path.addArc(withCenter: CGPoint(x: defaultAnimaitonHeight / 2, y: defaultAnimaitonHeight / 2), radius: defaultAnimaitonHeight / 2, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        let length = defaultAnimaitonHeight / 1.5
        path.move(to: CGPoint(x: defaultAnimaitonHeight / 2, y: 15))
        path.addLine(to: CGPoint(x: defaultAnimaitonHeight / 2, y: length))
        path.move(to: CGPoint(x: defaultAnimaitonHeight / 2, y: length + 10))
        
        path.addArc(withCenter: CGPoint(x: defaultAnimaitonHeight / 2, y: length + 10), radius: 1.0, startAngle: angle(0), endAngle: angle(360), clockwise: false)
        
        return path.cgPath
    }
    
    var circlePath: CGPath {
        let path = UIBezierPath()
        let startAngle = angle(0)
        let endAngle = angle(360)
        path.addArc(withCenter: CGPoint(x: defaultAnimaitonHeight / 2, y: defaultAnimaitonHeight / 2), radius: defaultAnimaitonHeight / 2.0, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        return path.cgPath
    }
    
    override func setup() {
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor(hexString: "F2A665")?.cgColor
        circleLayer.lineCap = kCALineCapRound
        circleLayer.lineWidth = 4.0
        
        animateLayer = CAShapeLayer()
        animateLayer.path = animatePath
        animateLayer.fillColor = UIColor.clear.cgColor
        animateLayer.strokeColor = UIColor.yellow.cgColor
        animateLayer.lineCap = kCALineCapRound
        animateLayer.lineWidth = 4.0
        animateLayer.frame = CGRect(x: 0, y: 0, width: defaultAnimaitonHeight, height: defaultAnimaitonHeight)
        animateLayer.position = CGPoint(x: defaultAnimaitonHeight / 2, y: defaultAnimaitonHeight / 2)
        
        self.layer.addSublayer(circleLayer)
        self.layer.addSublayer(animateLayer)
        animateLayer.strokeStart = 0.0
        animateLayer.strokeEnd = 0.0
    }
    
    override func animated() {
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.fromValue = 0.0
        strokeEnd.toValue = 1.0
        strokeEnd.duration = 0.3
        strokeEnd.fillMode = kCAFillModeForwards
        strokeEnd.isRemovedOnCompletion = false
        strokeEnd.timingFunction = CAMediaTimingFunction(controlPoints: 0.3, 0.6, 0.8, 1.2)
        
        animateLayer.add(strokeEnd, forKey: "strokeEnd")
        
        let roteAnimation = CAKeyframeAnimation(keyPath: "transform")
        roteAnimation.beginTime = CACurrentMediaTime() + 0.3
        roteAnimation.duration =  0.3
        roteAnimation.values = [
            NSValue(caTransform3D: CATransform3DMakeRotation(angle(-30), 0, 0, 1)),
            NSValue(caTransform3D: CATransform3DMakeRotation(angle(30), 0, 0, 1)),
            NSValue(caTransform3D: CATransform3DMakeRotation(angle(-30), 0, 0, 1)),
            NSValue(caTransform3D: CATransform3DIdentity)
        ]
        roteAnimation.fillMode = kCAFillModeForwards
        roteAnimation.isRemovedOnCompletion = false
        animateLayer.add(roteAnimation, forKey: "rote")
        
        let strokeColor = CABasicAnimation(keyPath: "strokeColor")
        strokeColor.fromValue = UIColor(hexString: "F7D58B")?.cgColor
        strokeColor.toValue = UIColor(hexString: "F2A665")?.cgColor
        strokeColor.duration = 1.5
        strokeColor.repeatCount = HUGE
        strokeColor.autoreverses = true
        strokeColor.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        circleLayer.add(strokeColor, forKey: "strokeColor")
    }
}

class ErrorAnimation: AnimationView {
    
    var circleLayer: CAShapeLayer!
    var animateLayer: CAShapeLayer!
    
    var animatePath: CGPath {
        let path = UIBezierPath()
        
        let factor:CGFloat = defaultAnimaitonHeight / 5.0
        path.move(to: CGPoint(x: defaultAnimaitonHeight/2.0-factor,y: defaultAnimaitonHeight/2.0-factor))
        path.addLine(to: CGPoint(x: defaultAnimaitonHeight/2.0+factor,y: defaultAnimaitonHeight/2.0+factor))
        path.move(to: CGPoint(x: defaultAnimaitonHeight/2.0+factor,y: defaultAnimaitonHeight/2.0-factor))
        path.addLine(to: CGPoint(x: defaultAnimaitonHeight/2.0-factor,y: defaultAnimaitonHeight/2.0+factor))
        
        return path.cgPath
    }
    
    var circlePath: CGPath {
        let path = UIBezierPath()
        let startAngle = angle(0)
        let endAngle = angle(360)
        path.addArc(withCenter: CGPoint(x: defaultAnimaitonHeight / 2, y: defaultAnimaitonHeight / 2), radius: defaultAnimaitonHeight / 2.0, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        return path.cgPath
    }
    
    override func setup() {
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor(hexString: "F2A665")?.cgColor
        circleLayer.lineCap = kCALineCapRound
        circleLayer.lineWidth = 4.0
        circleLayer.frame = CGRect(x: 0, y: 0, width: defaultAnimaitonHeight, height: defaultAnimaitonHeight)
        circleLayer.position = CGPoint(x: defaultAnimaitonHeight / 2, y: defaultAnimaitonHeight / 2)
        
        animateLayer = CAShapeLayer()
        animateLayer.path = animatePath
        animateLayer.fillColor = UIColor.clear.cgColor
        animateLayer.strokeColor = UIColor.red.cgColor
        animateLayer.lineCap = kCALineCapRound
        animateLayer.lineWidth = 4.0
        animateLayer.frame = CGRect(x: 0, y: 0, width: defaultAnimaitonHeight, height: defaultAnimaitonHeight)
        animateLayer.position = CGPoint(x: defaultAnimaitonHeight / 2, y: defaultAnimaitonHeight / 2)
        
        self.layer.addSublayer(circleLayer)
        self.layer.addSublayer(animateLayer)
        
        var t = CATransform3DIdentity;
        t.m34 = 1.0 / -500.0;
        t = CATransform3DRotate(t, CGFloat(90.0 * M_PI / 180.0), 1, 0, 0);
        circleLayer.transform = t
        
        animateLayer.opacity = 0.0
    }
    
    override func animated() {
        var t = CATransform3DIdentity;
        t.m34 = 1.0 / -500.0;
        t = CATransform3DRotate(t, CGFloat(90.0 * M_PI / 180.0), 1, 0, 0);
        
        var t2 = CATransform3DIdentity;
        t2.m34 = 1.0 / -500.0;
        t2 = CATransform3DRotate(t2, CGFloat(-M_PI), 1, 0, 0);
        
        let animation = CABasicAnimation(keyPath: "transform")
        let time = 0.3
        animation.duration = time;
        animation.fromValue = NSValue(caTransform3D: t)
        animation.toValue = NSValue(caTransform3D:t2)
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        self.circleLayer.add(animation, forKey: "transform")
        
        var scale = CATransform3DIdentity;
        scale = CATransform3DScale(scale, 0.3, 0.3, 0)

        let crossAnimation = CABasicAnimation(keyPath: "transform")
        crossAnimation.duration = 0.3;
        crossAnimation.beginTime = CACurrentMediaTime() + time
        crossAnimation.fromValue = NSValue(caTransform3D: scale)
        crossAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0.8, 0.7, 2.0)
        crossAnimation.toValue = NSValue(caTransform3D:CATransform3DIdentity)
        animateLayer.add(crossAnimation, forKey: "scale")
        
        
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.duration = 0.3;
        fadeInAnimation.beginTime = CACurrentMediaTime() + time
        fadeInAnimation.fromValue = 0.3
        fadeInAnimation.toValue = 1.0
        fadeInAnimation.isRemovedOnCompletion = false
        fadeInAnimation.fillMode = kCAFillModeForwards
        animateLayer.add(fadeInAnimation, forKey: "opacity")
    }
}


class progressAnimation: AnimationView {
    
}


