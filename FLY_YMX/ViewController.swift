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
    var bgTimer:Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.creatBackAndFloor()
        self.creatTimer()
        
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
    //定时器创建
    func creatTimer() {
        //背景定时器
        self.bgTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(backGroundMove), userInfo: nil, repeats: true)
        self.bgTimer?.fireDate = NSDate.distantFuture
    }
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
    func fire__ () {
        self.bgTimer?.fireDate = NSDate.distantPast
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.fire__()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

