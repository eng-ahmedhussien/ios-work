//
//  CategroyVC.swift
//  Reminder Lits(angela)
//
//  Created by Ahmed Hussien on 23/01/2022.
//

import UIKit
import CoreData

class CategoryVC: UITableViewController {
    
    var list = [Categroys]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItem()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var text  = UITextField()
        let alart = UIAlertController(title:"add new item", message:"", preferredStyle: .alert)
        alart.addTextField { cText in
            cText.placeholder = "create new item"
            text = cText
        }
        let okButton = UIAlertAction(title: "add", style: .default) { action in
            if text.text != ""{
                let c = Categroys(context:self.context)
                c.name = text.text
                self.list.append(c)
                self.saveItem()
            }
        }
        alart.addAction(okButton)
        present(alart, animated: true, completion: nil)
    }
    func saveItem(){
        do{
            try context.save()
        }
        catch{
            print("error \(error)")
        }
        tableView.reloadData()
    }
    func loadItem(request:NSFetchRequest<Categroys> = Categroys.fetchRequest()){
       // let request : NSFetchRequest<Categroys> = Categroys.fetchRequest()
        do{
           list = try context.fetch(request)
        }
        catch{
            printContent("error fetching data \(error)")
        }
        tableView.reloadData()
    }
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return categoryList.count
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return list.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catgorycell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row].name
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        context.delete(list.remove(at: indexPath.row))
        saveItem()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let toReminderList = storyboard?.instantiateViewController(identifier:"ReminderListVC") as? ReminderListVC
        toReminderList?.selectedCategory = list[indexPath.row]
        navigationController?.pushViewController(toReminderList!, animated: true)
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
