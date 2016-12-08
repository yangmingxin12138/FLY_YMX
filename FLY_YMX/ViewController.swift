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
    var bird:UIImageView!
    var birdIsDown:Bool = true
    var velocity:Float = 0
    var birdTimer:Timer?
    var GG:Bool = false
    var score:UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.creatBackAndFloor()
        self.creatTimer()
        self.creatObstacle()
        self.creatBird()
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
    //创建障碍物(obstacle) 分数显示器
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
        self.score = UILabel(frame: CGRect(x: 30, y: 100, width: SCREEN_SIZE.width-60, height: 100))
        self.score?.text = "0"
        self.score?.font = UIFont(descriptor: UIFontDescriptor(), size: 70)
        self.score?.textColor = UIColor.white
        self.score?.textAlignment = .center
        self.view.addSubview(self.score!)
    }
    //创建小鸟
    func creatBird() {
        var images:[UIImage] = [UIImage]()
        for i in 1...3{
            let string = String(format: "bird%d.png",i)
            let image = UIImage(named: string)
            images.append(image!)
        }
        bird = UIImageView(frame: CGRect(x: 100, y: 200, width: 35, height: 35))
        bird.image = UIImage(named: "bird1.png")
        bird.animationImages = images
        bird.animationDuration = 0.5
        bird.animationRepeatCount = 0
        bird.startAnimating()
        bird.tag = 333
        self.view.addSubview(bird)
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
        self.birdTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(birdMove), userInfo: nil, repeats: true)
        //  self.bgTimer?.fireDate = NSDate.distantFuture
        self.obstacleTimer?.fireDate = NSDate.distantFuture
        //self.birdTimer?.fireDate = NSDate.distantFuture
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
        self.isHit()
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
                //加分判定
                if bird.frame.origin.x == topFrame.origin.x||bird.frame.origin.x == topFrame.origin.x+1 {
                    self.score?.text = String(Int(score!.text!)!+1)
                }
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
    //小鸟的移动
    func birdMove() {
        var frame = bird.frame
        let dist = ( (velocity * 0.02) + 9.8 * 0.02 * 0.02/2 ) * 150
        frame.origin.y += CGFloat(dist)
        velocity += 9.8 * 0.02
        bird.frame = frame
    }
    //死亡判定
    func isHit() {
        let obstacle1:UIView! = self.view.viewWithTag(202)
        let obstacle2:UIView! = self.view.viewWithTag(203)
        let obstacle3:UIView! = self.view.viewWithTag(204)
        let obstacle4:UIView! = self.view.viewWithTag(205)
        let obstacle5:UIView! = self.view.viewWithTag(206)
        let obstacle6:UIView! = self.view.viewWithTag(207)
        let floor1:UIView! = self.view.viewWithTag(102)
        let floor2:UIView! = self.view.viewWithTag(103)
        if  obstacle1.frame.intersects(bird.frame)||obstacle2.frame.intersects(bird.frame)||obstacle3.frame.intersects(bird.frame)||obstacle4.frame.intersects(bird.frame)||obstacle5.frame.intersects(bird.frame)||obstacle6.frame.intersects(bird.frame)||floor1.frame.intersects(bird.frame)||floor2.frame.intersects(bird.frame)||bird.frame.origin.y < -100 {
            self.gameOver()
            self.stop__()
            GG = true
        }
    }
    func birdUp() {
        velocity = -2.5
        /*var frame = self.bird.frame
        frame.origin.y -= 40
        UIView.animate(withDuration: 0.2, animations:{
            self.bird.frame = frame
        })*/
    }
    func gameOver() {
        let overImage = UIImage(named: "gameover2.png")
        let gameover = UIImageView(frame: CGRect(x: 30, y: 200, width: SCREEN_SIZE.width-60, height: 60))
        gameover.image = overImage
        gameover.tag = 666
        self.view.addSubview(gameover)
    }
    func reloadGame() {
        GG = false
        self.velocity = 0
        let gameover = self.view.viewWithTag(666)
        gameover?.removeFromSuperview()
        var frame = bird.frame
        frame.origin.y = 100
        bird.frame = frame
        for i in 1...3 {
            let obstacle1 = self.view.viewWithTag(200+i*2) as! UIImageView
            let obstacle2 = self.view.viewWithTag(201+i*2) as! UIImageView
            self.randomObstacle(topObstacle: obstacle1, bottomObstacle: obstacle2)
            obstacle1.frame.origin.x = SCREEN_SIZE.width + CGFloat(i)*OBSTACLE_DISTANCE
            obstacle2.frame.origin.x = SCREEN_SIZE.width + CGFloat(i)*OBSTACLE_DISTANCE
            
        }
        self.score?.text = "0"
    }
    func fire__ () {
        self.bgTimer?.fireDate = NSDate.distantPast
        self.obstacleTimer?.fireDate = NSDate.distantPast
        self.birdTimer?.fireDate = NSDate.distantPast
    }
    func stop__() {
        self.bgTimer?.fireDate = NSDate.distantFuture
        self.obstacleTimer?.fireDate = NSDate.distantFuture
        self.birdTimer?.fireDate = NSDate.distantFuture
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.fire__()
        if !GG {
            self.birdUp()
        } else {
            reloadGame()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

