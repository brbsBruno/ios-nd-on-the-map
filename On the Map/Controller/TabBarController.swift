//
//  MainTabViewController.swift
//  On the Map
//
//  Created by Bruno Barbosa on 20/01/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "userSession")
        userDefaults.synchronize()
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        print("refresh pressed")
    }
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        print("add pressed")
    }
    
}
