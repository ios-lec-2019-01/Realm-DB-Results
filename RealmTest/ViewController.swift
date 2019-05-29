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

class ViewController: UIViewController {
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var ageLabel: UITextField!
    @IBOutlet weak var resultTextView: UITextView!
    
    var personArray : Results<Person>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(NSHomeDirectory())
        
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
        
    }
    
    @IBAction func getValue(_ sender: Any) {
        // DB에서 값 가져오기
        let realm = try! Realm()
        
        // 현재 상태의 DB에 저장된 값(객체) 가져오기
        personArray = realm.objects(Person.self).filter("age > 10")
        print("count = \(personArray!.count)")
        
        if personArray!.count == 0 {
            return
        } else {
            for i in personArray! {
                resultTextView.text = resultTextView.text! + "Name: \(i.name), Age: \(i.age)\n"
            }
        }
    }
    
    @IBAction func deleteValue(_ sender: Any) {
        let realm = try! Realm()
        try! realm.write {
            //realm.deleteAll()
            realm.delete(personArray!)
        }
        resultTextView.text = ""

    }
}

