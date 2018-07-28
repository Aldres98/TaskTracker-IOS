//
//  ProjectsController.swift
//  TaskTracker-IOS
//
//  Created by Aldres on 25.07.2018.
//  Copyright © 2018 Aldres. All rights reserved.
//


import UIKit;
import M13Checkbox;
import Alamofire;
import SwiftyJSON;

class ProjectsController: UITableViewController, SwitchDelegate{
    
    @IBOutlet var myTableView: UITableView!
    var projects: [Project] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func didFinishSwitch(switchState:Bool){
        UpdateProjects()
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    
    func UpdateProjects(){
        Alamofire.request("https://radiant-island-23944.herokuapp.com/projects.json").responseJSON(completionHandler: {
            response in
            switch response.result{
            case .success:
                self.projects.removeAll()
                self.projects = []
                let json = JSON(response.result.value!)
                for (_,subJson):(String, JSON) in json {
                    self.projects.append(Project(title: subJson["title"].string!))
                }
                
                Alamofire.request("https://radiant-island-23944.herokuapp.com/todo.json").responseJSON(completionHandler: {
                    response in
                    switch response.result{
                    case .success:
                        let json = JSON(response.result.value!)
                        for (_,subJson):(String, JSON) in json {
                            let project_id = (subJson["project_id"].int)! - 1
                            self.projects[project_id].addTodo(todo: Todo(json: subJson))
                        }
                        self.myTableView.reloadData()
                    default:
                        print( "Error" )
                    }
                })
            default:
                print( "Error" )
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //[self, setNeedsStatusBarAppearanceUpdate] as [Any];
        UpdateProjects()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.projects.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.projects[section].todos.count)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "header")
        
        header?.textLabel?.text = self.projects[section].title
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TodoCell
        cell.todoText!.text = self.projects[indexPath.section].todos[indexPath.row].text
        
        
        if self.projects[indexPath.section].todos[indexPath.row].isCompleted == true{
            (cell.checkBox as! M13Checkbox).setCheckState(M13Checkbox.CheckState.checked, animated: false)
        } else {
            (cell.checkBox as! M13Checkbox).setCheckState(M13Checkbox.CheckState.unchecked, animated: false)
        }
        
        labelStrikeThrough(cell: cell)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TodoCell
        (cell.checkBox as! M13Checkbox).toggleCheckState()
        labelStrikeThrough(cell: cell);
        

        Alamofire.request("https://radiant-island-23944.herokuapp.com/todo/" +
            String(self.projects[indexPath.section].todos[indexPath.row].id), method: .put)
        
    }
    
    func labelStrikeThrough(cell: TodoCell){
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (cell.todoText?.text)!)
        if (cell.checkBox as! M13Checkbox).checkState == M13Checkbox.CheckState.checked{
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        }else{
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, 0))
        }
        cell.todoText?.attributedText = attributeString;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        UpdateProjects()
        var projectNames:[String] = []
        for project in self.projects{ projectNames.append(project.title) };
        
        let nav = segue.destination as! UINavigationController
        ( (nav).topViewController as! CreateTodoController ).projectNames = projectNames
        ( (nav).topViewController as! CreateTodoController ).delegate = self
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
