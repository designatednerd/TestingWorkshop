//
//  TaskViewController.swift
//  Detour
//
//  Created by Ellen Shapiro on 5/6/17.
//  Copyright © 2017 Designated Nerd Software. All rights reserved.
//

import MapKit
import UIKit

class TaskViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var durationTextField: UITextField!
    
    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet var prosAndConsTableView: UITableView!
    
    @IBOutlet var addProButton: UIButton!
    @IBOutlet var addConButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    var isEditable: Bool = true {
        didSet {
            guard self.nameTextField != nil else {
                return
            }
            
            if self.isEditable {
                self.nameTextField.borderStyle = .roundedRect
                self.nameTextField.isUserInteractionEnabled = true
                self.priceTextField.borderStyle = .roundedRect
                self.priceTextField.isUserInteractionEnabled = true
                self.durationTextField.borderStyle = .roundedRect
                self.durationTextField.isUserInteractionEnabled = true
                self.saveButton.isHidden = false
                self.addProButton.isHidden = true
                self.addConButton.isHidden = true
            } else {
                self.nameTextField.borderStyle = .none
                self.nameTextField.isUserInteractionEnabled = false
                self.priceTextField.borderStyle = .none
                self.priceTextField.isUserInteractionEnabled = false
                self.durationTextField.borderStyle = .none
                self.durationTextField.isUserInteractionEnabled = false
                self.saveButton.isHidden = true
                self.addProButton.isHidden = false
                self.addConButton.isHidden = false
            }
        }
    }
    
    var detour: Detour!
    
    var task: Task! {
        didSet {
            self.detour = self.task.detour
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let editable = self.isEditable
        self.isEditable = editable
    }
    
    // MARK: - Actions 
    
    @IBAction func saveTask() {
        self.validateData()
        if let errors = self.errorLabel.text,
            !errors.isEmpty {
            self.createTask()
        } else {
            self.errorLabel.isHidden = true
        }
    }
    
    @IBAction func addPro() {
        //TODO
    }
    
    @IBAction func addCon() {
        //TODO
    }
    
    // MARK: - Saving
    
    func createTask() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let task = Task(context: context)
        task.name = self.nameTextField.text
        task.price = (self.priceTextField.text! as NSString).floatValue
        task.lengthInHours = (self.durationTextField.text! as NSString).floatValue
        task.detour = self.detour
        
        try! context.save()
        
        self.isEditable = false    
    }
    
    // MARK: - Validation 
    
    func validateData() {
        var errors = [String]()
        
        if let name = self.nameTextField.text,
            !name.isEmpty {
            
        } else {
            errors.append("Please add a name for the task.")
        }
        
        if let price = self.priceTextField.text,
            !price.isEmpty {
            let notNumbers = NSCharacterSet.decimalDigits.inverted
            if price.rangeOfCharacter(from: notNumbers) != nil {
                errors.append("Please enter a numeric value for the price of the task.")
            }
        } else {
            errors.append("Please enter a price for the task.")
        }
        
        if let duration = self.durationTextField.text,
            !duration.isEmpty {
            let notNumbers = NSCharacterSet.decimalDigits.inverted
            if duration.rangeOfCharacter(from: notNumbers) != nil {
                errors.append("Please enter a numeric value for the hours of the task")
            }
        } else {
            errors.append("Please enter a duration (in hours) for the task")
        }
        
        self.errorLabel.text = errors.joined(separator: "\n")
    }
    
    
    // MARK: - Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.task.pros?.count ?? 0
        } else if section == 1 {
            return self.task.cons?.count ?? 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Pros"
        } else if section == 1 {
            return "Cons"
        } else {
            return "I should not be here!"
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProConCell", for: indexPath)
        
        if indexPath.section == 0 {
            guard let pros = self.task.pros?.allObjects as? [Pro] else {
                assertionFailure("Not pros!")
                return UITableViewCell()
            }
            
            let pro = pros[indexPath.row]
            cell.textLabel?.text = pro.text
        } else if indexPath.section == 1 {
            guard let cons = self.task.cons?.allObjects as? [Con] else {
                assertionFailure("Not cons!")
                return UITableViewCell()
            }
            
            let con = cons[indexPath.row]
            cell.textLabel?.text = con.text
        } else {
            assertionFailure("Unhandled section!")
            return UITableViewCell()
        }
        
        return cell
    }
    
}
