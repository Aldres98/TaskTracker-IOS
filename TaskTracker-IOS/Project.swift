//
//  Project.swift
//  Oblako
//
//  Created by Aldres on 25.07.2018.
//  Copyright © 2018 Aldres. All rights reserved.
//

import Foundation

class Project{
    var title:String
    var todos:[Todo]
    
    init(title: String, todos: [Todo]){
        self.title = title;
        self.todos = todos;
    }
    
    init(title: String){
        self.title = title;
        self.todos = []
    }
    
    func clearTodos(){
        self.todos.removeAll()
    }
    
    init(){
        self.title = "Uknown"
        self.todos = []
    }
    
    func addTodo(todo: Todo){
        todos.append(todo)
    }
}
