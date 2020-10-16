//
//  ViewController.swift
//  RatesRSS
//
//  Created by Rustam on 10/16/20.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var background: UIImageView!
	@IBOutlet weak var loginButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		background.alpha = 0.5
		loginButton.frame.size.width = CGFloat(100)
		loginButton.layer.cornerRadius = 10
	}


}

