//
//  RSSViewController.swift
//  RatesRSS
//
//  Created by Rustam on 10/16/20.
//

import UIKit
import Alamofire
import AlamofireRSSParser

class RSSViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

//	карусель выбора валюты
	@IBOutlet weak var codePicker: UIPickerView!
//	карусель даты
	@IBOutlet weak var datePicker: UIDatePicker!

	let code = [
		"Все",
		"AED",
		"AMD",
		"AUD",
		"AZN",
		"BRL",
		"BYN",
		"CAD",
		"CHF",
		"CNY",
		"CZK",
		"DKK",
		"EUR",
		"GBP",
		"GEL",
		"HKD",
		"HUF",
		"INR",
		"IRR",
		"JPY",
		"KGS",
		"KRW",
		"KWD",
		"MDL",
		"MXN",
		"MYR",
		"NOK",
		"PLN",
		"RUB",
		"SAR",
		"SEK",
		"SGD",
		"THB",
		"TJS",
		"TRY",
		"UAH",
		"USD",
		"UZS",
		"XDR",
		"ZAR"
	]


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

// 		установка делегата карусели выбора валюты
		codePicker.delegate = self
//		размер окна карусели выбора валюты
//		codePicker.frame.width = UIScreen.main.bounds.width - 20
    }
    
//MARK: - Методы карусели выбора валюты

	// количество сегментов
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

//	количество рядов/ позиций
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return code.count
	}
//	названия рядов/ позиций
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return code[row]
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
