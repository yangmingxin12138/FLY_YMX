//
//  ViewController.swift
//  FLY_YMX
//
//  Created by yangmingxin on 16/12/7.
//  Copyright © 2016年 yangmingxin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let SCREEN_SIZE = UIScreen.main.bounds
    let FLOOR_HEIGHT:CGFloat = 100
    let OBSTACLE_DISTANCE:CGFloat =  ( UIScreen.main.bounds.width*2 - 54*3)/3 + 54
    let OBSTACLE_SPACE:CGFloat = 100
    var bgTimer:Timer?
    var obstacleTimer:Timer?
    var temp = true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        self.creatBackAndFloor()
        self.creatTimer()
        self.creatObstacle()
    }
    /// 创建 背景、地面
    func creatBackAndFloor() {
        let bgImg = UIImage(named: "bg.jpg")
        let backGround:UIImageView = UIImageView(frame: SCREEN_SIZE)
        backGround.image = bgImg
        let backImg = UIImage(named: "03.png")
        let backImage1:UIImageView = UIImageView(frame: CGRect(x: 0, y: SCREEN_SIZE.height - FLOOR_HEIGHT, width: SCREEN_SIZE.width, height: FLOOR_HEIGHT))
        let backImage2:UIImageView = UIImageView(frame:CGRect(x: SCREEN_SIZE.width, y: SCREEN_SIZE.height - FLOOR_HEIGHT, width: SCREEN_SIZE.width+1, height: FLOOR_HEIGHT) )
        backImage1.image = backImg
        backImage2.image = backImg
        backGround.tag = 101
        backImage1.tag = 102
        backImage2.tag = 103
        self.view.addSubview(backGround)
        self.view.addSubview(backImage1)
        self.view.addSubview(backImage2)
    }
    //创建障碍物(obstacle)
    func creatObstacle(){
        let obstacle1 = UIImage(named: "04.png")
        let obstacle2 = UIImage(named: "05.png")
        var topObstacle:UIImageView?
        var bottomObstacle:UIImageView?
        for i in 1...3{
            topObstacle = UIImageView(frame: CGRect(x: SCREEN_SIZE.width + OBSTACLE_DISTANCE*CGFloat(i), y: -SCREEN_SIZE.height, width: 54, height: SCREEN_SIZE.height))
            bottomObstacle = UIImageView(frame: CGRect(x: SCREEN_SIZE.width + OBSTACLE_DISTANCE*CGFloat(i), y: 0, width: 54, height: SCREEN_SIZE.height))
            topObstacle?.image = obstacle1
            bottomObstacle?.image = obstacle2
            randomObstacle(topObstacle: topObstacle!, bottomObstacle: bottomObstacle!)
            topObstacle?.tag = 200 + i*2
            bottomObstacle?.tag = 201 + i*2
            if let bgImage = self.view.viewWithTag(101) {
                self.view.insertSubview(topObstacle!, aboveSubview: bgImage)
                self.view.insertSubview(bottomObstacle!, aboveSubview: bgImage)
            }
        }
    }
    //随机障碍物高度和距离
   func randomObstacle(topObstacle:UIImageView,bottomObstacle:UIImageView){
        let distance = CGFloat(arc4random()%100) + OBSTACLE_SPACE
        let height = CGFloat(arc4random()%100+200)
        var frame = topObstacle.frame
        frame.origin.y = -SCREEN_SIZE.height + height
        topObstacle.frame = frame
        frame = bottomObstacle.frame
        frame.origin.y = distance + height
        bottomObstacle.frame = frame
    }
    //定时器创建
    func creatTimer() {
        //背景定时器
        self.bgTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(backGroundMove), userInfo: nil, repeats: true)
        self.obstacleTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(obstacleMove), userInfo: nil, repeats: true)	
        self.bgTimer?.fireDate = NSDate.distantFuture
        self.obstacleTimer?.fireDate = NSDate.distantFuture
    }
    //背景移动
    func backGroundMove(){
        let floorView1 = self.view.viewWithTag(102)
        let floorView2 = self.view.viewWithTag(103)
        var frame = floorView1?.frame
        if frame!.origin.x <= -SCREEN_SIZE.width {
            frame?.origin.x = SCREEN_SIZE.width
        }else {
            frame?.origin.x -= 1
        }
        floorView1?.frame = frame!
        frame = floorView2?.frame
        if frame!.origin.x <= -SCREEN_SIZE.width {
            frame?.origin.x = SCREEN_SIZE.width
        } else {
            frame?.origin.x -= 1
        }
        floorView2?.frame = frame!
    }
    //障碍物移动
    func obstacleMove(){
        for i in 1...3 {
            let topView = self.view.viewWithTag(i*2+200) as! UIImageView
            let bottomView = self.view.viewWithTag(i*2+201) as! UIImageView
            var topFrame = topView.frame
            var bottomFrame = bottomView.frame
                if topFrame.origin.x > -SCREEN_SIZE.width {
                    topFrame.origin.x -= 2
                    bottomFrame.origin.x -= 2
                    
                    topView.frame = topFrame
                    bottomView.frame = bottomFrame
                }
                else {
                    topFrame.origin.x = SCREEN_SIZE.width
                    bottomFrame.origin.x = SCREEN_SIZE.width
                    
                    topView.frame = topFrame
                    bottomView.frame = bottomFrame
                    self.randomObstacle(topObstacle: topView, bottomObstacle: bottomView)
                }
        }
    }
    func fire__ () {
        self.bgTimer?.fireDate = NSDate.distantPast
        self.obstacleTimer?.fireDate = NSDate.distantPast
    }
    func stop__() {
        self.bgTimer?.fireDate = NSDate.distantFuture
        self.obstacleTimer?.fireDate = NSDate.distantFuture
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if temp {
            self.fire__()
        }else{
            self.stop__()
            
        }
        temp = !temp
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

