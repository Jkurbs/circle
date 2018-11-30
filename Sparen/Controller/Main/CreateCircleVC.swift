//
//  CreateCircleVC.swift
//  Sparen
//
//  Created by Kerby Jean on 9/2/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography
import FirebaseAuth
import FirebaseFirestore
import MBProgressHUD
import GSMessages


class CreateCircleVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return suggestions.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return suggestions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let amount = suggestions[row]
        self.amount = amount
    }

    var user: User?

    var label: UILabel!
    var descLabel: UILabel!
    
    var pickerView = UIPickerView()
    
    
    
    
//    var textField: UITextField!
    var button: UIButton!
    var infoButton = UIButton()
    
    var hashes = [UIButton : [Double]]()
    var buttons = [UIButton]()
    
    var amount = ""
    
    var array = [String]()

    

    
    var suggestions = ["$1000", "$2500" , "$4000"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .backgroundColor
        self.title = "Create a circle"
        
        let removeButton = UIBarButtonItem(image: UIImage(named: "Remove-20"), style: .done, target: self, action: #selector(close))

        navigationItem.leftBarButtonItem = removeButton
        
        
        label = UICreator.create.label("", 30, .darkText, .center, .regular, view)
        descLabel = UICreator.create.label("\(user?.firstName ?? "") How much money would you like to save?", 20, .darkText, .center, .medium, view)
        
        
        self.view.addSubview(pickerView)
        
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
//        textField = UICreator.create.textField("Amount", .numberPad, view)
//
//        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//        textField.font = UIFont.systemFont(ofSize: 40, weight: .medium)
//        textField.textAlignment = .center
//
//        textField.delegate = self


//        infoButton.setImage(#imageLiteral(resourceName: "Info-20"), for: .normal)
//        infoButton.translatesAutoresizingMaskIntoConstraints = false
//        infoButton.clipsToBounds = true
//        infoButton.addTarget(self, action: #selector(info), for: .touchUpInside)
//
//        view.addSubview(infoButton)
        
        button = UICreator.create.button("Create", nil, .sparenColor, .white, view)
        button.addTarget(self, action: #selector(create), for: .touchUpInside)
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowRadius = 5.0
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
//        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
//            self.textField.becomeFirstResponder()
//        }
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        constrain(descLabel, pickerView, infoButton, button, view) { (descLabel, pickerView, infoButton, button, view) in

            descLabel.top == view.top + 150
            descLabel.height == 100
            descLabel.width == view.width - 100
            descLabel.centerX == view.centerX

            pickerView.top == descLabel.bottom + 20
            pickerView.width == view.width
            pickerView.height == 150
            pickerView.centerX == view.centerX
            
            button.top == descLabel.bottom + 200
            button.width == view.width - 100
            button.height == 50
            button.centerX == view.centerX
            
        }
        button.cornerRadius = 25
    }
    
    

    
   
    
    @objc func create() {
        
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Creating"
        
        let totalAmount = Int(self.amount)
        
        DataService.call.createCircle(totalAmount ?? 1000) { (success, error) in
            if !success {
                loadingNotification.hide(animated: true)
                // ERROR
            } else {
                 loadingNotification.hide(animated: true)
            }

        //add 1 day to the date:
//        let currentDate = NSDate()
//        let newDate = NSDate(timeInterval: 86400, since: currentDate as Date)
//        UserDefaults.standard.setValue(newDate, forKey: "waitingDate")
            
        }
    }
    
     @objc func info() {
        
//        textField.resignFirstResponder()
        GSMessage.infoBackgroundColor = .white
        
        self.showMessage("This is the total amount you and anybody who join your Circle will receive.", type: .success, options: [
            .autoHide(false),
            .height(150.0),
            .position(.bottom),
            .cornerRadius(20.0),
            .textColor(.darkText),
            .textNumberOfLines(6),
            .hideOnTap(true)
        ])
    }
}
