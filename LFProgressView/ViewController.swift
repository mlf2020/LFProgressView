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
    
    @objc func hide(){
        
        LFProgressHUD.hideForView(view: self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func indicator(sender: AnyObject) {
        
        LFProgressHUD.showProgressHUDTo(view: self.view, progressMode: .Indicater)
        
        self.perform(#selector(self.hide), with: nil, afterDelay: 3)
    }

    
    @IBAction func largeIndicator(sender: AnyObject) {
        
        LFProgressHUD.showProgressHUDTo(view: self.view, progressMode: .IndicatorLarge)
        
        self.perform(#selector(self.hide), with: nil, afterDelay: 3)
    }
    
    @IBAction func text(sender: AnyObject) {
        
        LFProgressHUD.showMessage(message: "hello world! oh! swift is so fantastic!", toView: self.view, withMode: .Text)
        
        self.perform(#selector(self.hide), with: nil, afterDelay: 3)
    }
    
    
    @IBAction func circle(sender: AnyObject) {
        LFProgressHUD.showProgressHUDTo(view: self.view, progressMode: .Circle)
        
        self.perform(#selector(self.hide), with: nil, afterDelay: 3)
    }
    
    
    @IBAction func custom(sender: AnyObject) {
        
        let view = UIView()
        view.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        
        let animate = CABasicAnimation(keyPath: "transform.rotation.z")
        animate.toValue = Double.pi
        animate.repeatCount = Float.infinity
        animate.duration = 1
        animate.isCumulative = true
        
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        view.layer.add(animate, forKey: "transform.rotation.z")
        
        LFProgressHUD.showProgressHUDTo(view: self.view, progressMode: .Custom(view))
        
        
        self.perform(#selector(self.hide), with: nil, afterDelay: 3)
    }
    

    @IBAction func info(sender: AnyObject) {
        
        LFProgressHUD.showMessage(message: "hello world! hello world！", toView: self.view, withMode: .IndicatorLarge)
        
        self.perform(#selector(self.hide), with: nil, afterDelay: 3)
    }
}

