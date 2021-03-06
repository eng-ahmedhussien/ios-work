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
    var selectedCategory :  Categroys?{
        
        didSet{
            loadItem()
        }
        
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    //MARK: addbutton. to add item in list
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title:"add item", message:"", preferredStyle: .alert)
        
        //MARK: add textfiled in alert
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
        }
        
        let okButton = UIAlertAction(title: "add", style: .default) { action in
            if textField.text != ""{
                
                self.addNewItem(title: textField.text!,checked:false)
                //MARK: add item to context (temproray area)
                self.saveItems()
                
            }
            
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
    
    func addNewItem(title:String,checked:Bool){
        let i = Item(context:context)
        i.title = title
        i.checked = checked
        i.parent = selectedCategory
        Rlist.append(i)
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
    
    
    func loadItem(request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil){
        
        //query
        let categoryPredicate = NSPredicate(format: "parent.name MATCHES %@",selectedCategory!.name!)
        
        if let addpredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addpredicate])
        }
        else{
            request.predicate = categoryPredicate
        }
        
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
//MARK: sreachbar methouds
extension ReminderListVC : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //query
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // sorting result accending
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItem(request: request,predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0{
            loadItem()
            //searchBar.resignFirstResponder() will not work without placed inside DispatchQueue.main.async
            DispatchQueue.main.async {
                // remove keyboard indicator from searchbar and hide keyboard
                searchBar.resignFirstResponder()
            }
        }
    }
}


