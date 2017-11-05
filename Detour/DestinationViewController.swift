//
//  DestinationViewController.swift
//  Detour
//
//  Created by Ellen Shapiro on 5/6/17.
//  Copyright © 2017 Designated Nerd Software. All rights reserved.
//

import CoreData
import MapKit
import UIKit

class DestinationViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var arriveDateTextField: UITextField!
    @IBOutlet var departDateTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var addDetourButton: UIButton!
    @IBOutlet var detourTableView: UITableView!
    
    enum DateSelection {
        case
        none,
        arrive,
        depart
    }
    
    var dateSelection = DateSelection.none
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.addTarget(self,
                         action: #selector(datePickerValueChanged),
                         for: .valueChanged)
        return picker
    }()
    
    var isEditable: Bool = true {
        didSet {
            guard self.nameTextField != nil else {
                return
            }
            
            if self.isEditable {
                self.nameTextField.borderStyle = .roundedRect
                self.nameTextField.isUserInteractionEnabled = true
                self.arriveDateTextField.borderStyle = .roundedRect
                self.arriveDateTextField.isUserInteractionEnabled = true
                self.departDateTextField.borderStyle = .roundedRect
                self.departDateTextField.isUserInteractionEnabled = true
                self.saveButton.isHidden = false
                self.addDetourButton.isHidden = true
                self.detourTableView.isHidden = true
            } else {
                self.nameTextField.borderStyle = .none
                self.nameTextField.isUserInteractionEnabled = false
                self.arriveDateTextField.borderStyle = .none
                self.arriveDateTextField.isUserInteractionEnabled = false
                self.departDateTextField.borderStyle = .none
                self.departDateTextField.isUserInteractionEnabled = false
                self.saveButton.isHidden = true
                self.addDetourButton.isHidden = false
                self.detourTableView.isHidden = false
            }
        }
    }
    
    var destination: Destination? {
        didSet {
            guard self.nameTextField != nil else {
                return
            }
            
            if let destination = self.destination {
                self.nameTextField.text = destination.name
                self.arriveDate = destination.arriveDate as Date?
                self.departDate = destination.departDate as Date?
                self.addAnnotation(for: CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude))
            }
        }
    }
    
    var detours: [Detour] {
        return self.destination?.detours?.allObjects as? [Detour] ?? []
    }
    
    var arriveDate: Date? {
        didSet {
            guard let arrive = self.arriveDate else {
                self.arriveDateTextField.text = nil
                return
            }
            
            self.arriveDateTextField.text = self.dateFormatter.string(from: arrive)
        }
    }
    
    var departDate: Date? {
        didSet {
            guard let depart = self.departDate else {
                self.departDateTextField.text = nil
                return
            }
            
            
            self.departDateTextField.text = self.dateFormatter.string(from: depart)
        }
    }
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arriveDateTextField.inputView = self.datePicker
        self.departDateTextField.inputView = self.datePicker
        self.errorLabel.isHidden = true
        
        let editable = self.isEditable
        self.isEditable = editable
        
        let destination = self.destination
        self.destination = destination
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowDetour") {
            if let indexPath = self.detourTableView.indexPathForSelectedRow {
                let detour = self.detours[indexPath.row]
                let detourVC = (segue.destination as! DetourViewController)
                detourVC.isEditable = false
                detourVC.detour = detour 
            }
        } else if (segue.identifier == "AddDetour") {
            //TODO: Figure out why in the hell this isn't pushing on iPhone 7+
            let detourVC = (segue.destination as! DetourViewController)
            detourVC.isEditable = true
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let detour = Detour(context: context)
            detour.destination = self.destination
            detourVC.detour = detour 
        }
    }
    
    // MARK: - Actions
    
    @IBAction func tappedSave() {
        self.validateTextFields()
        if self.errorLabel.text == nil || self.errorLabel.text == "" {
            self.createDestination()
        } else {
            self.errorLabel.isHidden = false
        }
    }
    
    @IBAction func tappedCancel() {
        self.dismiss(animated: true)
    }
    
    @objc func datePickerValueChanged() {
        switch self.dateSelection {
        case .none:
            assertionFailure("You shouldn't be able to get here if you're setting the appropriate mode")
        case .arrive:
            self.arriveDate = self.datePicker.date
        case .depart:
            self.departDate = self.datePicker.date
        }
    }
    
    func createDestination() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let destination = Destination(context: context)
        destination.name = self.nameTextField.text
        destination.arriveDate = self.arriveDate as NSDate?
        destination.departDate = self.departDate as NSDate?
        
        do {
            try context.save()
            self.navigationController?.popViewController(animated: true)
        } catch let error {
            print("ERROR: \(error)")
            fatalError("LOL NOPE!")
        }
    }
    
    // MARK: - Map 
    
    func addAnnotation(for location: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        self.mapView.addAnnotation(annotation)
    }
    
    // MARK: - Validation 
    
    func validateTextFields() {
        var errors = [String]()
        
        if self.nameTextField.text == nil || self.nameTextField.text == "" {
            errors.append("Please enter a name for your destination.")
        }
        
        if
            let arrive = self.arriveDate,
            let depart = self.departDate {
            if arrive.compare(depart) != .orderedAscending {
                errors.append("Departure date must be after arrival date.")
            }
        } else {
            errors.append("Please select both arrival and departure dates.")
        }
        
        self.errorLabel.text = errors.joined(separator: "\n")
    }
    
    // MARK: - Text Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nameTextField {
            self.arriveDateTextField.becomeFirstResponder()
        } else if textField == self.arriveDateTextField {
            self.departDateTextField.becomeFirstResponder()
        } else {
            self.departDateTextField.resignFirstResponder()
        }
        
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.arriveDateTextField {
            self.dateSelection = .arrive
        } else if textField == self.departDateTextField {
            self.dateSelection = .depart
        } else {
            self.dateSelection = .none
        }
        
        return true
    }
    
    //MARK: - UITableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetourCell", for: indexPath)
        
        let detour = self.detours[indexPath.row]
        if let tasks = detour.tasks?.allObjects as? [Task] {
            if tasks.count == 2 {
                cell.textLabel!.text = "\(tasks.first!.name!) or \(tasks.last!.name!)"
            } else if tasks.count == 1 {
                cell.textLabel!.text = "\(tasks.first!.name!) or ???"
            } else if tasks.count == 0 {
                cell.textLabel!.text  = "(No tasks created)"
            } else {
                cell.textLabel!.text = "TOO MANY TASKS: \(tasks.count)"
            }
        } else {
            cell.textLabel!.text = "(No tasks created)"
        }
        
        return cell
    }
}
