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
//	имя БД
	let dbName = "currency_db"
//	сокет БД
	let socket =
		"/usr/local/mysql/mysql.sock"
//		"/usr/local/mysql-8.0.21-macos10.15-x86_64/mysql.sock"
//	"/usr/local/mysql-8.0.21-macos10.15-x86_64/data/performance_schema/"

	let codes = [
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
//		подключение БД
		connect()
    }

	override func viewWillDisappear(_ animated: Bool) {
//		coordinator.disconnect()
	}

	@IBAction func getDataForDB(_ sender: UIButton) {
//		url данных для БД
		let url = getURL()
		requestData(url)
	}

	@IBAction fileprivate func getRates(_ sender: UIButton) {
	}

	//MARK: - Методы карусели выбора валюты

	// количество сегментов
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

//	количество рядов/ позиций
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return codes.count
	}
//	названия рядов/ позиций
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return codes[row]
	}


//	MARK: - Методы БД
	fileprivate func connect() {
//		подключение к БД
		let user = OHMySQLUser(userName: "root", password: "ironware-roost-adagio", serverName: "localhost", dbName: dbName, port: 3306, socket:
								socket
//							   nil
		)
//		let user2 = OHMySQLUser(userName: <#T##String#>, password: <#T##String#>, serverName: <#T##String#>, dbName: <#T##String#>, port: <#T##UInt#>, socket: <#T##String?#>
		coordinator = OHMySQLStoreCoordinator(user: user!)
		coordinator.encoding = .UTF8MB4
		coordinator.connect()

//		подвязка координатора к контексту
		context.storeCoordinator = coordinator
	}

	fileprivate func insertData(_ item: RSSItem) {
		//					заполнение БД
		let query = OHMySQLQueryRequestFactory.insert("currency", set: ["name": item.title!, "rate": Float(item.itemDescription ?? "0")!, "date": self.datePicker.date])
		try? OHMySQLContainer.shared.mainQueryContext?.execute(query)
	}

//	MARK: - Методы RSS

	fileprivate func getURL() -> String {
//		url данных для БД
		var url = String()
		let date = datePicker.date
		if date != Date() {
			// если дата не сегодня, url с датой
//			форматтер даты
			let dateFormatter = DateFormatter()
			dateFormatter.dateStyle = .medium
			dateFormatter.timeStyle = .none
			dateFormatter.locale = Locale(identifier: "ru-RU")
			dateFormatter.setLocalizedDateFormatFromTemplate("dd-MM-yyyy")
			print(dateFormatter.string(from: date))
			url = "https://nationalbank.kz/rss/get_rates.cfm?fdate="+dateFormatter.string(from: date)
		} else {
//			если дата сегодня, короткий url
			url =
				"https://nationalbank.kz/rss/rates_all.xml?switch=russian"
//				"https://nationalbank.kz/rss/get_rates.cfm?fdate=16.10.2020"
				}
		return url
	}

	fileprivate func requestData(_ url: String) {
//	  	запрос данных
		AF.request(url).responseRSS { (response) -> Void in
			if let feed: RSSFeed = response.value {
				// печать данных в консоли
				var counter = 0
				for item in feed.items {
					counter += 1
					print(counter,item)
//					запись данных в БД
					self.insertData(item)
				}
			}
			print(self.datePicker.date)
//			переход на следующий экран после задержки для обработки запроса
			Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
				self.performSegue(withIdentifier: "goToRates", sender: self)
				timer.invalidate()
			}
		}
	}

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
		// проверка сегвея
		if segue.identifier == "goToRates" {
//			захват контроллера
			let destinationVC = segue.destination as! RatesViewController
//			захват выбранного ряда в карусели валюты
			let pickedCode = codePicker.selectedRow(inComponent: 0)
//			передача кода валюты соответствующей выбранному ряду
			destinationVC.currencyCode = codes[pickedCode]
//			передача выбранной в карусели даты
			destinationVC.date = datePicker.date
//			передача имени БД
			destinationVC.dbName = dbName
//			передача сокета
			destinationVC.socket = socket
		}
        // Pass the selected object to the new view controller.
    }


}
