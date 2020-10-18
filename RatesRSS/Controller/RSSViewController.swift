//
//  RSSViewController.swift
//  RatesRSS
//
//  Created by Rustam on 10/16/20.
//

import UIKit
import Alamofire
import AlamofireRSSParser
import OHMySQL

class RSSViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

//	карусель выбора валюты
	@IBOutlet weak var codePicker: UIPickerView!
//	карусель даты
	@IBOutlet weak var datePicker: UIDatePicker!

//	свойства для БД
//	координатор
	var coordinator = OHMySQLStoreCoordinator()
//	контекст
	let context = OHMySQLQueryContext()

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

	override func viewWillDisappear(_ animated: Bool) {
		coordinator.disconnect()
	}

	@IBAction func getDataForDB(_ sender: UIButton) {
//		url данных для БД
		let url = "https://nationalbank.kz/rss/rates_all.xml?switch=russian"

		let query = OHMySQLQueryRequestFactory.select("currencyItems", condition: nil)
		let response = try? OHMySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query)

//	  	запрос данных
		AF.request(url).responseRSS { (response) -> Void in
			if let feed: RSSFeed = response.value {
				// call the DB population methods
				var counter = 0
				for item in feed.items {
					counter += 1
					print(counter,item)
//					заполнение БД
					let query = OHMySQLQueryRequestFactory.insert("currency", set: ["name": item.title!, "rate": Float(item.description)!, "date": self.datePicker.date])
					try? OHMySQLContainer.shared.mainQueryContext?.execute(query)
				}
			}
//			let dateFomratter = DateFormatter()
//			dateFomratter.dateStyle = .medium
//			dateFomratter.timeStyle = .none
//			dateFomratter.locale = Locale(identifier: "cn-CN")
			print(
//				dateFomratter.string(from:
										self.datePicker.date
//				)
			)
		}

	}

	@IBAction func getRates(_ sender: UIButton) {
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


//	MARK: - Методы БД
	func connect() {
//		подключение к БД
		let user = OHMySQLUser(userName: "root", password: "ironware-roost-adagio", serverName: "localhost", dbName: "currency_DB", port: 3306, socket: "/usr/local/mysql/mysql.sock")
		coordinator = OHMySQLStoreCoordinator(user: user!)
		coordinator.encoding = .UTF8MB4
		coordinator.connect()

//		подвязка координатора к контексту
		context.storeCoordinator = coordinator
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
