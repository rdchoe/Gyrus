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

enum Direction {
    case up,down
}

protocol CreateDreamDelegate {
    func dreamCreated()
}

class GyrusCreateDreamPageViewController: UIViewController {
    
    public var categoriesCollectionView: UICollectionView! = nil
    
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
        dateFormatter.pmSymbol = "PM"
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
    fileprivate var dream: Dream?
    fileprivate var existingDreamLog: Bool = false
    fileprivate var fromAlarm: Bool = false
    var delegate: CreateDreamDelegate!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    convenience init(dream: Dream) {
        self.init(nibName: nil, bundle: nil)
        self.dreamLogTextView.text = dream.content
        self.dreamLogTextView.textColor = Constants.colors.white
        self.hasStartedLogging = true
        self.dream = dream
    }
    
    convenience init(fromAlarm: Bool) {
        self.init(nibName: nil, bundle: nil)
        self.fromAlarm = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
   
    /**
     Detect when the user presses the back button on the view controller, and determine if we need to save/update this dream log
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            let separatedContent = self.dreamLogTextView.text.components(separatedBy: CharacterSet.newlines)
            
            if separatedContent.count > 0 {
                if existingDreamLog {
                    AppDelegate.appCoreDateManager.updateDream(withID: self.dream!.id!, title: separatedContent[0], Content: self.dreamLogTextView.text, relatedCategories: self.relatedCategories as NSSet)
                } else {
                    AppDelegate.appCoreDateManager.addDream(title: separatedContent[0], content: self.dreamLogTextView.text, relatedCategories: self.relatedCategories as NSSet)
                }
                self.delegate.dreamCreated()
            }
        }
    }
    
    private func setupViewController() {
        self.navigationItem.largeTitleDisplayMode = .never
        let categoriesButton = UIBarButtonItem(title: "Categories", style: .plain, target: self, action: #selector(popupCategoryManager))
        categoriesButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: Constants.font.futura, size: Constants.font.h6)!], for: .normal)
        self.navigationItem.rightBarButtonItem = categoriesButton
        
        // adding gradient
        self.view.setGradientBackground(colorOne: #colorLiteral(red: 0.08831106871, green: 0.09370639175, blue: 0.1314730048, alpha: 1), colorTwo: #colorLiteral(red: 0.09751460701, green: 0.1287023127, blue: 0.1586345732, alpha: 1))
        setupCollectionView()
        dreamLogTextView.delegate = self
        
        if fromAlarm {
            if let gyrusTabBarController = self.tabBarController as? GyrusTabBarController {
                gyrusTabBarController.hideTabBar()
            }
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        view.addSubview(dateLabel)
        view.addSubview(categoriesCollectionView)
        view.addSubview(dreamLogTextView)
        
        layoutConstraints()
    
        // If we are coming back in to an existing log and there were related categories, we should show those categories
        if existingDreamLog && self.relatedCategories.count > 0 {
            self.animateCategoriesView(direction: .down)
        }
    }
    
    func setupCollectionView() {
        /*
         Setting up the collection view.
         Have to this here since the custom flow layout class needs access to categories array after its been populated
        */
        categoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CategoryCollectionViewLayout(categories: self.categories.array as! [Category]))
        categoriesCollectionView.alpha = 0.0
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoriesCollectionView.backgroundColor = UIColor.clear
        categoriesCollectionView.showsHorizontalScrollIndicator = false
        
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        categoriesCollectionView.backgroundView = UIView()
        categoriesCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "categoryCell")

        if let dream = self.dream {
            self.existingDreamLog = true
            if let relatedCategories = dream.relatedCategories {
                for case let category as Category in relatedCategories {
                    self.addNewCategory(category: category)
                }
            }
        }
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
}

// MARK: Target Functions-
extension GyrusCreateDreamPageViewController {
    @objc fileprivate func popupCategoryManager() {
        let allCategories = AppDelegate.appCoreDateManager.fetchAllCategories()
        let relatedCategories = Array(self.relatedCategories) as! [Category]
        let difference = allCategories.difference(from: relatedCategories)
        
        
        let bottomSheetViewController = ManageCategoriesNavigationController(relatedCategories: relatedCategories, remainingCategories: difference, delegate: self)
        bottomSheetViewController.modalPresentationStyle = .custom
        bottomSheetViewController.transitioningDelegate = self
        self.present(bottomSheetViewController, animated: true, completion: nil)
    }
    
    // Pushes the dream log text view so the user can keep typing above the keyboard
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
        self.navigationController?.pushViewController(GyrusCategoryPageViewController(category: cell.category!), animated: true)
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
                    animateCategoriesView(direction: .down)
                }
                self.updateCategoriesCollectionView()
            }
        }
        if fromAlarm {
            let currWordCount = getWordCount()
            if currWordCount >= 25 {
                // show tab bar
                if let gyrusTabBarController = self.tabBarController as? GyrusTabBarController {
                    gyrusTabBarController.showTabBar()
                }
                // show navigation bar
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            } else {
                //self.wordCountLabel.text = String(currWordCount) + "/50"
            }
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
    
    private func animateCategoriesView(direction: Direction) {
        switch direction {
        case .up:
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut,animations: {
                self.categoriesCollectionViewTopAnchor.constant = 0
                self.view.layoutIfNeeded()
            }, completion: { _ in
                UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut,animations: {
                    self.categoriesCollectionView.alpha = 0.0
                })
            })
        case .down:
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
}

// MARK: UIViewControllerTransitioningDelegate-
/// Tells this view controller that it should use the custom presentation controller we created @BottomSheetPresentationController
extension GyrusCreateDreamPageViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CenterSheetPresentationController(presentedViewController: presented, presenting: presenting)
        //return BottomSheetPresentationController(presentedViewController: presented, presenting: presenting, blurEffectStyle: .dark)
    }
}

// MARK: Tab Bar Delegate-
extension GyrusCreateDreamPageViewController: GyrusTabBarDelegate {
    func mainEventButtonClicked(button: UIButton) {
        let separatedContent = self.dreamLogTextView.text.components(separatedBy: CharacterSet.newlines)
        if separatedContent.count > 0 {
            self.delegate.dreamCreated()
        }
        
    }
}

extension GyrusCreateDreamPageViewController: manageCategoriesDelegate {
    func didChangeCategories(updatedCategories: [Category]) {
        if self.categories.count == 0 && updatedCategories.count > 0 {
            self.animateCategoriesView(direction: .down)
        }
        self.relatedCategories.removeAllObjects()
        self.categories.removeAllObjects()
        if updatedCategories.isEmpty {
            self.animateCategoriesView(direction: .up)
            self.updateCategoriesCollectionView()
        } else {
            for category in updatedCategories {
                self.addNewCategory(category: category)
            }
        }
    }
    
    
}

// MARK: Helpers-
extension GyrusCreateDreamPageViewController {
    
    private func updateCategoriesCollectionView() {
        if let flowLayout = self.categoriesCollectionView.collectionViewLayout as? CategoryCollectionViewLayout {
            flowLayout.categories = self.categories.array as? [Category]
        }
        self.categoriesCollectionView.reloadData()
        if (self.categories.count == 1) {
            animateCategoriesView(direction: .down)
        }
    }
    
    private func addNewCategory(category: Category) {
        self.relatedCategories.add(category)
        self.categories.insert(category, at: 0)
        if let flowLayout = self.categoriesCollectionView.collectionViewLayout as? CategoryCollectionViewLayout {
            flowLayout.categories = self.categories.array as? [Category]
        }
        self.categoriesCollectionView.reloadData()
    }
}
