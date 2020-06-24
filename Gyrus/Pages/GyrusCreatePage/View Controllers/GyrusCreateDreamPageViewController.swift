//
//  GyrusCreateDreamPage.swift
//  Gyrus
//
//  Created by Robert Choe on 6/4/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

protocol CreateDreamDelegate {
    func dreamCreated()
}

class GyrusCreateDreamPageViewController: UIViewController {
    
    /**
               |-CreateDreamPageViewController-|
               |       |------Header stack view------|   |
               |       |    |-----------------------|           |   |
               |       |    |Category Label   |    v     |   |
               |       |    |-----------------------|           |   |
               |       |-------------------------------------|   |
               |     |------------------------------------|      |
               |     |Categories Collection View|      |
               |     |------------------------------------|      |
               |            -----separator-----                 |
               |          |-----------------------------|         |
               |          |Dream Log (text view)|         |
               |          |                                   |         |
               |          |                                   |         |
               |          |                                   |         |
               |          |                                   |         |
               |          |-----------------------------|         |
               |----------------------------------------------|
    */
   
    /// The vertical stack view container all the visual componets of the page
    private let contentWrapperView: UIView = {
        let contentWrapperView = UIView()
        contentWrapperView.translatesAutoresizingMaskIntoConstraints = false
        contentWrapperView.backgroundColor = UIColor.clear
        return contentWrapperView
    }()
    
    /// The horizontal stack view container containing the category label, add button, and expand button
    private let categoryHeaderWrapperView: UIView = {
        let categoryHeaderWrapperView = UIView()
        categoryHeaderWrapperView.translatesAutoresizingMaskIntoConstraints = false
        categoryHeaderWrapperView.backgroundColor = UIColor.clear
        return categoryHeaderWrapperView
    }()
    
    /// The category header label
    private let categoryHeaderLabel: UILabel = {
        let categoryHeaderLabel = UILabel()
        categoryHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryHeaderLabel.font = UIFont(name: Constants.font.futura, size: Constants.font.h6)
        categoryHeaderLabel.text = Constants.dreamLogPage.categoryHeaderText
        categoryHeaderLabel.textColor = Constants.colors.whiteTextColor
        categoryHeaderLabel.backgroundColor = UIColor.clear
        return categoryHeaderLabel
    }()
    
    /// Select all that apply label
    private let subCategoryHeaderLabel: UILabel = {
        let subCategoryHeaderLabel = UILabel()
        subCategoryHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        subCategoryHeaderLabel.font = UIFont(name: Constants.font.futura_italic, size: Constants.font.subtitle)
        subCategoryHeaderLabel.text = "Select all that apply"
        subCategoryHeaderLabel.textColor = Constants.colors.gray
        subCategoryHeaderLabel.backgroundColor = UIColor.clear
        return subCategoryHeaderLabel
    }()
   /*
    /// The expand button that expands the category collection view
    private let expandCategoryButton: UIButton = {
        let expandCategoryButton = UIButton()
        expandCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        expandCategoryButton.setImage(#imageLiteral(resourceName: "expand"), for: .normal)
        expandCategoryButton.backgroundColor = UIColor.clear
        return expandCategoryButton
    }()
 */
    
    private let createCategoryButton: UIButton = {
        let createCategoryButton = UIButton()
        createCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        let plusIcon = UIImage(named: "plus")?.imageWithColor(color: .white)
        createCategoryButton.setImage(plusIcon, for: .normal)
        createCategoryButton.backgroundColor = UIColor.clear
        return createCategoryButton
    }()
    
    public var categoriesCollectionView: UICollectionView! = nil
    
    private let separator: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = Constants.colors.gray
        return separator
    }()
    
    private let dreamLogTextView: UITextView = {
        let dreamLogTextView = UITextView()
        dreamLogTextView.translatesAutoresizingMaskIntoConstraints = false
        dreamLogTextView.backgroundColor = UIColor.clear
        dreamLogTextView.font = UIFont(name: Constants.font.futura_light, size: Constants.font.body)
        dreamLogTextView.text = Constants.dreamLogPage.placeholderText
        dreamLogTextView.keyboardDismissMode = .onDrag
        dreamLogTextView.alwaysBounceVertical = true
        dreamLogTextView.textColor = Constants.colors.gray
        
        
        return dreamLogTextView
    }()
    
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.backgroundColor = UIColor.clear
        dateLabel.font = UIFont(name: Constants.font.futura, size: Constants.font.subtitle)
        dateLabel.textColor = Constants.colors.gray
        let dateFormatter = DateFormatter()
        let dateFormat = "MMMM dd, yyyy 'at' h:mm a"
        
        dateFormatter.dateFormat = dateFormat
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "AM"
        dateLabel.text = dateFormatter.string(from: Date())
        return dateLabel
    }()
    private let keywords: JSON = {
        if let path = Bundle.main.url(forResource: "keywords", withExtension: ".json") {
            do {
                let pathAsData = try Data(contentsOf: path, options: .dataReadingMapped)
                let json = try JSON(data: pathAsData)
                return json
            } catch {
                fatalError("Could not find keywords file")
            }
        }
        return JSON()
    }()
    
    private var relatedCategories = NSMutableSet()
    
    /// The state of the page that toggles when the main event button is clicked (each page should have this to determine the button functionality and title)
    private var pageState: PageState = .notSelected
    
    private var dreamLogTextViewTopAnchor: NSLayoutConstraint!
    private var categoriesCollectionViewTopAnchor: NSLayoutConstraint!

    private var categories: NSMutableOrderedSet = NSMutableOrderedSet()
    private var numberOfCategoryRows = 3
    private var hasStartedLogging = false
    private var dreamLogTextViewBottomAnchor: NSLayoutConstraint!
    private var keyboardHeight: CGFloat = 8.0
    var delegate: CreateDreamDelegate!

    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.largeTitleDisplayMode = .never
        setupViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.title = ""
        if let gyrusTabBarController = self.tabBarController as? GyrusTabBarController {
            gyrusTabBarController.gyrusTabBar.delegate = self
            gyrusTabBarController.gyrusTabBar.mainEventButton.setTitle("Save", for: .normal)
            gyrusTabBarController.gyrusTabBar.mainEventButton.titleLabel?.font = UIFont(name: Constants.font.futura, size: Constants.font.h5)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupViewController() {
        self.navigationItem.largeTitleDisplayMode = .never
        // adding gradient
        self.view.setGradientBackground(colorOne: #colorLiteral(red: 0.08831106871, green: 0.09370639175, blue: 0.1314730048, alpha: 1), colorTwo: #colorLiteral(red: 0.09751460701, green: 0.1287023127, blue: 0.1586345732, alpha: 1))
        setupCollectionView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        self.createCategoryButton.addTarget(self, action: #selector(createCategoryButtonClicked), for: .touchUpInside)
        
        view.addSubview(dateLabel)
        view.addSubview(categoriesCollectionView)
        view.addSubview(dreamLogTextView)
        
        layoutConstraints()
    }
    
    func setupCollectionView() {
        /*
         Setting up the collection view.
         Have to this here since the custom flow layout class needs access to categories array after its been populated
        */
        self.categoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CategoryCollectionViewLayout(categories: self.categories.array as! [Category]))
        self.categoriesCollectionView.alpha = 0.0
        self.categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.categoriesCollectionView.backgroundColor = UIColor.clear
        self.categoriesCollectionView.showsHorizontalScrollIndicator = false
        
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        categoriesCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "categoryCell")
        dreamLogTextView.delegate = self
    }
    
    private func layoutConstraints() {
        let margins = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: margins.topAnchor),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 30),
            dreamLogTextView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            dreamLogTextView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
        ])
        
        self.categoriesCollectionViewTopAnchor = categoriesCollectionView.topAnchor.constraint(equalTo: dateLabel.topAnchor)
        categoriesCollectionViewTopAnchor.isActive = true
        self.dreamLogTextViewTopAnchor = dreamLogTextView.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor)
        dreamLogTextViewTopAnchor.isActive = true
        if let gyrusTabBarController = self.tabBarController as? GyrusTabBarController {
            dreamLogTextViewBottomAnchor = dreamLogTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -gyrusTabBarController.gyrusTabBar.frame.height)
        } else {
            dreamLogTextViewBottomAnchor = dreamLogTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        }
        dreamLogTextViewBottomAnchor.isActive = true
        
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            var anchorConstant: CGFloat = 0
            if endFrameY < UIScreen.main.bounds.size.height {
                anchorConstant = -endFrame!.height
            } else {
                if let gyrusTabBarController = self.tabBarController as? GyrusTabBarController {
                    anchorConstant = -gyrusTabBarController.gyrusTabBar.frame.height
                } else {
                    anchorConstant = 0
                }
            }
            UIView.animate(withDuration: duration,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: {
             self.dreamLogTextViewBottomAnchor.constant = anchorConstant
             self.view.layoutIfNeeded()
             },
            completion: nil)
        }
    }
    
    @objc func createCategoryButtonClicked() {
        let bottomSheetViewController = GyrusCreateCategoryBottomSheetViewController()
        bottomSheetViewController.modalPresentationStyle = .custom
        bottomSheetViewController.transitioningDelegate = self
        bottomSheetViewController.delegate = self
        self.present(bottomSheetViewController, animated: true)
    }
}

// MARK: Collection View Delegate-
extension GyrusCreateDreamPageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        //cell.emoji.text = categories[indexPath.row].emoji
        cell.category = categories.object(at: indexPath.row) as? Category
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
        if cell.toggleActiveState() { // we need to add this category
            self.relatedCategories.add(cell.category!)
        } else { // we need to remove this category
            self.relatedCategories.remove(cell.category!)
        }
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let cell = cell as? CategoryCollectionViewCell {
                animateCell(cell: cell)
            }
        }
    }
    
    private func animateCell(cell: CategoryCollectionViewCell) {
        cell.alpha = 0.0
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut,animations: {
            cell.alpha = 1.0
        })
    }
}

// MARK: Text view delegate-
extension GyrusCreateDreamPageViewController: UITextViewDelegate {
    /**
     Returns the number of real words the user has currently typed in the text box.
     - Returns: An int representing the number of words in *dreamLogTextBox*
     */
    private func getWordCount() -> Int {
        let components = self.dreamLogTextView.text.components(separatedBy:NSCharacterSet.whitespacesAndNewlines.union(.punctuationCharacters))
        let words = components.filter { !$0.isEmpty }
        return words.count
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let currentWord = textView.currentWord {
            if let existing_keyword = self.keywords[currentWord.lowercased()].string {
                let category = AppDelegate.appCoreDateManager.fetchCategory(byName: existing_keyword)!
                self.addNewCategory(category: category)
                if (self.categories.count == 1) {
                    animateCategoriesView()
                }
                self.updateCategoriesCollectionView()
            }
        }
        let currWordCount = getWordCount()
        if currWordCount >= 50 {
            // do something here
        } else {
            //self.wordCountLabel.text = String(currWordCount) + "/50"
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !hasStartedLogging {
            self.dreamLogTextView.text = nil
            self.dreamLogTextView.textColor = Constants.colors.whiteTextColor
            self.hasStartedLogging = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.dreamLogTextView.text.isEmpty {
            self.dreamLogTextView.text = Constants.dreamLogPage.placeholderText
            self.dreamLogTextView.textColor = Constants.colors.gray
            self.hasStartedLogging = false
        }
    }
    
    private func animateCategoriesView() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut,animations: {
            self.categoriesCollectionViewTopAnchor.constant = 20
            self.view.layoutIfNeeded()
        }, completion: { _ in
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut,animations: {
                self.categoriesCollectionView.alpha = 1.0
            })
        })
    }
}

// MARK: UIViewControllerTransitioningDelegate-
/// Tells this view controller that it should use the custom presentation controller we created @BottomSheetPresentationController
extension GyrusCreateDreamPageViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BottomSheetPresentationController(presentedViewController: presented, presenting: presenting, blurEffectStyle: .dark)
    }
}

// MARK: Tab Bar Delegate-
extension GyrusCreateDreamPageViewController: GyrusTabBarDelegate {
    func mainEventButtonClicked(button: UIButton) {
        switch self.pageState {
        case .selected:
            self.pageState = .notSelected
        case .notSelected:
            self.pageState = .selected
        }
        let separatedContent = self.dreamLogTextView.text.components(separatedBy: CharacterSet.newlines)
        if separatedContent.count > 0 {
            AppDelegate.appCoreDateManager.addDream(title: separatedContent[0], content: self.dreamLogTextView.text, relatedCategories: self.relatedCategories as NSSet)
        self.delegate.dreamCreated()
        }
        
    }
}


// MARK: Create Category Bottom Sheet Delegate-
extension GyrusCreateDreamPageViewController: CreateCategoryBottomSheetDelegate {
    func categoryCreated() {
        print("unimplemtned")
    }
    
    
    func addNewCategory(category: Category) {
        self.categories.insert(category, at: 0)
        if let flowLayout = self.categoriesCollectionView.collectionViewLayout as? CategoryCollectionViewLayout {
            flowLayout.categories = self.categories.array as! [Category]
        }
        self.categoriesCollectionView.reloadData()
    }
}

// MARK: Helpers-
extension GyrusCreateDreamPageViewController {
    
    private func updateCategoriesCollectionView() {
        if let flowLayout = self.categoriesCollectionView.collectionViewLayout as? CategoryCollectionViewLayout {
            flowLayout.categories = self.categories.array as! [Category]
        }
        self.categoriesCollectionView.reloadData()
    }
}
