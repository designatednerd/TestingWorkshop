//
//  DetourViewController.swift
//  Detour
//
//  Created by Ellen Shapiro on 6/1/17.
//  Copyright © 2017 Designated Nerd Software. All rights reserved.
//

import CoreData
import MapKit
import UIKit

class DetourViewController: UIViewController {

    var firstTaskViewController: TaskViewController!
    var secondTaskViewController: TaskViewController!
    
    @IBOutlet var titleLabel: UILabel!
    
    //TODO: Set up map
    @IBOutlet var mapView: MKMapView?
    
    var isEditable: Bool = true {
        didSet {
            guard self.firstTaskViewController != nil else {
                return
            }
            
            self.firstTaskViewController.isEditable = true
            self.secondTaskViewController.isEditable = true
        }
    }
    
    var detour: Detour! {
        didSet {
            guard self.firstTaskViewController != nil else {
                return
            }
            
            self.title = "Detour in \(self.detour.destination!.name!)"
            self.addAnnotationForDestination(self.detour.destination!)
            
            if let tasks = self.detour.tasks?.allObjects as? [Task] {
                if tasks.count == 0 {
                    self.firstTaskViewController.detour = self.detour
                    self.firstTaskViewController.isEditable = true
                    
                    self.secondTaskViewController.detour = self.detour
                    self.secondTaskViewController.isEditable = true
                    
                    self.titleLabel.text = "Add Tasks"
                } else if tasks.count == 1 {
                    let firstTask = tasks.first!
                    self.firstTaskViewController.task = firstTask
                    self.firstTaskViewController.isEditable = false
                    self.addAnnotationForTask1(firstTask)
                    
                    self.secondTaskViewController.detour = self.detour
                    self.secondTaskViewController.isEditable = true
                    
                    self.titleLabel.text = "\(firstTask.name!) or ???"
                } else if tasks.count == 2 {
                    let firstTask = tasks.first!
                    self.firstTaskViewController.task = firstTask
                    self.firstTaskViewController.isEditable = false
                    self.addAnnotationForTask1(firstTask)

                    let secondTask = tasks.last!
                    self.secondTaskViewController.task = secondTask
                    self.secondTaskViewController.isEditable = false
                    self.addAnnotationForTask2(secondTask)
                    
                    self.titleLabel.text = "\(firstTask.name!) or \(secondTask.name!)"
                } else {
                    fatalError("Too many tasks! A detour is a choice between TWO tasks, each with its own pros and cons.")
                }
            } else {
                self.firstTaskViewController.detour = self.detour
                self.firstTaskViewController.isEditable = true
                
                self.secondTaskViewController.detour = self.detour
                self.secondTaskViewController.isEditable = true
            }
            
            self.zoomMapToShowAllPins()
        }
    }
    
    //MARK: - View Lifecycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let detour = self.detour {
            self.detour = detour
        }
        
        let editable = self.isEditable
        self.isEditable = editable
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Task1" {
            self.firstTaskViewController = segue.destination as! TaskViewController
        } else if segue.identifier == "Task2" {
            self.secondTaskViewController = segue.destination as! TaskViewController
        }
    }
    
    // MARK: Map stuff
    
    func addAnnotationForTask1(_ task: Task) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: task.latitude, longitude: task.longitude)
        self.mapView?.addAnnotation(annotation)
    }
    
    func addAnnotationForTask2(_ task: Task) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: task.latitude, longitude: task.longitude)
        self.mapView?.addAnnotation(annotation)
    }
    
    func addAnnotationForDestination(_ destination: Destination) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude)
        self.mapView?.addAnnotation(annotation)
    }
    
    func zoomMapToShowAllPins() {
        //TODO: Figure out how to do this.
    }
}
