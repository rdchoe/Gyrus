//
//  GyrusAllLogsPage.swift
//  Gyrus
//
//  Created by Robert Choe on 6/18/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import Foundation
import UIKit

class GyrusAllLogsPageViewController: UIViewController {
    
    private let headerWrapperView: UIView = {
        let headerWrapperView = UIView()
        headerWrapperView.translatesAutoresizingMaskIntoConstraints = false
        headerWrapperView.backgroundColor = UIColor.clear
        return headerWrapperView
    }()
    
    private let headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Dreams"
        headerLabel.font = UIFont(name: Constants.font.futura, size: Constants.font.h3)
        headerLabel.textColor = Constants.colors.white
        return headerLabel
    }()
    
    private let headerSublabel: UILabel = {
        let headerSublabel = UILabel()
        headerSublabel.translatesAutoresizingMaskIntoConstraints = false
        headerSublabel.text = "populate me pls"
        headerSublabel.font = UIFont(name: Constants.font.futura, size: Constants.font.body)
        headerSublabel.textColor = Constants.colors.gray
        return headerSublabel
    }()
   
    private let noDreamsLabel: UILabel = {
        let noDreamsLabel = UILabel()
        noDreamsLabel.translatesAutoresizingMaskIntoConstraints = false
        noDreamsLabel.text = "No dreams logged yet :("
        noDreamsLabel.font = UIFont(name: Constants.font.futura, size: Constants.font.h6)
        noDreamsLabel.textColor = Constants.colors.gray
        return noDreamsLabel
    }()
    
    lazy var dreams: [Dream] = {
        return AppDelegate.appCoreDateManager.fetchAllDreams()
    }()
    
    lazy var dreamsTable: UITableView = {
        let dreamsTableView = UITableView()
        dreamsTableView.backgroundColor = UIColor.clear
        dreamsTableView.translatesAutoresizingMaskIntoConstraints = false
        dreamsTableView.delegate = self
        dreamsTableView.dataSource = self
        dreamsTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        dreamsTableView.register(DreamCellView.self, forCellReuseIdentifier: "dreamCell")
        dreamsTableView.tableFooterView = UIView()
        return dreamsTableView
    }()
    
    private let testView: UIView = {
        let testView = UIView()
        testView.translatesAutoresizingMaskIntoConstraints = false
        testView.backgroundColor = Constants.colors.grayBlue
        return testView
    }()
    
    fileprivate var filtered = [Dream]()
    fileprivate var filterring = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.tabBarController?.title = "Dreams"
    }
    private func setupViewController() {
        if let createPage = self.tabBarController?.viewControllers?[1] as? GyrusCreateDreamPageViewController {
            createPage.delegate = self
        }
        
        setupNavBar()
        
        self.view.setGradientBackground(colorOne: #colorLiteral(red: 0.08831106871, green: 0.09370639175, blue: 0.1314730048, alpha: 1), colorTwo: #colorLiteral(red: 0.09751460701, green: 0.1287023127, blue: 0.1586345732, alpha: 1))
        if dreams.count == 0 {
            noDreamsLabel.isHidden = false
        } else {
            noDreamsLabel.isHidden = true
        }
        
        if let gyrusTabBarController = self.tabBarController as? GyrusTabBarController {
            gyrusTabBarController.gyrusTabBar.delegate = self
            gyrusTabBarController.gyrusTabBar.mainEventButton.setTitle("Create", for: .normal)
            gyrusTabBarController.gyrusTabBar.mainEventButton.titleLabel?.font = UIFont(name: Constants.font.futura, size: Constants.font.h5)
        }
        layoutConstraints()
    }
    
    private func setupNavBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Dreams"
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
    }

    private func layoutConstraints() {
        let marginsGuide = view.layoutMarginsGuide
        dreamsTable.addSubview(noDreamsLabel)
        view.addSubview(dreamsTable)
        view.addSubview(testView)
        
        
        NSLayoutConstraint.activate([
            testView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            testView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            //testView.bottomAnchor.constraint(equalTo: dreamsTable.topAnchor, constant: 200),
            //testView.heightAnchor.constraint(equalToConstant: 20),
            self.dreamsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.dreamsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.dreamsTable.topAnchor.constraint(equalTo: marginsGuide.topAnchor),
            self.dreamsTable.bottomAnchor.constraint(equalTo: marginsGuide.bottomAnchor),
            noDreamsLabel.centerXAnchor.constraint(equalTo: dreamsTable.centerXAnchor),
            noDreamsLabel.centerYAnchor.constraint(equalTo: dreamsTable.centerYAnchor),
        ])
    }
}

extension GyrusAllLogsPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterring ? self.filtered.count : self.dreams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dreamCell", for: indexPath) as! DreamCellView
        cell.dream = self.filterring ? self.filtered[indexPath.row] : self.dreams[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            self.dreams.remove(at: indexPath.row)
            let cell = tableView.cellForRow(at: indexPath) as! DreamCellView
            AppDelegate.appCoreDateManager.deleteDream(byID: cell.dream.id!)
            tableView.deleteRows(at: [indexPath]
                , with: UITableView.RowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension GyrusAllLogsPageViewController: CreateDreamDelegate {
    func dreamCreated() {
        self.dreams = AppDelegate.appCoreDateManager.fetchAllDreams()
        self.dreamsTable.reloadData()
    }
}


extension GyrusAllLogsPageViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            self.filtered = self.dreams.filter({(dream) -> Bool in
                return dream.content!.lowercased().contains(text.lowercased())
            })
            self.filterring = true
        } else {
            self.filterring = false
            self.filtered = [Dream]()
        }
        self.dreamsTable.reloadData()
    }
}

extension GyrusAllLogsPageViewController: GyrusTabBarDelegate {
    func mainEventButtonClicked(button: UIButton) {
        self.navigationController?.pushViewController(GyrusCreateDreamPageViewController(), animated: true)
    }
    
    
}
