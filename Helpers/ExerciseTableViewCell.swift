//
//  ExerciseTableViewCell.swift
//  WaitingForInspiration
//
//  Created by Parth shah on 04/09/20.
//  Copyright © 2020 Parth shah. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {
    
  
    @IBOutlet weak var nameCell: UILabel!
    @IBOutlet weak var descriptionCell: UILabel!
    @IBOutlet weak var dateCell: UILabel!
    @IBOutlet weak var durationCell: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
