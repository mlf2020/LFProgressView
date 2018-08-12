# LFProgressView

This is a light HUD ,and easily to use

GET START

![](https://github.com/mlf2020/LFProgressView/blob/master/hud.gif)
 ![LFProgressView](https://github.com/mlf2020/LFProgressView/blob/master/1.png)![LFProgressView](https://github.com/mlf2020/LFProgressView/blob/master/2.png)![LFProgressView](https://github.com/mlf2020/LFProgressView/blob/master/3.png)
 
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


