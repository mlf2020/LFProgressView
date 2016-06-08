//
//  ViewController.swift
//  LFProgressView
//
//  Created by XieLibin on 16/6/3.
//  Copyright © 2016年 Menglingfeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    func hide(){
        
        LFProgressHUD.hideForView(self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func indicator(sender: AnyObject) {
        
        LFProgressHUD.showProgressHUDTo(view: self.view, progressMode: .Indicater)
        
        self.performSelector(#selector(self.hide), withObject: nil, afterDelay: 3)
    }

    
    @IBAction func largeIndicator(sender: AnyObject) {
        
        LFProgressHUD.showProgressHUDTo(view: self.view, progressMode: .IndicatorLarge)
        
        self.performSelector(#selector(self.hide), withObject: nil, afterDelay: 3)
    }
    
    @IBAction func text(sender: AnyObject) {
        
        LFProgressHUD.showMessage("hello world! oh! swift is so fantastic!", toView: self.view, withMode: .Text)
        
        self.performSelector(#selector(self.hide), withObject: nil, afterDelay: 3)
    }
    
    
    @IBAction func circle(sender: AnyObject) {
        LFProgressHUD.showProgressHUDTo(view: self.view, progressMode: .Circle)
        
        self.performSelector(#selector(self.hide), withObject: nil, afterDelay: 3)
    }
    
    
    @IBAction func custom(sender: AnyObject) {
        
        let view = UIView()
        view.bounds = CGRectMake(0, 0, 60, 60)
        
        let animate = CABasicAnimation(keyPath: "transform.rotation.z")
        animate.toValue = M_PI
        animate.repeatCount = Float.infinity
        animate.duration = 1
        animate.cumulative = true
        
        view.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        view.layer.addAnimation(animate, forKey: "transform.rotation.z")
        
        LFProgressHUD.showProgressHUDTo(view: self.view, progressMode: .Custom(view))
        
        
        self.performSelector(#selector(self.hide), withObject: nil, afterDelay: 3)
    }
    

    @IBAction func info(sender: AnyObject) {
        
        LFProgressHUD.showMessage("hello world! hello world！", toView: self.view, withMode: .IndicatorLarge)
        
        self.performSelector(#selector(self.hide), withObject: nil, afterDelay: 3)
    }
}

