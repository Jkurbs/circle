//
//  CircleView.swift
//  Circle
//
//  Created by Kerby Jean on 4/1/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class CircleInsightView: UIView {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var totalAmountSlider: UISlider!
    @IBOutlet weak var setupButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var circle: Circle! 
    
    var settingbutton = ButtonWithImage()
    
    let label = UILabel()
    
    let separator: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red: 200 / 255.0, green: 199 / 255.0, blue: 204 / 255.0, alpha: 1).cgColor
        return layer
    }()
    
    let buttonSeparator: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red: 200 / 255.0, green: 199 / 255.0, blue: 204 / 255.0, alpha: 1).cgColor
        return layer
    }()
    
    var expanded: Bool = false
    
    var tableView = UITableView()

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }
    

    
    func setup() {
        self.backgroundColor = UIColor.textFieldOpaqueBackgroundColor
        let height: CGFloat = 0.5
        separator.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: height)
        self.layer.addSublayer(separator)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    @IBAction func pickeDate(_ sender: UIDatePicker) {
        
        let date = sender.date
        print("DATE:::", date)
        
    }
    
    
    @IBAction func slide(_ sender: UISlider) {
        amountLabel.text = "\(Int(sender.value))"
    }
    
    
    
    @IBAction func expand(_ sender: UIButton) {
        expanded = !expanded
        if expanded {
            self.layer.zPosition = 1
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutIfNeeded()
                self.frame.size.height += 280
                self.layer.position.y -= 280
            })
        } else {
            setupCircle()
            self.layer.zPosition = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutIfNeeded()
                self.frame.size.height -= 280
                self.layer.position.y += 280
            })
        }
    }
    
    
    func setupCircle() {
        
        
        let endDate = datePicker.date
        
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: currentDate)
 
        let days = daysBetween(start: currentDate, end: endDate)
        print("DAYSS::", days)
        
        
        
        
        
        let maxAmount = Int(amountLabel.text!) ?? 0
        let minimalAmount = Int(totalAmountSlider.minimumValue)
        if maxAmount > minimalAmount {
            DataService.instance.setupCircle(circle.id!)
        }
    }
    
    
    func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
}

extension CircleInsightView: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
