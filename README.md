# WbqDanMuKit
一款高仿bilibili弹幕的库

##由来
是这样的，市面上的弹幕库有很多，安卓就有著名的Bilibili/DanmakuFlameMaster。
但是IOS一直都没有非常方便的弹幕库，我刚开始在自己的项目中用的是IOS点赞排名第一的unash/BarrageRenderer，作者非常牛逼，逻辑也非常独到，但是当具体用的时候，我个人认为我用起来不是很方便，而且有一定的BUG，参考了很多前人写得代码之后，我决定自己写一个弹幕库。

###先来看看效果
![image](https://github.com/WangBingQuan1992/WBQSlideMusicPlayer/blob/master/effect.gif)

我仔细看了bilibili的弹幕，市面上很多的demo都不是自动布局，但是bilibili的视频横竖屏都很自然的显示，因此决定用autolayout，而放弃用frame写。

通过改写轨道的范围 来控制上方下方显示，

<pre><code>这是一个代码区块。
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