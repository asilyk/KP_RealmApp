//
//  DataManager.swift
//  RealmApp
//
//  Created by Alexander Ilyk on 20.05.2024.
//  Copyright © 2024 Alexander Ilyk. All rights reserved.
//

import Foundation

class DataManager {
    static let shared = DataManager()

    private init() {}

    func createTempData(_ completion: @escaping () -> Void) {
        if !UserDefaults.standard.bool(forKey: "done") {
            UserDefaults.standard.set(true, forKey: "done")

            let shoppingList = TaskList()
            shoppingList.name = "Список покупок"

            let moviesList = TaskList(value: ["Список фильмов", Date(), [["Любимое"], ["Лучшие фильмы", "К просмотру", Date(), true]]])

            let milk = Task()
            milk.name = "Молоко"
            milk.note = "2л"

            let bread = Task(value: ["Хлеб", "", Date(), true])
            let apples = Task(value: ["name": "Яблоки", "note": "2кг"])

            shoppingList.tasks.append(milk)
            shoppingList.tasks.insert(contentsOf: [bread, apples], at: 1)

            DispatchQueue.main.async {
                StorageManager.shared.save([shoppingList, moviesList])
                completion()
            }
        }
    }
}
