//
//  ViewController.swift
//  RealmTest
//
//  Created by 김종현 on 29/05/2019.
//  Copyright © 2019 김종현. All rights reserved.
//
// 객체 단위로 저장, 불러오기 : Results<Person>는 한번 불러오면 DB와 동기화되는 객체의 배열

import UIKit
import RealmSwift

class Person: Object {
    @objc dynamic var name = ""
    @objc dynamic var age = 0
}

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var ageLabel: UITextField!
    @IBOutlet weak var myTableView: UITableView!
    
    var personArray : Results<Person>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        print(NSHomeDirectory())
        
        nameLabel.becomeFirstResponder()
        
        // DB에서 값을 불러와야 personArray 사용 가능, 초기에는 nil
        let realm = try! Realm()
        personArray = realm.objects(Person.self)
        
        print("personArray = \(personArray!)")
    }

    @IBAction func saveValue(_ sender: Any) {
        let newPerson = Person()
        
        newPerson.name = nameLabel.text!
        newPerson.age = Int(ageLabel.text!)!
        
        // DB에 값 저장
        let realm = try! Realm()
        try! realm.write {
            realm.add(newPerson)
        }

        nameLabel.text = ""
        ageLabel.text = ""
        //ageLabel.resignFirstResponder()
        nameLabel.becomeFirstResponder()
        
        myTableView.reloadData()
        
    }
    
    @IBAction func deleteValue(_ sender: Any) {
        let realm = try! Realm()
        try! realm.write {
            //realm.deleteAll()
            realm.delete(personArray!)
        }
        myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (personArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "RE", for: indexPath)
        cell.textLabel?.text = personArray?[indexPath.row].name
        
        let myAge = personArray?[indexPath.row].age
        cell.detailTextLabel?.text = String(myAge!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            // DB의 값 삭제
            let realm = try! Realm()
            try! realm.write {
                realm.delete(personArray![indexPath.row])
            }
            // DB의 update 된 값을 읽어 온다
            personArray = realm.objects(Person.self)
        
            // 테이블뷰의 cell을 삭제한다.
            myTableView.deleteRows(at: [indexPath], with: .fade)
            self.myTableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}

