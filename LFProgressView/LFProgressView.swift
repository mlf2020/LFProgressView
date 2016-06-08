//
//  LFProgressHUD.swift
//  LFProgressHUD
//
//  Created by XieLibin on 16/6/3.
//  Copyright © 2016年 Menglingfeng. All rights reserved.
//

import UIKit


let progressLeft   : CGFloat  = 26
let progressRight             = progressLeft
let ProgressTop   : CGFloat   = 20
let progressMiddle : CGFloat  = 8
let infoLabelLeft  : CGFloat  = 16
let infoLabelRight            = infoLabelLeft
let infoLableBottom : CGFloat = 10
let radius : CGFloat          = 18

enum LFProgressMode{
    case Circle
    case Indicater
    case IndicatorLarge
    case Text
    case Custom(UIView!)
}


protocol Boundable {
    
    func getBounds() -> CGRect
}


extension CALayer : Boundable{

    func getBounds() -> CGRect {
        return self.bounds
    }
}

extension UIView :Boundable{
  
    func getBounds() -> CGRect {
        return self.bounds
    }
}

class LFProgressHUD: UIView {
    
    //MARK:properties
    var trackColor : UIColor?{
        get{
          return UIColor(CGColor: sharpLayer.strokeColor ?? UIColor.whiteColor().CGColor)
        }
        set{
           sharpLayer.strokeColor = newValue?.CGColor
        }
    }
    var backGroundColor : UIColor?{
        get{
          return containerView.backgroundColor
        }
        set{
           containerView.backgroundColor = newValue
        }
    }
    var progressMode :LFProgressMode = .Circle
    private var promptLabel = UILabel()
    private var sharpLayer = CAShapeLayer()
    private var indicatorView : UIView?
    private var containerView = UIView()
    
     class func lastWindow() -> UIWindow!{
        let windows = UIApplication.sharedApplication().windows
        
        for window in windows.reverse() {
            
            if window.isKindOfClass(UIWindow.self)  && (CGRectEqualToRect(window.bounds, UIScreen.mainScreen().bounds)){
            
               return window
            }
        }
        
        return UIApplication.sharedApplication().keyWindow!
    }
    
    
    
    class func showMessage(message : String?,toView view : UIView?,withMode mode : LFProgressMode)->LFProgressHUD{
    
        let hud = hudInit(view: view, withMode: mode)
        if message == nil {
            return hud
        }else{
            
            hud.promptLabel.text = message
        }
        
        return hud
    }
    
    class func showProgressHUDTo(view container : UIView?,progressMode mode : LFProgressMode) -> LFProgressHUD{
        
        switch mode {
        case .Text:
            return showMessage("", toView: container, withMode: .IndicatorLarge)
        default:
            return hudInit(view: container, withMode: mode)
        }
        
    }
    
    class func hudInit(view container : UIView?,withMode mode : LFProgressMode)->LFProgressHUD{
    
        let innerContainer = container ?? lastWindow()
        let hud = LFProgressHUD.init(withTrackColor: UIColor.whiteColor(), backGroundColor: UIColor.blackColor().colorWithAlphaComponent(0.5), progressMode: mode, containerView: innerContainer)
        return hud
    }
    
    
    class func hideForView(view : UIView?) ->Bool{
        
        let innerContainer = view ?? lastWindow()
        let hud = hudForView(innerContainer)
        if let innerHud = hud{
            innerHud.removeFromSuperview()
            return true
        }
        return false
    }
    
    
    class func hudForView(view : UIView?) ->LFProgressHUD?{
    
       let subViews = view?.subviews.reverse()
        guard let wappedSubViews = subViews else{
           return nil
        }
        for view in wappedSubViews {
            if let hud = view as? LFProgressHUD{
               return hud
            }
        }
        return nil
    }
    
    
    
    init(withTrackColor : UIColor,backGroundColor backColor : UIColor,progressMode mode : LFProgressMode,containerView container : UIView!){
        
        super.init(frame: CGRectZero)
        self.trackColor = withTrackColor
        self.backGroundColor = backColor
        self.progressMode = mode
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
        addSubview(containerView)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.bounds
        container.addSubview(self)
        
        setup(withMode: mode)
}
    
    
    
    
    func setup(withMode mode : LFProgressMode){
        setupLabel()
        switch mode {
        case .Circle:     circleView()
        case .Indicater:  indicaterView()
        case .IndicatorLarge: indicatorLargeView()
        case .Text : text()
        case .Custom(let customView): self.customView(customView)
        }
        
        indicatorView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    
    func setupLabel() {
        promptLabel.font = UIFont.boldSystemFontOfSize(14)
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        promptLabel.textAlignment = .Center
        promptLabel.numberOfLines = 0
        promptLabel.textColor = UIColor.whiteColor()
        containerView.addSubview(promptLabel)
    }
    

    func circleView(){
        
        if let view = self.indicatorView{
           view.removeFromSuperview()
           sharpLayer.removeFromSuperlayer()
        }
        
        
        sharpLayer.bounds = CGRectMake(0, 0, radius * 2 + 4, radius * 2 + 4)
        
       let layerCenter = CGPointMake(sharpLayer.bounds.size.width * 0.5, sharpLayer.bounds.size.height * 0.5)
       let center = CGPointMake(progressLeft + layerCenter.x, ProgressTop + layerCenter.y)
        sharpLayer.position = center
        containerView.layer.addSublayer(sharpLayer)
//        sharpLayer.backgroundColor = UIColor.yellowColor().CGColor
     
       let bezierPath = UIBezierPath(arcCenter: layerCenter, radius: radius, startAngle: CGFloat(M_PI_2 * 3), endAngle: CGFloat(M_PI * 7 / 4), clockwise: false)

        sharpLayer.fillColor = nil
        sharpLayer.lineCap = kCALineCapRound
        sharpLayer.lineWidth = 4.5
        
        sharpLayer.path = bezierPath.CGPath
        

        let animate = CABasicAnimation(keyPath: "transform.rotation.z")
        animate.fromValue = 0
        animate.toValue = CGFloat(M_PI)
        animate.duration = 0.75
        animate.repeatCount = Float.infinity
        animate.cumulative = true
//        animate.removeOnCompletion = false
        
        sharpLayer.addAnimation(animate, forKey: "rotation")
    }
    
    func indicaterView(){
        
        if let view = self.indicatorView{
            view.removeFromSuperview()
            sharpLayer.removeFromSuperlayer()
        }
        
        indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .White)
        
        if let wapped = indicatorView as? UIActivityIndicatorView{
            containerView.addSubview(wapped)
            wapped.startAnimating()
        }
    }
    
    func indicatorLargeView()  {
        
        if let view = self.indicatorView{
            view.removeFromSuperview()
            sharpLayer.removeFromSuperlayer()
        }
        
        indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        if let wapped = indicatorView as? UIActivityIndicatorView{
            containerView.addSubview(wapped)
            wapped.startAnimating()
        }
        
    }
    
    
    func text() {
        
        if let view = self.indicatorView{
            view.removeFromSuperview()
            sharpLayer.removeFromSuperlayer()
        }
        
        indicatorView = nil
    }

    
    func customView(view: UIView!){
        if let view = self.indicatorView{
            view.removeFromSuperview()
            sharpLayer.removeFromSuperlayer()
        }
        indicatorView = view
        if let wapped = indicatorView {
            containerView.addSubview(wapped)
        }
    }
    
    
    func updateConstraint(mode : LFProgressMode){

        self.setNeedsUpdateConstraints()
    }
    
    
    override func updateConstraints() {
        
        self.removeConstraints(self.constraints)
        containerView.removeConstraints(containerView.constraints)
        promptLabel.hidden = !(promptLabel.text?.characters.count > 0)

        var size = CGSizeZero
        var labelHeightConstraints : NSLayoutConstraint?
        var labelWidth : CGFloat = 0
        
        if !promptLabel.hidden {
            //根据文字计算宽高
            size = promptLabel.sizeThatFits(CGSizeMake(self.frame.width - infoLabelLeft - infoLabelRight, 60))
            let labelLayoutH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(infoLabelLeft)-[promptLabel]-(infoLabelRight)-|", options: [], metrics: ["infoLabelLeft" : infoLabelLeft,"infoLabelRight" : infoLabelRight], views: ["promptLabel" : promptLabel])
            labelWidth = size.width
            let height = size.height

            labelHeightConstraints = NSLayoutConstraint.init(item: promptLabel, attribute: .Height, relatedBy: .Equal, toItem: containerView, attribute: .Height, multiplier: 0, constant: height)
            let labelBottom = NSLayoutConstraint.init(item: promptLabel, attribute: .Bottom, relatedBy: .Equal, toItem: containerView, attribute: .Bottom, multiplier: 1, constant: -infoLableBottom)
            
            containerView.addConstraints(labelLayoutH)
            containerView.addConstraints([labelHeightConstraints!,labelBottom])
        }

        var containerWidth : CGFloat  = 0
        var containerHeight : CGFloat = 0
        
        func sizeWithView<T : Boundable>(anyView: T){

            if let height = labelHeightConstraints{
                
                if anyView.getBounds().width > labelWidth{
                    containerWidth = anyView.getBounds().width + progressLeft + progressRight
                }else{
                    containerWidth = labelWidth + infoLabelLeft + infoLabelRight
                }
                
                if indicatorView == nil{
                  containerHeight = height.constant + 2 * infoLableBottom
                }else{
                  containerHeight = anyView.getBounds().height + ProgressTop + progressMiddle + height.constant + infoLableBottom
                }
                
            }else{
                containerWidth = anyView.getBounds().width + progressLeft + progressRight
                containerHeight = anyView.getBounds().height + 2 * ProgressTop
            }
        }
        
        var  viewDic : [String : UIView] = promptLabel.hidden ? [:] : ["bottomView" : promptLabel]
        
        let vlf = promptLabel.hidden ? "V:|-(ProgressTop)-[view]-(ProgressTop)-|" : "V:|-(infoLableBottom)-[view]-(6)-[bottomView]-|"
        switch self.progressMode {
        case .Circle:

            sizeWithView(sharpLayer)

            if let _ = labelHeightConstraints{
                sharpLayer.position = CGPointMake(containerWidth * 0.5, containerHeight * 0.5 - progressMiddle)
            }

        case .Indicater,.IndicatorLarge:
            guard let view = indicatorView else{
               return
            }
            let indicaterH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(progressLeft)-[view]-(progressRight)-|", options: [], metrics: ["progressLeft" : progressLeft,"progressRight" : progressRight], views: ["view" : view])
            viewDic.updateValue(view, forKey: "view")
        
            var indicaterV = NSLayoutConstraint.constraintsWithVisualFormat(vlf, options: [], metrics: ["ProgressTop" : ProgressTop,"progressMiddle" : progressMiddle,"infoLableBottom" : infoLableBottom], views: viewDic)
     
            indicaterV.removeLast()
            containerView.addConstraints(indicaterH)
            containerView.addConstraints(indicaterV)

            sizeWithView(view)
            
        case .Text:
            sizeWithView(promptLabel)
        case .Custom(let view):
            
            sizeWithView(view)
            let left = (containerWidth - view.bounds.width) * 0.5
            let customViewH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(left)-[view]-(left)-|", options: [], metrics: ["left" : left], views: ["view" : view])
            
            viewDic.updateValue(view, forKey: "view")
            let height = view.bounds.height
            let customViewV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(ProgressTop)-[view(height)]", options: [], metrics: ["ProgressTop" : ProgressTop,"height" : height], views: viewDic)
            
            containerView.addConstraints(customViewH)
            containerView.addConstraints(customViewV)

            
            
        }

        //container
        let centerXLayout = NSLayoutConstraint.init(item: containerView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
        let centerYLayout = NSLayoutConstraint.init(item: containerView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0)
        let widthLayout  = NSLayoutConstraint.init(item: containerView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 0, constant: containerWidth)
        let heightLayout  = NSLayoutConstraint.init(item: containerView, attribute: .Height, relatedBy: .Equal, toItem: self, attribute:.Height, multiplier: 0, constant: containerHeight)
        self.addConstraints([centerXLayout,centerYLayout,widthLayout,heightLayout])
        
        super.updateConstraints()
        
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
