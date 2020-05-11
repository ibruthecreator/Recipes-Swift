//
//  SearchManuallyViewController.swift
//  Quarantine-Chef
//
//  Created by Mohammed Ibrahim on 2020-04-25.
//  Copyright © 2020 Mohammed Ibrahim. All rights reserved.
//

import UIKit

class SearchManuallyViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var autocompleteTableView: UITableView!
    @IBOutlet weak var basketCollectionView: UICollectionView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var basketCollectionViewHeightConstraint: NSLayoutConstraint!
    
    var impactGenerator = UIImpactFeedbackGenerator(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.autocompleteTableView.reloadData()
    }
    
    // MARK: - Setup Views
    /// Setups constraints and relavent design aspects
    func setupViews() {
        basketCollectionViewHeightConstraint.constant = 0
        self.reloadViews()
        
        // If empty, disable continue button
        if Ingredients.sharedInstance.basket.count == 0 {
            self.continueButton.disable()
        } else {
            self.continueButton.enable()
        }
        
        continueButton.layer.cornerRadius = 8
        autocompleteTableView.showsVerticalScrollIndicator = false
        autocompleteTableView.allowsSelection = false
        autocompleteTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: continueButton.frame.height + 40, right: 0)
        
        basketCollectionView.backgroundColor = UIColor.clear
        basketCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        basketCollectionView.register(UINib(nibName: "BasketCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "basketCell")
    }
    
    /// API search for recipes to populate table view with suggestions
    /// - Parameter sender: Data source of text, like a text field (searchTextField, in this case)
    @IBAction func searchChanged(_ sender: Any) {
        if let sender = sender as? UITextField, let search = sender.text {
            Ingredients.sharedInstance.autocompleteIngredients(from: search) { (success) in
                if success {
                    DispatchQueue.main.async {
                        UIView.performWithoutAnimation {
                            self.autocompleteTableView.reloadData()
                            
                            // Bottom two methods should help with preventing flicker when loading new images
                            self.autocompleteTableView.beginUpdates()
                            self.autocompleteTableView.endUpdates()
                        }
                    }
                    return
                } else {
                    print("completion fail")
                }
            }
        }
    }
    
    /// Reload views with smooth animation
    func reloadViews() {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    /// Exit to home page
    @IBAction func exitButtonWasPressed(_ sender: Any) {
        Ingredients.sharedInstance.clearBasketAndPredictions()
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - UITableViewDelegate
extension SearchManuallyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If empty, return 1 cell which will act as the "empty" cell message
        return Ingredients.sharedInstance.searchResults.count == 0 ? 1 : Ingredients.sharedInstance.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // No search results returned, show an empty message
        if Ingredients.sharedInstance.searchResults.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.numberOfLines = 0
            
            if searchTextField.text?.count == 0 {
                // No search yet or empty
                cell.textLabel?.text = "Search for an ingredient above"
            } else {
                if let search = searchTextField.text {
                    cell.textLabel?.text = "There are no ingredients matching \"\(search)\""
                }
            }
            return cell
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as? IngredientSearchTableViewCell {
            cell.delegate = self
            
            // TODO: - Fix index out of range bug
            if Ingredients.sharedInstance.searchResults.indices.contains(indexPath.row) {
                let ingredient = Ingredients.sharedInstance.searchResults[indexPath.row]
                cell.ingredient = ingredient
                cell.updateContent()
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

// MARK: - UICollectionViewDelegate
// Basket Collection View
extension SearchManuallyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        DispatchQueue.main.async {
            self.basketCollectionViewHeightConstraint.constant = Ingredients.sharedInstance.basket.count == 0 ? 0 : 37
            self.reloadViews()
            
            // If empty, disable continue button
            if Ingredients.sharedInstance.basket.count == 0 {
                self.continueButton.disable()
            } else {
                self.continueButton.enable()
            }
        }
        
        return Ingredients.sharedInstance.basket.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "basketCell", for: indexPath) as? BasketCollectionViewCell {
            cell.delegate = self
            cell.isDarkMode = true
            cell.ingredient = Ingredients.sharedInstance.basket[indexPath.row]
            cell.updateLabel()
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height

        return CGSize(width: 200, height: height)
    }
}

// MARK: - IngredientCellDelegate
extension SearchManuallyViewController: BasketCellDelegate {
    func didRemoveIngredient() {
        impactGenerator.impactOccurred()
        self.autocompleteTableView.reloadData()
        self.basketCollectionView.reloadData()
        self.resignFirstResponder()
    }
    func didAddIngredient() {
        impactGenerator.impactOccurred()
        self.autocompleteTableView.reloadData()
        self.basketCollectionView.reloadData()
        self.resignFirstResponder()
    }
}
