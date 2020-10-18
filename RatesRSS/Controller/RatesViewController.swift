//
//  RatesViewController.swift
//  RatesRSS
//
//  Created by Rustam on 10/18/20.
//

import UIKit
//import Alamofire
//import AlamofireRSSParser
import OHMySQL

private let reuseIdentifier = "RatesCell"

class RatesViewController: UITableViewController {

	//  переменные  для rss запроса
	var currencyCode = String()
	var date = Date()
//	var url = String()

	//  БД
	//	имя БД
	var dbName = ""
	//	координатор
	var coordinator = OHMySQLStoreCoordinator()
	// результат чтения БД
	var data: [[String : Any]]?
	//	контекст
	let context = OHMySQLQueryContext()
	let tableName = "currency"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

//		подключение к БД
		connect()
		// регистрация класса ячейки таблицы
		self.tableView!.register(RatesViewCell.self, forCellReuseIdentifier: reuseIdentifier)
		// регистрация дизайна ячейки таблицы
		self.tableView.register(UINib(nibName: "RatesViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)

		// условие запроса БД в зависимости от его типа
		var requestCondition: String?
		if currencyCode != "Все" {
			requestCondition = "WHERE name = \'\(currencyCode)\'"
		}
		if date != Date() {
			if let _ = requestCondition {
				requestCondition! += " AND date = \(date)"
			} else {
				requestCondition = "WHERE date = \(date)"
			}
		}
		data = selectData(withCondition: requestCondition)
    }


	override func viewWillAppear(_ animated: Bool) {
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RatesViewCell

        // Configure the cell...
//		if currencyCode == "Все" {
//			data = selectData()
//		} else {
//
//		}

		cell.code.text = data?[indexPath.row]["code"] as? String ?? "--"
		cell.rate.text = String(data?[indexPath.row]["rate"] as? Float ?? 0)

        return cell
    }

	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row == 0 {
			Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
				tableView.reloadData()
				timer.invalidate()
			}
		}
	}

//	MARK: - методы RSS


//	MARK: - методы БД mySQL

	fileprivate func connect() {
//		подключение к БД
		let user = OHMySQLUser(userName: "root", password: "ironware-roost-adagio", serverName: "localhost", dbName: dbName, port: 3306, socket: "/usr/local/mysql/mysql.sock")
		coordinator = OHMySQLStoreCoordinator(user: user!)
		coordinator.encoding = .UTF8MB4
		coordinator.connect()

//		подвязка координатора к контексту
		context.storeCoordinator = coordinator
	}

//	запрос данных БД
	fileprivate func selectData(withCondition condition: String?) -> [[String : Any]]? {
		let query = OHMySQLQueryRequestFactory.select(tableName, condition: condition)
		let response = try? OHMySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query)
		print("Чтение БД...")
		print(response as Any)
		return response
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
