//
//  ViewController.swift
//  CoreData-ToDo
//
//  Created by NTS on 03/01/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var models = [ToDoListItem]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.name
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        let sheet = UIAlertController(title: "Edit Item", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            
            let alert = UIAlertController(title: "Edit Item", message: "Edit your item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name
            alert.addAction(UIAlertAction(title: "save", style: .cancel, handler: {[weak self] _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    return
                }
                
                self?.updateItem(item: item, newName: newName)
            }))
            self.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "delete", style: .destructive, handler: { _ in
            self.deleteItem(item: item)
        }))
        present(sheet, animated: true)
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//   let tableView1: UITableView = {
//            let table = UITableView()
//        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        return cell
//    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
       title = "CoreData To Do List"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc
    private func didTapAdd(){
        let alert = UIAlertController(title: "New Item", message: "Enter new Item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "submit", style: .cancel, handler: {[weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            
            self?.createItem(name: text)
        }))
        present(alert, animated: true)
    }
    //MARK: - CoreData
    
    //MARK: - GetAllItems
    func getAllItems(){
        do{
            models = try context.fetch(ToDoListItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }catch {
            //error
            print(error)
        }
    }

    //MARK: - CreateItem
    func createItem(name: String){
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        
        do{
            try context.save()
            getAllItems()
        }catch{
            print(error)
        }
    }
    
    //MARK: - DeleteItem
    func deleteItem(item: ToDoListItem){
        context.delete(item)
        
        do{
            try context.save()
            getAllItems()
        }catch{
            print(error)
        }
    }
    
    //MARK: - UpdateItem
    func updateItem(item: ToDoListItem, newName: String){
        item.name = newName
        
        do{
            try context.save()
            getAllItems()
        }catch{
            print(error)
        }
    }

}

