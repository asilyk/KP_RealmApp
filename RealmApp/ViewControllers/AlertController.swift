//
//  AlertController.swift
//  RealmApp
//
//  Created by Alexander Ilyk on 20.05.2024.
//  Copyright © 2024 Alexander Ilyk. All rights reserved.
//

import UIKit

class AlertController: UIAlertController {
    var doneButton = "Save"

    static func createAlert(withTitle title: String, andMessage message: String) -> AlertController {
        AlertController(title: title, message: message, preferredStyle: .alert)
    }

    func action(with taskList: TaskList?, completion: @escaping (String) -> Void) {

        if taskList != nil { doneButton = "Обновить" }

        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            guard let newValue = self.textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            completion(newValue)
        }

        let cancelAction = UIAlertAction(title: "Отменить", style: .destructive)

        addAction(saveAction)
        addAction(cancelAction)
        addTextField { textField in
            textField.placeholder = "Название списка"
            textField.text = taskList?.name
        }
    }

    func action(with task: Task?, completion: @escaping (String, String) -> Void) {

        if task != nil { doneButton = "Обновить" }

        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            guard let newTask = self.textFields?.first?.text else { return }
            guard !newTask.isEmpty else { return }

            if let note = self.textFields?.last?.text, !note.isEmpty {
                completion(newTask, note)
            } else {
                completion(newTask, "")
            }
        }

        let cancelAction = UIAlertAction(title: "Отменить", style: .destructive)

        addAction(saveAction)
        addAction(cancelAction)

        addTextField { textField in
            textField.text = task?.name
            textField.placeholder = "Название списка"
        }

        addTextField { textField in
            textField.text = task?.note
            textField.placeholder = "Заметка"
        }
    }
}
