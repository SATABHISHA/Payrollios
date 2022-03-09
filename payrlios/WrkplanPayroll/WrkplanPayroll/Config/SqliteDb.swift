//
//  SqliteDb.swift
//  WrkplanPayroll
//
//  Created by Debashis Pal on 09/03/22.
//

import Foundation
import SQLite3
import UIKit

/*class SqliteDb{
    
func CreateFile()-> Void{
    let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent("HeroesDatabase.sqlite")
}
    
};*/extension UIViewController {
    func CreateFile(){
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                   .appendingPathComponent("HeroesDatabase.sqlite")
    }
    
    func OpenDatabase() {
        var db: OpaquePointer?
        if sqlite3_open(CreateFile().) != SQLITE_OK {
                    print("error opening database")
                }
    }
    
}
