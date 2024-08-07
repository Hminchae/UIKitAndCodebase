//
//  ViewController.swift
//  TaskAppWithMVVM
//
//  Created by 황민채 on 6/6/24.
//

import UIKit

class ToDoListViewController: UIViewController {
    
    let viewModel = TaskListViewModel()
    
    lazy var tableView: UITableView = {
       let v = UITableView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.dataSource = self
        v.delegate = self
        v.register(ToDoTableViewCell.self, forCellReuseIdentifier: "ToDoCell")
        v.register(SummaryTableViewCell.self, forCellReuseIdentifier: "SummaryCell")
        v.estimatedRowHeight = 200
        v.rowHeight = UITableView.automaticDimension
        
        return v
    }()
    
    lazy var celebrationAnimationView: CelebrationAnimationView = {
        let v = CelebrationAnimationView(fileName: "Lottie")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true

        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Thanky's Tasks"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(celebrationAnimationView)
        NSLayoutConstraint.activate([
            celebrationAnimationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            celebrationAnimationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            celebrationAnimationView.topAnchor.constraint(equalTo: view.topAnchor),
            celebrationAnimationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /*
    override func viewDidAppear(_ animated: Bool) {
        celebrationAnimationView.play { finished in
            print("Done")
        }
    }
    */
    
    @objc func addNewTask() {
        navigationController?.pushViewController(AddNewTaskViewController(),  animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getAll()
        tableView.reloadData()
    }
}

/* 📎 For reference only
class ToDoListViewController: UIViewController {
    
    lazy var addNewButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Add Task", for: .normal)
        v.addTarget(self, 
                    action: #selector(addNewTask(sender: )),
                    for: .touchUpInside)
        return v
    }()
    
    lazy var getTasksButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Get Task", for: .normal)
        v.addTarget(self, 
                    action: #selector(getTask(sender: )),
                    for: .touchUpInside)
        return v
    }()
    
    lazy var toggleCompletedButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Mark Task", for: .normal)
        v.addTarget(self,
                    action: #selector(markComplted(sender: )),
                    for: .touchUpInside)
        return v
    }()
    
    lazy var deleteTaskdButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Delete Task", for: .normal)
        v.addTarget(self,
                    action: #selector(deleteTask(sender: )),
                    for: .touchUpInside)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Thanky's Tasks"
        
        // add views
        [addNewButton, getTasksButton, toggleCompletedButton, deleteTaskdButton].forEach { control in
            view.addSubview(control)
        }
        
        // add constraints
        NSLayoutConstraint.activate([
            addNewButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addNewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addNewButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            getTasksButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            getTasksButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            getTasksButton.topAnchor.constraint(equalTo: addNewButton.bottomAnchor, constant: 8),
            
            toggleCompletedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            toggleCompletedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            toggleCompletedButton.topAnchor.constraint(equalTo: getTasksButton.bottomAnchor, constant: 8),
            
            deleteTaskdButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            deleteTaskdButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            deleteTaskdButton.topAnchor.constraint(equalTo: toggleCompletedButton.bottomAnchor, constant: 8),
            
            
        ])
    }
    
    // MARK: - Action function
    @objc func addNewTask(sender: UIButton) {
        CoreDataManager.shared.addNewTask(name: "과자먹기", dueOn: Date().addingTimeInterval(100000))
    }
    
    @objc func getTask(sender: UIButton) {
        let tasks = CoreDataManager.shared.getAll()
        for task in tasks {
            print(task.name ?? "")
        }
    }
    
    @objc func markComplted(sender: UIButton) {
        let tasks = CoreDataManager.shared.getAll()
        for task in tasks {
            CoreDataManager.shared.toggleCompleted(id: task.id ?? UUID())
        }
        
        let fetchTasks = CoreDataManager.shared.getAll()
        for task in fetchTasks {
            print("\(task.name ?? ""): \(task.completed), \(task.completedOn?.formatted(date: .abbreviated, time: .omitted) ?? "")")
        }
    }
    
    @objc func deleteTask(sender: UIButton) {
        let tasks = CoreDataManager.shared.getAll()
        for task in tasks {
            CoreDataManager.shared.delete(id: task.id ?? UUID())
        }
        
        let fetchTasks = CoreDataManager.shared.getAll()
        print(fetchTasks.count)
        for task in fetchTasks {
            print("\(task.name ?? ""): \(task.completed), \(task.completedOn?.formatted(date: .abbreviated, time: .omitted) ?? "")")
        }
    }
}

*/
