//
//  ClockViewController.swift
//  teamodoro-ios
//
//  Created by Alexander Makarov on 25.01.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

import UIKit

class ClockViewController: UIViewController {

    var timeLabel : UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didReceiveAPIResponce:",
            name: kTeamodoroAPICurrentNotification,
            object:
            nil)
        
        self.title = "Teamodoro"
        
        timeLabel.frame = self.view.bounds
        timeLabel.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        timeLabel.text = "--:--"
        timeLabel.textColor = UIColor.blackColor()
        timeLabel.textAlignment = NSTextAlignment.Center
        timeLabel.font = UIFont.boldSystemFontOfSize(75.0)
        self.view.addSubview(timeLabel)
        
        self.updateTime()
        var timer = NSTimer.scheduledTimerWithTimeInterval(
            1.0,
            target: self,
            selector: "updateTime",
            userInfo: nil,
            repeats: true)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func didReceiveAPIResponce(notification: NSNotification) {
        let userInfo: Dictionary<String, Tomato!> = notification.userInfo as! Dictionary<String, Tomato!>
        let tomato: Tomato = userInfo["userInfo"]!

        dispatch_async(dispatch_get_main_queue(), {
            self.timeLabel.text = self.textLostTime(tomato.lostTime) as String
            self.timeLabel.textColor = tomato.color
            self.timeLabel.setNeedsDisplay()
        })
    }
    
    func updateTime() {
        TeamTomatoWizard.current()
    }
    
    private func textLostTime(lostTime: Double) -> NSString {
        var minutes = lostTime / 60
        var seconds = lostTime % 60
        
        return NSString(format: "%d:%d", (NSInteger)(floor(minutes)), (NSInteger)(seconds))
    }
}
