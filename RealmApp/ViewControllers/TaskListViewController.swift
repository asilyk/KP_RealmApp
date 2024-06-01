//
//  TaskListsViewController.swift
//  RealmApp
//
//  Created by Alexander Ilyk on 20.05.2024.
//  Copyright © 2024 Alexander Ilyk. All rights reserved.
//

import RealmSwift
import UIKit

class TaskListViewController: UITableViewController {
    // MARK: - Private Properties
    private var taskLists: Results<TaskList>!

    // MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        createTempData()
        taskLists = StorageManager.shared.realm.objects(TaskList.self)
        navigationItem.leftBarButtonItem = editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        taskLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)
        let taskList = taskLists[indexPath.row]
        var content = cell.defaultContentConfiguration()
        let numberOfCurrentTasks = taskList.tasks.filter("isComplete = false").count

        content.text = taskList.name
        if numberOfCurrentTasks == 0, !taskList.tasks.isEmpty {
            content.secondaryText = "✅"
        } else {
            content.secondaryText = "\(numberOfCurrentTasks)"
        }
        cell.contentConfiguration = content
        return cell
    }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let taskList = taskLists[indexPath.row]

        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in
            StorageManager.shared.delete(taskList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }

        let editAction = UIContextualAction(style: .normal, title: "Изменить") { _, _, isDone in
            self.showAlert(with: taskList) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }

        let doneAction = UIContextualAction(style: .normal, title: "Готово") { _, _, isDone in
            StorageManager.shared.done(taskList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            isDone(true)
        }

        editAction.backgroundColor = .orange
        doneAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)

        return UISwipeActionsConfiguration(actions: [doneAction, editAction, deleteAction])
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        guard let tasksVC = segue.destination as? TasksViewController else { return }
        let taskList = taskLists[indexPath.row]

        tasksVC.taskList = taskList
    }

    // MARK: - IB Actions
    @IBAction func addButtonPressed(_: Any) {
        showAlert()
    }

    @IBAction func sortingList(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            taskLists = taskLists.sorted(byKeyPath: "date", ascending: true)
        } else {
            taskLists = taskLists.sorted(byKeyPath: "name", ascending: true)
        }
        tableView.reloadData()
    }

    // MARK: - Private Methods
    private func createTempData() {
        DataManager.shared.createTempData {
            self.tableView.reloadData()
        }
    }
}

// MARK: - AlertController
extension TaskListViewController {
    private func showAlert(with taskList: TaskList? = nil, completion: (() -> Void)? = nil) {
        let alert = AlertController.createAlert(withTitle: "Новый список", andMessage: "Пожалуйста, введите новое значение")

        alert.action(with: taskList) { newValue in
            if let taskList = taskList, let completion = completion {
                StorageManager.shared.edit(taskList, newValue: newValue)
                completion()
            } else {
                self.save(newValue)
            }
        }
        present(alert, animated: true)
    }

    private func save(_ taskList: String) {
        let taskList = TaskList(value: [taskList])
        StorageManager.shared.save(taskList)

        let rowIndex = IndexPath(row: taskLists.index(of: taskList) ?? 0, section: 0)
        tableView.insertRows(at: [rowIndex], with: .automatic)
    }
}
