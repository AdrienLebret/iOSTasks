//
//  ReminderTableViewController.swift
//  iOSTasks
//
//  Created by Adrien Lebret on 15/12/2019.
//  Copyright © 2019 if26. All rights reserved.
//

import UIKit

class ReminderTableViewController: UITableViewController {

    var identifiantModuleCellule : String = "cellReminder"
    
    struct Objects {
        var sectionName : String!
        var sectionObjects : [String]!
    }
    
    var objectsArray = [Objects]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tableau de tâches pour l'exemple. Il faudra remplir ce tableau avec des tâches provenant
        // de notre base de données
        objectsArray = [Objects(sectionName: "Aujourd'hui", sectionObjects: ["tâche 1","tâche 2","tâche 3","tâche 4","tâche 5"]), Objects(sectionName: "Demain", sectionObjects: ["tâche 6","tâche 7"]), Objects(sectionName: "7 prochains jours", sectionObjects: ["tâche 8","tâche 9","tâche 10","tâche 11","tâche 12"]), Objects(sectionName: "Après", sectionObjects: ["tâche 13",])]
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return objectsArray.count // count how many section we have
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectsArray[section].sectionObjects.count
    }
    
    func ​tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: identifiantModuleCellule, for: indexPath)
        cell.textLabel?.text = objectsArray[indexPath.section].sectionObjects[indexPath.row]
        //cell.detailTextLabel?.text = "Section \(indexPath.section)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectsArray[section].sectionName
    }


}
