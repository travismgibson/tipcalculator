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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        let defaultTipIndex = defaults.integer(forKey: "defaultTip")
        tipControl.selectedSegmentIndex = defaultTipIndex
        calcTipAmount();
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
 
    func calcTipAmount()  {
        let tipPercentages = [0.18, 0.2, 0.25]

        let bill = Double(billField.text!) ?? 0
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip        
        
        tipLabel.text = String.init(format: "$%.2f",tip)
        totalLabel.text = String.init(format: "$%.2f",total)
    }
}

