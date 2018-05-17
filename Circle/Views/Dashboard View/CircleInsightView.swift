//
//  CircleView.swift
//  Circle
//
//  Created by Kerby Jean on 4/1/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import TableViewHelper
import FirebaseFirestore
import FirebaseAuth


class CircleInsightView: UIView {
    
    
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
    var helper: TableViewHelper!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height: CGFloat = 0.5
        separator.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: height)
        self.layer.addSublayer(separator)
        
        tableView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        tableView.isScrollEnabled = false
        tableView.autoresizingMask = [.flexibleHeight]
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }
    
    
    
    func observeCircle() {
        Firestore.firestore().collection("circles").document("8GB6O6o0Jj2Vz1hxQ1zg").addSnapshotListener { (document, error) in
            if let error = error {
                print("ERROR", error.localizedDescription)
            } else {
                if (document?.exists)! {
                    let data = document?.data()
                    let key = document?.documentID
                    let circle = Circle(key: key!, data: data!, users: nil)
                    self.circle = circle
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    dispatch.async {
                        self.addSubview(self.tableView)
                    }
                    //self.tableView.reloadData()
                }
            }
        }
    }
    
    
    func setup() {
        observeCircle()
        self.backgroundColor = UIColor.textFieldOpaqueBackgroundColor
        
        helper = TableViewHelper(tableView: tableView)
        helper.addCell(section: 0, cell: CircleInsightCell(), name: "S0R0")
        helper.addCell(section: 0, cell: TotalAmountCell(), name: "S0R1", isInitiallyHidden: true)
        helper.addCell(section: 0, cell: WeeklyPaymentCell(), name: "S0R2", isInitiallyHidden: true)
        helper.addCell(section: 0, cell: SetupCircleCell(), name: "S0R3")
        helper.addCell(section: 0, cell: CircleSettings(), name: "S0R4", isInitiallyHidden: true)
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
            self.layer.zPosition = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutIfNeeded()
                self.frame.size.height -= 280
                self.layer.position.y += 280
            })
        }
    }
}

extension CircleInsightView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        helper.hideInitiallyHiddenCells()
        let count = helper.numberOfSections()
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helper.numberOfRows(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let index = helper.indexPathForCell("S0R0") {
            let cell = helper.cellForRow(at: index) as! CircleInsightCell
            cell.configure(circle)
        }
        
        if helper.cellIsVisible("S0R1") {
            let index = helper.indexPathForCell("S0R1")
            let cell = helper.cellForRow(at: index!) as! TotalAmountCell
            cell.configure(self.circle.maxAmount!)
        }
        
        if helper.cellIsVisible("S0R2") {
            let index = helper.indexPathForCell("S0R2")
            let cell = helper.cellForRow(at: index!) as! WeeklyPaymentCell
            cell.configure(self.circle.weeklyAmount!)
        }
        

        if helper.cellIsVisible("S0R3") {
            let index = helper.indexPathForCell("S0R3")
            let cell = helper.cellForRow(at: index!) as! SetupCircleCell
            if circle.adminId != Auth.auth().currentUser!.uid {
                helper.hideCell("S0R4", immediate: true)
                helper.showCell("S0R5")
            }
        
            if circle.activated == true {
                print("ACTIVATED")
                cell.isUserInteractionEnabled = false
                cell.label.text = "Update Circle"
            }
        }
        
        return helper.cellForRow(at: indexPath)
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let name = helper.cellName(at: indexPath) {
            switch name {
            case "S0R2":
                if !helper.cellIsVisible("S0R4") {
                    helper?.showCell("S0R4")
                    
                    self.layer.zPosition = 1
                    UIView.animate(withDuration: 0.3, animations: {
                        self.layoutIfNeeded()
                        self.frame.size.height += 150
                        self.layer.position.y -= 150
                    })
                } else {
                    helper?.hideCell("S0R4")
                    self.layer.zPosition = 0
                    UIView.animate(withDuration: 0.3, animations: {
                        self.layoutIfNeeded()
                        self.frame.size.height -= 150
                        self.layer.position.y += 150
                    })
                }
            case "S0R3":
                if !helper.cellIsVisible("S0R2") {
                    helper?.showCell("S0R1")
                    helper?.showCell("S0R2")
                    self.layer.zPosition = 1
                    UIView.animate(withDuration: 0.3, animations: {
                        self.layoutIfNeeded()
                        self.frame.size.height += 90
                        self.layer.position.y -= 90
                    })
                } else {
                    if helper.cellIsVisible("S0R1") && helper.cellIsVisible("S0R2") {
                        let index1 = helper.indexPathForCell("S0R1")
                        let cell = helper.cellForRow(at: index1!) as! TotalAmountCell
                        let maxAmount = Int(cell.slider.value)
                    
                        let index2 = helper.indexPathForCell("S0R2")
                        let cell2 = helper.cellForRow(at: index2!) as! WeeklyPaymentCell
                        let weeklyAmount = Int(cell2.slider.value)

                        self.setupCircle(maxAmount: maxAmount, weeklyAmount: weeklyAmount)
                    }
                   
                    helper?.hideCell("S0R1")
                    helper?.hideCell("S0R2")
                    self.layer.zPosition = 0
                    UIView.animate(withDuration: 0.3, animations: {
                        self.frame.size.height = 90
                        self.layer.position.y = (self.viewController?.view.bounds.height)! - 70
                    })
                }
            default:
                print("default")
            }
        }
    }
    
    
    func setupCircle( maxAmount: Int?, weeklyAmount: Int?) {

        if circle.activated! {
            DataService.instance.updateCircle(circle.id!, maxAmount ?? circle.maxAmount!)
        } else {
            DataService.instance.setupCircle(circleId: circle.id!, maxAmount: maxAmount ?? circle.maxAmount!, weeklyAmount: weeklyAmount!)
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let numberOfRow = tableView.numberOfRows(inSection: indexPath.section)
        
        if numberOfRow == 3 || numberOfRow == 4 {
            return 45.0
        } else {
            if indexPath.row == 3 {
                return 150.0
            } else {
                return 45.0
            }
        }
    }
}
