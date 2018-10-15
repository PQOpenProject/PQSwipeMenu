//
//  ListViewController.swift
//  PQSwipeMenu
//
//  Created by 盘国权 on 2018/10/15.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    class func laodSB() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dddddSwitch(_ sender: UISwitch) {
        
    }
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        print(#function, sender.isOn)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
