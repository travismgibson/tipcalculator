//
//  ViewController.swift
//  TipCalculator
//
//  Created by Travis Gibson on 9/22/16.
//  Copyright © 2016 Travis Gibson. All rights reserved.
//

import UIKit

class TipViewController: UIViewController {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    let _defaults = UserDefaults.standard
    let _rememberBillAmount = "rememberBillAmount"
    let _rememberBillAmountDate = "rememberBillAmountDate"


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (rememberBillAmountDateAlreadyExist()) {
            checkBillAmountTimeout();
        }
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
        print ("bill: \(bill)")
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
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: AnyObject) {
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
    
    
    func rememberBillAmountDateAlreadyExist() -> Bool {
        return _defaults.object(forKey: _rememberBillAmountDate)  != nil
    }

    
    func calcTipAmount()  {
        let tipPercentages = [0.18, 0.2, 0.25]

        let bill = Double(billField.text!) ?? 0
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip        
        
        tipLabel.text = String.init(format: "$%.2f",tip)
        totalLabel.text = String.init(format: "$%.2f",total)
    }
    
    func checkBillAmountTimeout() {
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.unitsStyle = DateComponentsFormatter.UnitsStyle.full
        let minsElapsed = Calendar.current.dateComponents([.minute], from: getRememberBillAmountDate(), to: Date()).minute ?? 0

        if (minsElapsed < 10) {
            billField.text = String(format:"%.2f", getRememberBillAmount())
        }
    }
    
    func setRememberBillAmount() {
        let billAmount = Double(billField.text!) ?? 0
        _defaults.set(billAmount, forKey: _rememberBillAmount)
        _defaults.set(Date(), forKey: _rememberBillAmountDate)
    }
    
    
    
}

