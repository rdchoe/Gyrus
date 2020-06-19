//
//  GyrusCreateDreamPage.swift
//  Gyrus
//
//  Created by Robert Choe on 6/4/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import Foundation
import UIKit

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
        dreamLogTextView.text = Constants.dreamLogPage.placeholderText
        dreamLogTextView.keyboardDismissMode = .onDrag
        dreamLogTextView.alwaysBounceVertical = true
        dreamLogTextView.textColor = Constants.colors.gray
        dreamLogTextView.font = UIFont(name: Constants.font.futura, size: Constants.font.body)
        
        return dreamLogTextView
    }()
    
    private var relatedCategories = NSMutableSet()
    
    /// The state of the page that toggles when the main event button is clicked (each page should have this to determine the button functionality and title)
    private var pageState: PageState = .notSelected
    
    private var categories: [[Category]] = [[],[],[]]
    private var numberOfCategoryRows = 3
    private var hasStartedLogging = false
    private var dreamLogTextViewBottomAnchor: NSLayoutConstraint!
    private var keyboardHeight: CGFloat = 8.0

    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let gyrusTabBarController = self.tabBarController as? GyrusTabBarController {
            gyrusTabBarController.gyrusTabBar.delegate = self
            gyrusTabBarController.gyrusTabBar.mainEventButton.setTitle("Save", for: .normal)
            gyrusTabBarController.gyrusTabBar.mainEventButton.titleLabel?.font = UIFont(name: Constants.font.futura, size: Constants.font.h5)
        }
    }
    
    private func setupViewController() {
        // adding gradient
        self.view.setGradientBackground(colorOne: #colorLiteral(red: 0.08831106871, green: 0.09370639175, blue: 0.1314730048, alpha: 1), colorTwo: #colorLiteral(red: 0.09751460701, green: 0.1287023127, blue: 0.1586345732, alpha: 1))
        self.populateCategories()
        /*
         Setting up the collection view.
         Have to this here since the custom flow layout class needs access to categories array after its been populated
        */
        self.categoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CategoryCollectionViewLayout(categories: self.categories))
        self.categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.categoriesCollectionView.backgroundColor = UIColor.clear
        self.categoriesCollectionView.showsHorizontalScrollIndicator = false
        
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        categoriesCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "categoryCell")
        dreamLogTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        self.createCategoryButton.addTarget(self, action: #selector(createCategoryButtonClicked), for: .touchUpInside)
        
        view.addSubview(categoryHeaderWrapperView)
        categoryHeaderWrapperView.addSubview(categoryHeaderLabel)
        categoryHeaderWrapperView.addSubview(createCategoryButton)
        //categoryHeaderWrapperView.addSubview(expandCategoryButton)
        categoryHeaderWrapperView.addSubview(subCategoryHeaderLabel)
        view.addSubview(categoriesCollectionView)
        view.addSubview(separator)
        view.addSubview(dreamLogTextView)
        
        layoutConstraints()
    }
    
    private func layoutConstraints() {
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            categoryHeaderWrapperView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 16),
            categoryHeaderWrapperView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            categoryHeaderWrapperView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            
            categoryHeaderLabel.topAnchor.constraint(equalTo: categoryHeaderWrapperView.topAnchor),
            categoryHeaderLabel.bottomAnchor.constraint(equalTo: categoryHeaderWrapperView.bottomAnchor),
            categoryHeaderLabel.leadingAnchor.constraint(equalTo: categoryHeaderWrapperView.leadingAnchor),
            subCategoryHeaderLabel.leadingAnchor.constraint(equalTo: categoryHeaderLabel.trailingAnchor, constant: 4),
            subCategoryHeaderLabel.bottomAnchor.constraint(equalTo: categoryHeaderLabel.bottomAnchor, constant: -2),
            createCategoryButton.topAnchor.constraint(equalTo: categoryHeaderWrapperView.topAnchor),
            createCategoryButton.bottomAnchor.constraint(equalTo: categoryHeaderWrapperView.bottomAnchor),
            createCategoryButton.trailingAnchor.constraint(equalTo: categoryHeaderWrapperView.trailingAnchor),
            categoriesCollectionView.topAnchor.constraint(equalTo: categoryHeaderWrapperView.bottomAnchor, constant: 8),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: (Constants.category.cellHeight *  CGFloat(self.categoriesCollectionView.numberOfSections)) + (CGFloat(self.categoriesCollectionView.numberOfSections) * 8)),
            
            separator.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            separator.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor, constant: 8),
            separator.heightAnchor.constraint(equalToConstant: 2.0),
            
            dreamLogTextView.topAnchor.constraint(equalTo: separator.bottomAnchor),
            dreamLogTextView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            dreamLogTextView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
        ])
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
        self.categories.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.categories[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        //cell.emoji.text = categories[indexPath.row].emoji
        cell.category = categories[indexPath.section][indexPath.row]
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
}

// MARK: Text view delegate-
extension GyrusCreateDreamPageViewController: UITextViewDelegate {
    /**
     Returns the number of real words the user has currently typed in the text box.
     - Returns: An int representing the number of words in *dreamLogTextBox*
     */
    func getWordCount() -> Int {
        let components = self.dreamLogTextView.text.components(separatedBy:NSCharacterSet.whitespacesAndNewlines.union(.punctuationCharacters))
        let words = components.filter { !$0.isEmpty }
        return words.count
    }
    
    func textViewDidChange(_ textView: UITextView) {
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
}

// MARK: Collection View Delegate-
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
            //AppDelegate.appCoreDateManager.addDream(title: separatedContent[0], content: self.dreamLogTextView.text, relatedCategories: self.relatedCategories as NSSet)
        }
        
    }
}


// MARK: Create Category Bottom Sheet Delegate-
extension GyrusCreateDreamPageViewController: CreateCategoryBottomSheetDelegate {
    func categoryCreated() {
        
        self.populateCategories()
        if let flowLayout = self.categoriesCollectionView.collectionViewLayout as? CategoryCollectionViewLayout {
            flowLayout.categories = self.categories
        }
        self.categoriesCollectionView.reloadData()
    }
}

// MARK: Helpers-
extension GyrusCreateDreamPageViewController {
    private func populateCategories() {
        self.categories = formatCategories()
    }
    
    private func formatCategories() -> [[Category]] {
        var formattedCategories: [[Category]] = [[],[],[]]
        for (index,category) in AppDelegate.appCoreDateManager.fetchAllCategories().enumerated() {
            formattedCategories[index % numberOfCategoryRows].append(category)
        }
        return formattedCategories
    }
}
