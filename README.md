# WbqDanMuKit
一款高仿bilibili弹幕的库

##由来
是这样的，市面上的弹幕库有很多，安卓就有著名的Bilibili/DanmakuFlameMaster。
但是IOS一直都没有非常方便的弹幕库，我刚开始在自己的项目中用的是IOS点赞排名第一的unash/BarrageRenderer，作者非常牛逼，逻辑也非常独到，但是当具体用的时候，我个人认为我用起来不是很方便，而且有一定的BUG，参考了很多前人写得代码之后，我决定自己写一个弹幕库。

###先来看看效果
![image](https://github.com/Wbqqqq/WbqDanMuKit/blob/master/Effect.gif)

我仔细看了bilibili的弹幕，市面上很多的demo都不是自动布局，但是bilibili的视频横竖屏都很自然的显示，因此决定用autolayout，而放弃用frame写。

通过改写轨道的范围 来控制上方下方显示，

<pre><code>
- (IBAction)topDisplay:(id)sender {
    
    //上方下方显示 我这里用起始轨道和结束轨道来控制，但是两个值都不能大于最大的轨道数
    self.xibView.NormalStartIndex = 0;
    self.xibView.NormalEndIndex = 4;
 
}

- (IBAction)bottomDisPlay:(id)sender{
    
    self.xibView.NormalStartIndex = 4;
    self.xibView.NormalEndIndex = 8;
    
}
</code></pre>


具体使用在demo注释还是蛮详细的。

##联系方式

我的邮箱：353351363@qq.com. 同样是我的QQ。 如果什么BUG、建议的话，在Issues向我提就好啦。 

##PS
关于思路，IOS自带的动画效果很好，弹幕的暂停和继续非常方便,只要弹幕不爆炸，基本能够保持不失帧。但是有一点,就是在NavigationController的手动pop滑动中 , Animation是会停滞不工作的。 关于这一点，我网上查了很多资料，基本没有看到什么解决办法，虽然FaceBook的pop 能够完美解决这个问题 ， 但是关于动画的暂停和继续这块，我还是没有找到很合适的解决方法，可能是自己能力不够 。 所以关于这个问题 我之后会再仔细研究的，如果有同学有好的解决方法，也请希望能告诉我，感谢。 (*^__^*)  






