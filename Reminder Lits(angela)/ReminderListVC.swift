//
//  ViewController.swift
//  Reminder Lits(angela)
//
//  Created by Ahmed Hussien on 25/11/2021.
//

import UIKit
import CoreData

class ReminderListVC: UITableViewController{
    
    var Rlist = [Item]()
    //MARK: temporary area where you put data befor added to database
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: loadItem from context (temproray area)
        loadItem()
        searchBar.delegate = self
    }
    
    //MARK: addbutton. to add item in list
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title:"add item", message:"", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "add", style: .default) { action in
            if textField.text != ""{
                self.addNewItem(title: textField.text!,checked:false)
                //MARK: add item to context (temproray area)
                self.saveItems()
            }
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
        cell.textLabel?.text = Rlist[indexPath.row].title
        //MARK: trenary condition /    value = condition ? true value : false value
        cell.accessoryType = Rlist[indexPath.row].checked == true ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        Rlist[indexPath.row].checked = !Rlist[indexPath.row].checked
        saveItems()
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //MARK: delete item
        context.delete(Rlist.remove(at: indexPath.row))
        saveItems()
    }
   
    func saveItems(){
        do{
            try context.save()
            
        }
        catch{
            print(" ahmed error !!\(error)")
        }
        tableView.reloadData()
    }
    func loadItem(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
            Rlist = try context.fetch(request)
        }
        catch{
            printContent("error fetching data \(error)")
        }
        //refresh
        tableView.reloadData()
    }
    func addNewItem(title:String,checked:Bool){
        let i = Item(context:context)
        i.title = title
        i.checked = checked
        Rlist.append(i)
    }
}
//MARK: sreach bar methoud
extension ReminderListVC : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == ""{
            loadItem()
        }
        else{
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            //query
            let p = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.predicate = p
            // sorting result accending
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            do{
                Rlist = try context.fetch(request) 
            }
            catch{
                printContent("error fetching data \(error)")
            }
            //refresh
            tableView.reloadData()
        }
    }
}
