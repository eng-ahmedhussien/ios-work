//
//  ViewController.swift
//  Reminder Lits(angela)
//
//  Created by Ahmed Hussien on 25/11/2021.
//

import UIKit

class ReminderListVC: UITableViewController{
    
    var Rlist = [Item]()
    //MARK: customItems.plist file path
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("customItems.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addNewItem(title: "list1")
//        addNewItem(title: "list2")
//        addNewItem(title: "list3")
//        addNewItem(title: "list4")
        //MARK: decode (read) data from customItems.plist
        loadItemFromPlist()
    }
//MARK: addbutton. to add item in list
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title:"add item", message:"", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "add", style: .default) { action in
            if textField.text != ""{
                self.addNewItem(title: textField.text!)
               //MARK: add(encode) item to customItems.plist
                self.saveItemsInPlist()
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
        saveItemsInPlist()
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        Rlist.remove(at: indexPath.row)
        saveItemsInPlist()
    }
   
    func saveItemsInPlist(){
        do{
            let data = try PropertyListEncoder().encode(Rlist)
            try data.write(to:dataFilePath!)
        }
        catch{
            print("error !! \(error)")
        }
        tableView.reloadData()
    }
    func loadItemFromPlist(){
        do{
            if let data =  try? Data(contentsOf: dataFilePath!){
                Rlist = try PropertyListDecoder().decode([Item].self, from: data)
            }
        }
        catch{
            print("error !! \(error)")
        }
    }
    func addNewItem(title:String){
        let i = Item()
        i.title = title
        Rlist.append(i)
    }
}

