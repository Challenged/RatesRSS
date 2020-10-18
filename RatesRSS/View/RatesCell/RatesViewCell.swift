//
//  RatesViewCell.swift
//  RatesRSS
//
//  Created by Rustam on 10/18/20.
//

import UIKit

class RatesViewCell: UITableViewCell {

//	ярлык для кода валюты
	@IBOutlet weak var code: UILabel!
//	ярлык для курса
	@IBOutlet weak var rate: UILabel!

	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
