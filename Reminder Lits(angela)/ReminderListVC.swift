//
//  ViewController.swift
//  Reminder Lits(angela)
//
//  Created by Ahmed Hussien on 25/11/2021.
//

import UIKit

class ReminderListVC: UITableViewController{
    
    var Rlist = ["list 1","list 2","list 3"]
    let uDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        if let  list = uDefault.array(forKey: "RlistUpdate") as? [String]{
            Rlist = list
        }
        
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title:"add item", message:"", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "add", style: .default) { action in
            if textField.text != ""{
                self.Rlist.append(textField.text!)
                self.uDefault.set(self.Rlist, forKey: "RlistUpdate")
            }
            self.tableView.reloadData()
        }
        //MARK: add textfiled in alert
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
        }
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rlist.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath)
            cell.textLabel?.text = Rlist[indexPath.row]
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //MARK: animation when deselect row
        // tableView.deselectRow(at: indexPath,animated: true)
        
        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            //MARK: checkmark row when selected
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        Rlist.remove(at: indexPath.row)
        tableView.reloadData()
    }
   
}



