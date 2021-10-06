//
//  ViewController.swift
//  CoreDataDemoTask
//
//  Created by MAM OS 12 on 31/08/21.
//

import UIKit

class ViewController: UIViewController {
    var dataModel:[DataModel] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchCoreData()
    }
    func fetchCoreData(){
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            if let Coredata = try? context.fetch(DataModel.fetchRequest()) as! [DataModel]{
                dataModel = Coredata
                tableView.reloadData()
            }
        }
    }
    @IBAction func InsertButton(_ sender: Any) {
        let alert = UIAlertController(title: "Add Item", message: "Write name in textField and press add button", preferredStyle: .alert)
        alert.addTextField()
         let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
           if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
                let newItem = DataModel(context: context)
               if let name = alert.textFields![0].text{
                   print(name)
                   newItem.name = name
               }
               (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
               self.fetchCoreData()
            }
            
        }
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
}
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataModel[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete an Item!", message: "Are you Sure to delete data from CoreData", preferredStyle: .alert)
       
         let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "yes", style: .default) { _ in
           if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
               context.delete(self.dataModel[indexPath.row])
               (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
               self.fetchCoreData()
            }
            
        }
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        }
    
}
