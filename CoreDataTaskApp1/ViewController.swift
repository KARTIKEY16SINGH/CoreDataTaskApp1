//
//  ViewController.swift
//  CoreDataTaskApp1
//
//  Created by Iron Man on 29/11/25.
//

import UIKit

protocol TaskListViewable: AnyObject {
    func updateView()
}

class ViewController: UIViewController {
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    } ()
    
    private var viewModel: TaskListViewModelable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel?.performAction(.viewLoaded)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        layoutTableView()
        tableView.dataSource = self
        tableView.register(TaskListCell.self, forCellReuseIdentifier: TaskListCell.reuseIdentifier)
    }
    
    private func layoutTableView() {
        var constraints: [NSLayoutConstraint] = []
        constraints.append(tableView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1))
        constraints.append(tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0))
        constraints.append(tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0))
        constraints.append(tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0))
        constraints.append(tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0))
        constraints.append(tableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1))
        constraints.forEach{$0.isActive = true}
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
    func updateView() {
        tableView.reloadData()
    }
}

