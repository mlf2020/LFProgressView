# LFProgressView

This is a light HUD ,and easily to use

GET START

 ![image](http://github.com/mlf2020/LFProgressView/raw/master/snapshot/Snip20160608_20.png)
![image](http://github.com/mlf2020/LFProgressView/raw/master/snapshot/Snip20160608_21.png)
![image](http://github.com/mlf2020/LFProgressView/raw/master/snapshot/Snip20160608_22.png)
 
 you can use the HUD like this :
 
```java 
LFProgressHUD.showProgressHUDTo(view: self.view, progressMode: .Indicater) 
```
mode you can use as follows：
 
 ```java 
 enum LFProgressMode{
    case Circle
    case Indicater
    case IndicatorLarge
    case Text
    case Custom(UIView!)
}
```

and you can hide the HUD like this 

```java
LFProgressHUD.hideForView(self.view)
```


