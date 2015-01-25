//
//  TeamTomatoWizard.swift
//  teamodoro-ios
//
//  Created by Alexander Makarov on 25.01.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

import UIKit

let kTeamodoroAPICurrentNotification: String = "TeamodoroAPICurrentNotification"

let kGreenColor: UIColor = UIColor(red: 0, green: 211.0/255.0, blue: 67.0/255.0, alpha: 1)
let kYellowColor: UIColor = UIColor(red: 255.0/255.0, green: 128.0/255.0, blue: 0.0/255.0, alpha: 1)

class TeamTomatoWizard: NSObject {
    
    class var sharedInstance : TeamTomatoWizard {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : TeamTomatoWizard? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = TeamTomatoWizard()
        }
        return Static.instance!
    }

    class func current () {
        let urlPath: String = "http://teamodoro.sdfgh153.ru/api/current"
        var url: NSURL = NSURL(string: urlPath)!
        var request: NSURLRequest = NSURLRequest(URL: url)
        let queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(
            request,
            queue: queue,
            completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                var err: NSError
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(
                    data,
                    options: NSJSONReadingOptions.MutableContainers,
                    error: nil) as NSDictionary
                
                var tomato: Tomato = self.parseResponse(jsonResult)
                var userInfo = Dictionary<String, Tomato>()
                userInfo["userInfo"] = tomato
        
                NSNotificationCenter.defaultCenter().postNotificationName(kTeamodoroAPICurrentNotification, object: nil, userInfo: userInfo)
            })
    }
    
    private class func parseResponse(response: NSDictionary) -> Tomato {
        
        var tomato: Tomato = Tomato()
        
        if let stateString = (response["state"] as? NSDictionary)?["name"] as? String {
            let status = Status(rawValue: stateString)
            if status != nil {
                tomato.status = status!
            }
        }
        
        let curTime: AnyObject? = response["currentTime"]
        if let curTime = curTime as? Int {
            let curTimeInterval = NSTimeInterval(curTime)
            
            if let curStateOptionDict = (response["options"] as? NSDictionary)?[tomato.status.rawValue] as? NSDictionary {
                
                if let duration = curStateOptionDict["duration"] as? Int {
                    let durationInterval = NSTimeInterval(duration)
                    tomato.lostTime = durationInterval - curTimeInterval
                }
                if let colorString = curStateOptionDict["color"] as? String {
                    switch colorString {
                    case "white":
                        tomato.color = UIColor.whiteColor()
                    case "green":
                        tomato.color = kGreenColor
                    case "yellow":
                        tomato.color = kYellowColor
                    default:
                        tomato.color = UIColor.blackColor()
                        break
                    }
                }
            }
        }
        
        return tomato;
    }
}
