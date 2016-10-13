//
//  OnboardViewController.swift
//  VINCIFitness
//
//  Created by David Xu on 8/15/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit

class OnboardViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var vLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        vLabel.textColor = UIColor.vinciRed()
        loginButton.setTitleColor(UIColor.white, for: UIControlState())
        loginButton.backgroundColor = UIColor.vinciRed()
        loginButton.layer.cornerRadius = 5
        
        signUpButton.setTitleColor(UIColor.white, for: UIControlState())
        signUpButton.backgroundColor = UIColor.vinciRed()
        signUpButton.layer.cornerRadius = 5
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        self.present(LoginViewController(), animated: true, completion: nil)
    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
        self.present(SignupViewController(), animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
