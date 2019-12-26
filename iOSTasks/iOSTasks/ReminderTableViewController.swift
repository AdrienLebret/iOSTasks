//
//  ReminderTableViewController.swift
//  iOSTasks
//
//  Created by Adrien Lebret on 15/12/2019.
//  Copyright © 2019 if26. All rights reserved.
//

import UIKit
import CoreData

class ReminderTableViewController: UITableViewController {

    var identifiantModuleCellule : String = "cellReminder"
    var cellUUID:String = ""
    
    struct Objects {
        var sectionName : String!
        var sectionObjects : [ReminderEntity]!
    }
    
    var objectsArray = [Objects]()
    
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string : "Pull to refresh")
        refresher.addTarget(self, action: #selector(ReminderTableViewController.populate), for: .valueChanged)
        
        tableView.addSubview(refresher)
        
        // Get current tab bar view controller
        
        let currentCategory = self.title! // name of the current Table View Controller
        
        print(currentCategory)
        
        
        // Tableau de tâches pour l'exemple. Il faudra remplir ce tableau avec des tâches provenant
        // de notre base de données
        /*objectsArray = [Objects(sectionName: "Aujourd'hui", sectionObjects: ["tâche 1","tâche 2","tâche 3","tâche 4","tâche 5"]), Objects(sectionName: "Demain", sectionObjects: ["tâche 6","tâche 7"]), Objects(sectionName: "7 prochains jours", sectionObjects: ["tâche 8","tâche 9","tâche 10","tâche 11","tâche 12"]), Objects(sectionName: "Après", sectionObjects: ["tâche 13"])]*/
        
        // Recherche Core Data
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let requestP = NSFetchRequest<NSFetchRequestResult>(entityName: "ReminderEntity")
        requestP.returnsObjectsAsFaults = false
        
        let requestT = NSFetchRequest<NSFetchRequestResult>(entityName: "ReminderEntity")
        requestT.returnsObjectsAsFaults = false
        
        let requestF = NSFetchRequest<NSFetchRequestResult>(entityName: "ReminderEntity")
        requestF.returnsObjectsAsFaults = false
        
        do {
            
            //========================
            // Date Filtering Results
            //========================
            
            // Type
            
            let categoryPredicate = NSPredicate(format: "category == %@", currentCategory)
            
            // DATE
            
            let date = NSDate()
            
            // Get the current calendar with local time zone
            var calendar = Calendar.current
            calendar.timeZone = NSTimeZone.local

            // Get today's beginning & end
            let dateFrom = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
            let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
            // Note: Times are printed in UTC. Depending on where you live it won't print 00:00:00 but it will work with UTC times which can be converted to local time
            
            // PAST
            
            let pastPredicate = NSPredicate(format: "deadline < %@", dateFrom as! NSDate)
            requestP.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [pastPredicate,categoryPredicate])
            
            let pastReminder = try context.fetch(requestP)

            
            // TODAY
            
            let todayPredicate = NSPredicate(format: "deadline == %@", date)
            //requestT.predicate = todayPredicate
            
            // Set predicate as date being today's date
            let fromPredicate = NSPredicate(format: "deadline >= %@", dateFrom as! NSDate)
            let toPredicate = NSPredicate(format: "deadline < %@" , dateTo as! NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, categoryPredicate])
            requestT.predicate = datePredicate
            
            let todayReminder = try context.fetch(requestT)

            
            // FUTUR
            
            let futurPredicate = NSPredicate(format: "deadline > %@", dateTo as! NSDate)
            requestF.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [futurPredicate,categoryPredicate])
            
            let futurReminder = try context.fetch(requestF)

            
            
            // Add results to array
            
            //objectsArray = [Objects(sectionName: "Aujourd'hui", sectionObjects: results as! [ReminderEntity])]

            
            objectsArray = [Objects(sectionName: "Pasted", sectionObjects: pastReminder as! [ReminderEntity]),Objects(sectionName: "Today", sectionObjects: todayReminder as! [ReminderEntity]),Objects(sectionName: "After", sectionObjects: futurReminder as! [ReminderEntity])]
            
        } catch  {
            
        }
        
    }
    
    //================
    // Refresh method
    //================

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @objc func populate() {
        refresher.endRefreshing()
        // Solution 1
        /*DispatchQueue.main.async{
            self.tableView.reloadData()
        }*/
   
        print("REFRESH DONE")
    }
    
    //====================
    // Table view methods
    //====================

    override func numberOfSections(in tableView: UITableView) -> Int {
        return objectsArray.count // count how many section we have
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectsArray[section].sectionObjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifiantModuleCellule) as! UITableViewCell
        //cell.textLabel?.text = objectsArray[indexPath.section].sectionObjects[indexPath.row]
        
        cell.textLabel?.text = objectsArray[indexPath.section].sectionObjects[indexPath.row].title
        
        //cell.detailTextLabel?.text = "Section \(indexPath.section)"
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectsArray[section].sectionName
    }

    
    //================
    // Cell selection
    //================
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You selected cell #\(indexPath)")
        cellUUID = objectsArray[indexPath.section].sectionObjects[indexPath.row].uuid!
        
        performSegue(withIdentifier: "cellSelection", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ModifyItemViewController{
            let vc = segue.destination as? ModifyItemViewController
            vc?.reminderUUID = cellUUID
        }
    }

}
