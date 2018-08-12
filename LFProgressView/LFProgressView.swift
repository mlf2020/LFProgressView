//
//  LFProgressHUD.swift
//  LFProgressHUD
//
//  Created by Menglingfeng on 16/6/3.
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
            return UIColor(cgColor: sharpLayer.strokeColor ?? UIColor.white.cgColor)
        }
        set{
            sharpLayer.strokeColor = newValue?.cgColor
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
    lazy private var containerView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
     class func lastWindow() -> UIWindow!{
        let windows = UIApplication.shared.windows
        
        for window in windows.reversed() {
            
            if window.isKind(of: UIWindow.self)  && (window.bounds.equalTo(UIScreen.main.bounds)){
               return window
            }
        }
        
        return UIApplication.shared.keyWindow!
    }
    
    
    @discardableResult
    class func showMessage(message : String?,toView view : UIView?,withMode mode : LFProgressMode)->LFProgressHUD{
    
        let hud = hudInit(view: view, withMode: mode)
        if message == nil {
            return hud
        }else{
            
            hud.promptLabel.text = message
        }
        
        return hud
    }
    
    @discardableResult
    class func showProgressHUDTo(view container : UIView?,progressMode mode : LFProgressMode) -> LFProgressHUD{
        
        switch mode {
        case .Text:
            return showMessage(message: "", toView: container, withMode: .IndicatorLarge)
        default:
            return hudInit(view: container, withMode: mode)
        }
        
    }
    
    class func hudInit(view container : UIView?,withMode mode : LFProgressMode)->LFProgressHUD{
    
        hideForView(view: container)
        let innerContainer = container ?? lastWindow()
        let hud = LFProgressHUD.init(withTrackColor: UIColor.white, backGroundColor: UIColor.black.withAlphaComponent(0.5), progressMode: mode, containerView: innerContainer)
        return hud
    }
    
    
    @discardableResult
    class func hideForView(view : UIView?) ->Bool{
        
        let innerContainer = view ?? lastWindow()
        let hud = hudForView(view: innerContainer)
        if let innerHud = hud{
            innerHud.removeFromSuperview()
            return true
        }
        return false
    }
    
    
    class func hudForView(view : UIView?) ->LFProgressHUD?{
    
        let subViews = view?.subviews.reversed()
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
        
        super.init(frame: .zero)
        self.autoresizingMask = [.flexibleBottomMargin,.flexibleWidth,.flexibleHeight,.flexibleTopMargin,.flexibleLeftMargin,.flexibleRightMargin]
        self.trackColor = withTrackColor
        self.backGroundColor = backColor
        self.progressMode = mode
        addSubview(containerView)

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
        case .Custom(let customView): self.customView(view: customView)
        }
        
        indicatorView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    
    func setupLabel() {
        promptLabel.font = UIFont.boldSystemFont(ofSize: 14)
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        promptLabel.textAlignment = .center
        promptLabel.numberOfLines = 0
        promptLabel.textColor = UIColor.white
        containerView.addSubview(promptLabel)
    }
    

    func circleView(){
        
        if let view = self.indicatorView{
           view.removeFromSuperview()
           sharpLayer.removeFromSuperlayer()
        }
        
        
        sharpLayer.bounds = CGRect(x: 0, y: 0, width: radius * 2 + 4, height: radius * 2 + 4)
        
       let layerCenter = CGPoint(x: sharpLayer.bounds.size.width * 0.5, y: sharpLayer.bounds.size.height * 0.5)
        let center = CGPoint(x:progressLeft + layerCenter.x, y:ProgressTop + layerCenter.y)
        sharpLayer.position = center
        containerView.layer.addSublayer(sharpLayer)
//        sharpLayer.backgroundColor = UIColor.yellowColor().CGColor
     
       let bezierPath = UIBezierPath(arcCenter: layerCenter, radius: radius, startAngle: CGFloat.pi / 2 * 3, endAngle: CGFloat.pi * 7 / 4, clockwise: false)

        sharpLayer.fillColor = nil
        sharpLayer.lineCap = kCALineCapRound
        sharpLayer.lineWidth = 4.5
        
        sharpLayer.path = bezierPath.cgPath
        

        let animate = CABasicAnimation(keyPath: "transform.rotation.z")
        animate.fromValue = 0
        animate.toValue = CGFloat.pi
        animate.duration = 0.75
        animate.repeatCount = Float.infinity
        animate.isCumulative = true
//        animate.removeOnCompletion = false
        
        sharpLayer.add(animate, forKey: "rotation")
    }
    
    func indicaterView(){
        
        if let view = self.indicatorView{
            view.removeFromSuperview()
            sharpLayer.removeFromSuperlayer()
        }
        
        indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        
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
        
        indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
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
        promptLabel.isHidden = !((promptLabel.text?.count ?? 0) > 0)

        var size = CGSize.zero
        var labelHeightConstraints : NSLayoutConstraint?
        var labelWidth : CGFloat = 0
        
        if !promptLabel.isHidden {
            //根据文字计算宽高
            size = promptLabel.sizeThatFits(CGSize(width: self.frame.width - infoLabelLeft - infoLabelRight, height:60))
            let labelLayoutH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(infoLabelLeft)-[promptLabel]-(infoLabelRight)-|", options: [], metrics: ["infoLabelLeft" : infoLabelLeft,"infoLabelRight" : infoLabelRight], views: ["promptLabel" : promptLabel])
            labelWidth = size.width
            let height = size.height

            labelHeightConstraints = NSLayoutConstraint.init(item: promptLabel, attribute: .height, relatedBy: .equal, toItem: containerView, attribute: .height, multiplier: 0, constant: height)
            let labelBottom = NSLayoutConstraint.init(item: promptLabel, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: -infoLableBottom)
            
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
        
        var  viewDic : [String : UIView] = promptLabel.isHidden ? [:] : ["bottomView" : promptLabel]
        
        let vlf = promptLabel.isHidden ? "V:|-(ProgressTop)-[view]-(ProgressTop)-|" : "V:|-(infoLableBottom)-[view]-(6)-[bottomView]-|"
        switch self.progressMode {
        case .Circle:

            sizeWithView(anyView: sharpLayer)

            if let _ = labelHeightConstraints{
                sharpLayer.position = CGPoint(x:containerWidth * 0.5, y:containerHeight * 0.5 - progressMiddle)
            }

        case .Indicater,.IndicatorLarge:
            guard let view = indicatorView else{
               return
            }
            let indicaterH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(progressLeft)-[view]-(progressRight)-|", options: [], metrics: ["progressLeft" : progressLeft,"progressRight" : progressRight], views: ["view" : view])
            viewDic.updateValue(view, forKey: "view")
        
            var indicaterV = NSLayoutConstraint.constraints(withVisualFormat: vlf, options: [], metrics: ["ProgressTop" : ProgressTop,"progressMiddle" : progressMiddle,"infoLableBottom" : infoLableBottom], views: viewDic)
     
            indicaterV.removeLast()
            containerView.addConstraints(indicaterH)
            containerView.addConstraints(indicaterV)

            sizeWithView(anyView: view)
            
        case .Text:
            sizeWithView(anyView: promptLabel)
        case .Custom(let view):
            
            sizeWithView(anyView: view)
            let left = (containerWidth - view.bounds.width) * 0.5
            let customViewH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(left)-[view]-(left)-|", options: [], metrics: ["left" : left], views: ["view" : view])
            
            viewDic.updateValue(view, forKey: "view")
            let height = view.bounds.height
            let customViewV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(ProgressTop)-[view(height)]", options: [], metrics: ["ProgressTop" : ProgressTop,"height" : height], views: viewDic)
            
            containerView.addConstraints(customViewH)
            containerView.addConstraints(customViewV)

            
            
        }

        //container
        let centerXLayout = NSLayoutConstraint.init(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYLayout = NSLayoutConstraint.init(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let widthLayout  = NSLayoutConstraint.init(item: containerView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: containerWidth)
        let heightLayout  = NSLayoutConstraint.init(item: containerView, attribute: .height, relatedBy: .equal, toItem: self, attribute:.height, multiplier: 0, constant: containerHeight)
        self.addConstraints([centerXLayout,centerYLayout,widthLayout,heightLayout])
        
        super.updateConstraints()
        
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
