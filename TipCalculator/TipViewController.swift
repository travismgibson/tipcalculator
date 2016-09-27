//
//  ViewController.swift
//  TipCalculator
//
//  Created by Travis Gibson on 9/22/16.
//  Copyright © 2016 Travis Gibson. All rights reserved.
//

import UIKit

class TipViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    @IBOutlet weak var splitSteeper: UIStepper!
    @IBOutlet weak var splitValue: UILabel!
    @IBOutlet weak var splitPersonValue: UILabel!
    
    let _defaults = UserDefaults.standard
    let _rememberBillAmount = "rememberBillAmount"
    let _rememberBillAmountDate = "rememberBillAmountDate"
    let _rememberSplitNum = "rememberSplitNum"
    
    let PLACEHOLDER_TEXT = "$"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Shows keyboard
        billField.becomeFirstResponder()
        
        // Setup billField delegate to format decimal field
        billField.delegate = self

        if (rememberBillAmountDateAlreadyExist()) {
            checkBillAmountTimeout();
        }
        
        // Adds Dollar sign placecholder
        billField?.placeholder = PLACEHOLDER_TEXT
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tipControl.selectedSegmentIndex = getDefaultTip();
        calcTipAmount();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // If billField is empty or 0, do not store in UserDefault
        let bill = Double(billField.text!) ?? 0
        if (bill != 0) {
            setRememberBillAmount();
        } else {
            _defaults.removeObject(forKey: _rememberBillAmount)
            _defaults.removeObject(forKey: _rememberBillAmountDate)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onTap(_ sender: AnyObject) {
        // Commented to Always show keyboard
        // view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: AnyObject) {
        calcTipAmount();
    }

    @IBAction func splitStepperAction(_ sender: AnyObject) {
        splitValue.text = "\(Int(splitSteeper.value))"
        calcTipAmount();
    }

    
    func getDefaultTip() -> Int {
        return _defaults.integer(forKey: "defaultTip")
    }
    func getRememberBillAmount() -> Double {
        return _defaults.object(forKey: _rememberBillAmount) as! Double
    }

    func getRememberBillAmountDate() -> Date {
        return _defaults.object(forKey: _rememberBillAmountDate) as! Date
    }
    
    func getRememberSplitNum() -> String {
        if ((_defaults.object(forKey: _rememberSplitNum)) != nil) {
            return _defaults.object(forKey: _rememberSplitNum) as! String
        } else {
            return "1"
        }
    }
    
    func rememberBillAmountDateAlreadyExist() -> Bool {
        return _defaults.object(forKey: _rememberBillAmountDate)  != nil
    }

    
    func calcTipAmount()  {
        let tipPercentages = [0.18, 0.2, 0.25]

        let bill = Double(billField.text!) ?? 0
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        let numOfPeopleSplitting = Double(splitValue.text!) ?? 0
        let splitTotal = total / numOfPeopleSplitting
        
        tipLabel.text = String.init(format: "$%.2f",tip)
        totalLabel.text = String.init(format: "$%.2f",total)
        splitPersonValue.text = String.init(format: "$%.2f",splitTotal)
    }

    func checkBillAmountTimeout() {
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.unitsStyle = DateComponentsFormatter.UnitsStyle.full
        let minsElapsed = Calendar.current.dateComponents([.minute], from: getRememberBillAmountDate(), to: Date()).minute ?? 0

        if (minsElapsed < 10) {
            billField.text = String(format:"%.2f", getRememberBillAmount())
            splitValue.text = getRememberSplitNum()
        }
    }
    
    func setRememberBillAmount() {
        let billAmount = Double(billField.text!) ?? 0
        _defaults.set(billAmount, forKey: _rememberBillAmount)
        _defaults.set(Date(), forKey: _rememberBillAmountDate)
        _defaults.set(splitValue.text, forKey: _rememberSplitNum)
    }
    
    // Textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { // return NO to not change text
        
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            return true
        case ".": // only allow 1 decimal place
            let textString : String = textField.text!
            let array = Array(textString.characters)
            var decimalCount = 0
            for character in array {
                if character == "." {
                    decimalCount += 1
                }
            }
            
            if decimalCount == 1 {
                return false
            } else {
                return true
            }
        default:
            let array = Array(string.characters)
            if array.count == 0 {
                return true
            }
            return false
        }
    }

}

