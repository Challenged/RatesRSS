//
//  ViewController.swift
//  RatesRSS
//
//  Created by Rustam on 10/16/20.
//

import UIKit
import Firebase
import SVProgressHUD

class ViewController: UIViewController {
	// логин-экран

//	окно вида фонового изображения
	@IBOutlet weak var background: UIImageView!

//	поле ввода логина
	@IBOutlet weak var login: UITextField!

//	поле ввода пароля
	@IBOutlet weak var pwd: UITextField!

	//	окно кнопки "войти"
	@IBOutlet weak var loginButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		// прозрачность окна фонового изображения
		background.alpha = 0.7

//		скругление углов кнопки 
		loginButton.layer.cornerRadius = 10
	}

	@IBAction func loginTapped(_ sender: UIButton) {

//		показать прогресс спиннер
		SVProgressHUD.show()

// авторизация пользователя
		Auth.auth().signIn(withEmail: login.text ?? "test@test.com", password: pwd.text ?? "test") { (authDataResult, error) in
			// язык сообщений логин модуля
			Auth.auth().languageCode = "ru"

			if error != nil {
//				оповещение об ошибке при попытке входа
				let alert = UIAlertController(title: "Ошибка входа:", message: "проверьте подключение к интернету, адрес эл. почты и пароль.", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Окей", style: .cancel, handler: { _ in
						NSLog("The login failure alert occured.")
				}))

				//		скрыть прогресс спиннер
						SVProgressHUD.dismiss()
				self.present(alert, animated: true, completion: nil)
			} else {
				// успешный вход

				//	скрыть прогресс спиннер
				SVProgressHUD.dismiss()

//				 переход к следующему экрану
				self.performSegue(withIdentifier: "goToRSS", sender: self)
			}
		}
	}

}

//MARK: - Text Field Delegate Methods
extension ViewController: UITextFieldDelegate {
	// переход на следующее текстовое поле после ввода
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField {
		case login:
			pwd.becomeFirstResponder()
		default:
			pwd.resignFirstResponder()
		}
		return true
	}
}
