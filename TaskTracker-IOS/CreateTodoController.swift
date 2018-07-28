//
//  CreateTodoController.swift
//  TaskTracker-IOS
//
//  Created by Aldres on 25.07.2018.
//  Copyright © 2018 Aldres. All rights reserved.
//


import UIKit;
import SwiftyJSON;
import Alamofire;

protocol SwitchDelegate {
    func didFinishSwitch(switchState:Bool)
}

class CreateTodoController: UITableViewController {
    
    var delegate:SwitchDelegate? = nil
    
    var projectNames:[String] = []

    @IBAction func createTodo(_ sender: Any) {
        if ((myTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TodoTextCell).todoTextField.text?.isEmpty)!{
            let alert = UIAlertController(title: "Ошибка", message: "Введите название задачи", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel){ (alertAction) in })
            self.present(alert, animated: true, completion: nil)
        }else{
            if (myTableView.indexPathForSelectedRow?.row == nil) {
                
                let json:Parameters = [ "text":(myTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TodoTextCell).todoTextField.text!,
                                        "project_id": 1, "isCompleted": false]
                Alamofire.request("https://radiant-island-23944.herokuapp.com/todo/create", method: .post, parameters: json, encoding: JSONEncoding.default)
                delegate?.didFinishSwitch(switchState: true)
                self.dismiss(animated: true, completion: nil)
            } else {
            
            let json:Parameters = [ "text":(myTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TodoTextCell).todoTextField.text!,
                                    "project_id": (myTableView.indexPathForSelectedRow?.row)!+1, "isCompleted": false]
            Alamofire.request("https://radiant-island-23944.herokuapp.com/todo/create", method: .post, parameters: json, encoding: JSONEncoding.default)
            delegate?.didFinishSwitch(switchState: true)
            self.dismiss(animated: true, completion: nil)
            }
        }
        }
    
    @IBAction func pushBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBOutlet var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        myTableView.selectRow(at: IndexPath(row: 0, section: 1), animated: false, scrollPosition: UITableViewScrollPosition.none)
        myTableView.cellForRow(at: IndexPath(row: 0, section: 1))?.accessoryType = UITableViewCellAccessoryType.checkmark
        myTableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section==0){ return 1 }else{ return projectNames.count };
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "todoText", for: indexPath) as! TodoTextCell
            cell.todoTextField!.layer.borderColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.0).cgColor
            cell.todoTextField!.layer.borderWidth = 1.3
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath)
            cell.textLabel?.text = projectNames[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "header")
        if section==0{ header?.textLabel?.text = "Задача" }else{ header?.textLabel?.text = "Категория"}
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section==0{ return 60 }else{ return 50 }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 1{ return };
        for cell in tableView.visibleCells{
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
