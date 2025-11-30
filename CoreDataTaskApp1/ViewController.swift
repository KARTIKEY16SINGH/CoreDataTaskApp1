//
//  ViewController.swift
//  CoreDataTaskApp1
//
//  Created by Iron Man on 29/11/25.
//

import UIKit

protocol TaskListViewable: AnyObject {
    func dataDidUpdate()
    func onAddButtonClicked()
}

final class ViewController: UIViewController {
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    } ()
    
    private var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var tapGestureRecognizer: UITapGestureRecognizer?
    
    private var viewModel: TaskListViewModelable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupAddButton()
        viewModel?.performAction(.viewLoaded)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        layoutTableView()
        tableView.dataSource = self
        tableView.register(TaskListCell.self, forCellReuseIdentifier: TaskListCell.reuseIdentifier)
    }
    
    private func setupAddButton() {
        view.addSubview(addButton)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapAddButton))
        addButton.setTitle("Add Task", for: .normal)
        addButton.addGestureRecognizer(tapGestureRecognizer)
        self.tapGestureRecognizer = tapGestureRecognizer
        layoutAddButton()
    }
    
    private func layoutTableView() {
        var constraints: [NSLayoutConstraint] = []
        constraints.append(tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0))
        constraints.append(tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0))
        constraints.append(tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0))
        constraints.append(tableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1))
        constraints.forEach{$0.isActive = true}
    }
    
    private func layoutAddButton() {
        addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        addButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 0).isActive = true
    }
    
    @objc
    private func didTapAddButton() {
        viewModel?.performAction(.addButtonClicked)
    }
    
    func build(with viewModel: TaskListViewModelable) {
        self.viewModel = viewModel
        self.viewModel?.view = self
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.getNumberOfItems() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = viewModel?.getItem(forRow: indexPath.row), let cell = tableView.dequeueReusableCell(withIdentifier: TaskListCell.reuseIdentifier) as? TaskListCell else {
            return .init()
        }
        cell.updateView(with: item)
        return cell
    }
    
}

extension ViewController: TaskListViewable {
    func onAddButtonClicked() {
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        alert.addTextField()
        let addAction = UIAlertAction(title: "Add", style: .default) {[weak alert, weak self] action in
            guard let self, let alert, let textField = alert.textFields?.first else { return }
            debugPrint("Inside Alert Action")
            self.viewModel?.performAction(.addTask(textField.text))
        }
        
        alert.addAction(addAction)
        
        present(alert, animated: true)
    }
    
    func dataDidUpdate() {
        tableView.reloadData()
    }
}

