//
//  ViewController.swift
//  ToDoApp
//
//  Created by Sungur on 27.02.2022.
//

import UIKit

class TableViewController: UITableViewController, UISearchBarDelegate {

    
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var editTaskButton: UIButton!
    
    @IBOutlet weak var sortButton: UIButton!
    
    let model = Model()
    
    var alert = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
    
//        searchController.searchBar.placeholder = "Find Your Task"
//
//        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
        
//        searchController.searchBar.delegate = self
        
        tableView.separatorColor = .gray
        
        title = "Tasks"
        
        model.sortByTitle()
        tableView.reloadData()
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func addTaskButtonPress(_ sender: Any) {
        alert = UIAlertController(title: "Create new task", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Write new task here"
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
        }
        
        let createAlert = UIAlertAction(title: "Create", style: .default) { createAlert in
            
            guard let unwrTextFieldValue = self.alert.textFields?[0].text else { return }
            
            self.model.addTask(taskName: unwrTextFieldValue)
            self.model.sortByTitle()
            self.tableView.reloadData()
        }
        
        let cancelAlert = UIAlertAction(title: "Candel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAlert)
        alert.addAction(createAlert)
        present(alert, animated: true, completion: nil)
        createAlert.isEnabled = false
    }
    
    @IBAction func editTaskButtonPressed(_ sender: Any) {
        let editOn = UIImage(systemName: "pencil.slash")
        let editOff = UIImage(systemName: "pencil")
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        if model.sort {
            editTaskButton.setImage(editOn, for: .normal)
        } else {
            editTaskButton.setImage(editOff, for: .normal)
        }
        model.editClicked = !model.editClicked
    }
    
    @IBAction func sortButtonPressed(_ sender: Any) {
        let arrowUp = UIImage(systemName: "arrow.up")
        let arrrowDown = UIImage(systemName: "arrow.down")
        
        model.sort = !model.sort
        sortButton.setImage(model.sort ? arrowUp : arrrowDown, for: .normal)
        
        model.sortByTitle()
        
        tableView.reloadData()
    }
    
    
    
}

extension TableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.taskArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checked", for: indexPath) as! CheckTableViewCell
    
        cell.delegate = self
        
        let todo = model.taskArray[indexPath.row]
        
        cell.set(title: todo.text, checked: todo.isComplete)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if model.changeRow(at: indexPath.row) == true {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            model.taskArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        model.moveTask(startIndex: fromIndexPath.row, endIndex: to.row)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completionHandler) in
            self?.editCellContent(indexPath: indexPath)
            completionHandler(true)
        }
        editAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    func editCellContent(indexPath: IndexPath) {
        let cell = tableView(tableView, cellForRowAt: indexPath) as! CheckTableViewCell
        
        alert = UIAlertController(title: "Change your task", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
            textField.text = cell.label.text
        }
        
        let closeAlert = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let editAlert = UIAlertAction(title: "Edit", style: .default) { createAlert in
            guard let fields = self.alert.textFields, fields.count > 0 else {return}
            guard let txtValue = self.alert.textFields?[0].text else { return }
            
            self.model.updateTask(at: indexPath.row, with: txtValue)
            self.tableView.reloadData()
        }
        
        alert.addAction(closeAlert)
        alert.addAction(editAlert)
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func alertTextFieldDidChange(_ sender: UITextField) {
        guard let senderText = sender.text, alert.actions.indices.contains(1) else { return }
        
        let action = alert.actions[1]
        action.isEnabled = senderText.count > 1
    }
    
    
    
}

extension TableViewController: CustomCellDelegate {
    func editCell(cell: CheckTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        
        guard let unwrIndexPath = indexPath else { return }
        
        self.editCellContent(indexPath: unwrIndexPath)
        tableView.reloadData()
    }

    func deleteCell(cell: CheckTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        
        guard let unwrIndexPath = indexPath else { return }
        
        model.removeTask(at: unwrIndexPath.row)
        
        tableView.reloadData()
    }
}
