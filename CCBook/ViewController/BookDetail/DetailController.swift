//
//  DetailController.swift
//  ubmAppleBookClone
//
//  Created by c.c on 2019/6/13.
//  Copyright © 2019 c.c. All rights reserved.
//

import UIKit

class DetailController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleClose(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
