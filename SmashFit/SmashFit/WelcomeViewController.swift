//
//  WelcomeViewController.swift
//  SmashFit
//
//  Created by Kudryatzhan Arziyev on 1/29/18.
//  Copyright © 2018 Kudryatzhan Arziyev. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func unwindToWelcomeView(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }

}

