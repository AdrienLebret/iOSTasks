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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            requestP.predicate = pastPredicate
            
            let pastReminder = try context.fetch(requestP)
            
            print("===========")
            print("PAST")
            print("===========")
            
            print(pastReminder)
            
            // TODAY
            
            let todayPredicate = NSPredicate(format: "deadline == %@", date)
            //requestT.predicate = todayPredicate
            
            // Set predicate as date being today's date
            let fromPredicate = NSPredicate(format: "deadline>= %@", dateFrom as! NSDate)
            let toPredicate = NSPredicate(format: "deadline < %@" , dateTo as! NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            requestT.predicate = datePredicate
            
            let todayReminder = try context.fetch(requestT)
            
            print("===========")
            print("TODAY")
            print("===========")
            print(todayReminder)
            
            // FUTUR
            
            let futurPredicate = NSPredicate(format: "deadline > %@", dateTo as! NSDate)
            requestF.predicate = futurPredicate
            
            let futurReminder = try context.fetch(requestF)
            
            print("===========")
            print("FUTUR")
            print("===========")
            print(futurReminder)
       
            //objectsArray = [Objects(sectionName: "Aujourd'hui", sectionObjects: results as! [ReminderEntity])]
            
            
            //let todayReminder =
            
            
            
            
            // Add results to array
            
            objectsArray = [Objects(sectionName: "Pasted", sectionObjects: pastReminder as! [ReminderEntity]),Objects(sectionName: "Today", sectionObjects: todayReminder as! [ReminderEntity]),Objects(sectionName: "After", sectionObjects: futurReminder as! [ReminderEntity])]
            
        } catch  {
            
        }
        
    }

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
