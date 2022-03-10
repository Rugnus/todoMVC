//
//  CheckTableViewCell.swift
//  ToDoApp
//
//  Created by Sungur on 27.02.2022.
//

import UIKit

protocol CustomCellDelegate {
    func editCell(cell: CheckTableViewCell)
    func deleteCell(cell: CheckTableViewCell)
}

class CheckTableViewCell: UITableViewCell {

    
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var label: UILabel!
    
    var delegate: CustomCellDelegate?
    var isChecked: Bool = false
    
    @IBAction func checked(_ sender: Any) {
        updateChecked()
    }
    
    func set(title: String, checked: Bool) {
        label.text = title
        isChecked = checked
        updateChecked()
    }

    private func updateChecked() {
        
        isChecked = !isChecked
        
        let attributedString = NSMutableAttributedString(string: label.text!)
        
        if !isChecked {
            attributedString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length-1))
        } else {
            attributedString.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attributedString.length-1))
        }
        
        label.attributedText = attributedString
    }
    
    
}
