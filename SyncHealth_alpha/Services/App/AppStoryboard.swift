//
//  AppStoryboard.swift
//  SyncHealth_alpha
//
//  Created by Roger Eduardo Vazquez Tuz on 6/1/20.
//  Copyright © 2020 Roger Eduardo Vazquez Tuz. All rights reserved.
//

import Foundation
import UIKit

enum AppStoryboard: String {
    
    case Login = "Login"
    case Home = "Home"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass: T.Type, function: String = #function, line: Int = #line, file: String = #file) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
}

