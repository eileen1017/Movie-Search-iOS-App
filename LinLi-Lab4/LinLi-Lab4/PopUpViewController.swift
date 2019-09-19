//
//  PopUpViewController.swift
//  LinLi-Lab4
//
//  Created by Lin Li on 10/21/18.
//  Copyright © 2018 Lin Li. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    
    var overviewString: String?
    @IBOutlet weak var overviewLabel: UILabel!
    @IBAction func closePopUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overviewLabel.text = overviewString
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
