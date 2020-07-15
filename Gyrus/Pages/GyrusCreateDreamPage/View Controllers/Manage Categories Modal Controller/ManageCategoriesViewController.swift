//
//  ManageCategoriesViewController.swift
//  Gyrus
//
//  Created by Robert Choe on 6/30/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import UIKit

protocol manageCategoriesDelegate {
    func didChangeCategories(updatedCategories: [Category])
}

class ManageCategoriesViewController: UIViewController {

    lazy var categoriesTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.allowsMultipleSelection = true
        return tv
    }()
    
    lazy var newCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Constants.colors.lightGray
        button.setTitle("New Category", for: .normal)
        button.titleLabel?.font = UIFont(name: Constants.font.futura, size: Constants.font.body)
        button.setTitleColor(Constants.colors.white, for: .normal)
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(pushNewCategoryViewController), for: .touchUpInside)
        return button
    }()
    
    /// The categories that relate to the currrent dream being logged
    fileprivate var relatedCategories: [Category] = []
    /// The remaining categories that do not include the related categories
    fileprivate var remainingCategories: [Category] = []
    
    fileprivate var allCategories: [Category] = []
    
    /// Search Bar Controller handling
    fileprivate var filtered = [Category]()
    fileprivate var filterring = false
    fileprivate let generator = UIImpactFeedbackGenerator(style: .soft)
    
    fileprivate var originalRelatedCategories: [Category] = []
    
    var delegate: manageCategoriesDelegate?
    
    init(relatedCategories: [Category], remainingCategories: [Category], delegate: manageCategoriesDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.relatedCategories = relatedCategories
        self.originalRelatedCategories = relatedCategories
        self.remainingCategories = remainingCategories
        self.delegate = delegate
        allCategories = relatedCategories + remainingCategories
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !relatedCategories.containSameElements(originalRelatedCategories) {
            self.delegate?.didChangeCategories(updatedCategories: self.relatedCategories)
        }
    }
    
    fileprivate func setupViewController() {
        view.setGradientBackground(colorOne: #colorLiteral(red: 0.08831106871, green: 0.09370639175, blue: 0.1314730048, alpha: 1), colorTwo: #colorLiteral(red: 0.09751460701, green: 0.1287023127, blue: 0.1586345732, alpha: 1))
        setupNavBar()
        setupTableView()
        view.addSubview(newCategoryButton)
        layoutConstraints()
    }
    
    fileprivate func setupNavBar() {
        self.title = "Manage Categories"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Constants.colors.gray, NSAttributedString.Key.font: UIFont(name: Constants.font.futura, size: Constants.font.body)!], for: .normal)
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = search
    }
    
    fileprivate func setupTableView() {
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        categoriesTableView.keyboardDismissMode = .onDrag
        view.addSubview(categoriesTableView)
    }
    
    fileprivate func layoutConstraints() {
        let marginsGuide = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            categoriesTableView.topAnchor.constraint(equalTo: marginsGuide.topAnchor),
            categoriesTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            categoriesTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            categoriesTableView.bottomAnchor.constraint(equalTo: self.newCategoryButton.topAnchor, constant: -8),
            newCategoryButton.heightAnchor.constraint(equalToConstant: 40),
            newCategoryButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8),
            newCategoryButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            newCategoryButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
}

// MARK: Table View Delegate
extension ManageCategoriesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterring ? self.filtered.count : allCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell else { fatalError() }
        cell.category = self.filterring ? self.filtered[indexPath.row] : allCategories[indexPath.row]
        if relatedCategories.contains(self.filterring ? self.filtered[indexPath.row] : allCategories[indexPath.row]) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        generator.impactOccurred()
        let category = self.filterring ? self.filtered[indexPath.row] : allCategories[indexPath.row]
        relatedCategories.append(category)
        remainingCategories.remove(object: category)
        if relatedCategories.containSameElements(originalRelatedCategories) {
            self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Constants.colors.inactiveColor, NSAttributedString.Key.font: UIFont(name: Constants.font.futura, size: Constants.font.body)!], for: .normal)
        } else {
            self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Constants.colors.activeColor, NSAttributedString.Key.font: UIFont(name: Constants.font.futura, size: Constants.font.body)!], for: .normal)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        generator.impactOccurred()
        let category = self.filterring ? self.filtered[indexPath.row] : allCategories[indexPath.row]
        relatedCategories.remove(object: category)
        remainingCategories.append(category)
        if relatedCategories.containSameElements(originalRelatedCategories)  {
            self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Constants.colors.gray], for: .normal)
        } else {
            self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Constants.colors.activeColor], for: .normal)
        }
    }
}

// MARK: Search Delegate
extension ManageCategoriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            self.filtered = self.allCategories.filter({(category) -> Bool in
                return category.name!.lowercased().contains(text.lowercased())
            })
            self.filterring = true
        } else {
            self.filterring = false
            self.filtered = [Category]()
        }
        self.categoriesTableView.reloadData()
    }
}

// MARK: Targets
extension ManageCategoriesViewController {
    @objc fileprivate func doneButtonPressed() {
        self.dismiss(animated: true, completion:nil)
    }
    
    @objc fileprivate func pushNewCategoryViewController() {
        let createCategoryViewController = GyrusCreateCategoryBottomSheetViewController()
        createCategoryViewController.delegate = self
        self.navigationController?.pushViewController(GyrusCreateCategoryBottomSheetViewController(), animated: true)
    }
}

extension ManageCategoriesViewController: CreateCategoryBottomSheetDelegate {
    func categoryCreated(category: Category ) {
        self.relatedCategories.append(category)
    }
    
    
}
