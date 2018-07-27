//
//  Todo.swift
//  Oblako
//
//  Created by Aldres on 25.07.2018.
//  Copyright © 2018 Aldres. All rights reserved.
//
import Foundation;
import SwiftyJSON;

class Todo{
    var id:Int
    var text:String
    var isCompleted:Bool
    
    init(id: Int, text: String, isCompleted: Bool){
        self.id = id;
        self.text = text;
        self.isCompleted = isCompleted;
    }
    
    init(){
        self.id = -1;
        self.text  = "Uknown"
        self.isCompleted = false;
    }
    
    init(json: JSON){
        self.id = json["id"].int!;
        self.text = json["text"].string!;
        self.isCompleted = json["isCompleted"].bool!;
    }
}
