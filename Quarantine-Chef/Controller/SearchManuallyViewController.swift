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
    var impactGenerator = UIImpactFeedbackGenerator(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.autocompleteTableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Recipes.sharedInstance.autocompleteIngredients.removeAll()
    }
    
    // MARK: - Setup Views
    func setupViews() {
        continueButton.layer.cornerRadius = 8
        autocompleteTableView.showsVerticalScrollIndicator = false
        autocompleteTableView.allowsSelection = false
    }
    
    /// API search for recipes to populate table view with suggestions
    /// - Parameter sender: Data source of text, like a text field (searchTextField, in this case)
    @IBAction func searchChanged(_ sender: Any) {
        if let sender = sender as? UITextField, let search = sender.text {
            Recipes.sharedInstance.autocompleteIngredients(from: search) { (success) in
                if success {
                    DispatchQueue.main.async {
                        UIView.performWithoutAnimation {
                            self.autocompleteTableView.reloadData()
                            self.autocompleteTableView.beginUpdates()
                            self.autocompleteTableView.endUpdates()
                        }
//                        self..reloadData()
                    }
                    return
                } else {
                    print("completion fail")
                }
            }
        }
    }
    
    // Dismiss keyboard
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    // Exit to home page
    @IBAction func exitButtonWasPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - UITableViewDelegate
extension SearchManuallyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If empty, return 1 cell which will act as the "empty" cell message
        return Recipes.sharedInstance.autocompleteIngredients.count == 0 ? 1 : Recipes.sharedInstance.autocompleteIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // No search results returned, show an empty message
        if Recipes.sharedInstance.autocompleteIngredients.count == 0 {
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
            if Recipes.sharedInstance.autocompleteIngredients.indices.contains(indexPath.row) {
                let ingredient = Recipes.sharedInstance.autocompleteIngredients[indexPath.row]
                cell.ingredient = ingredient
                cell.updateContent()
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

// MARK: - UICollectionViewDelegate
extension SearchManuallyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Prediction.sharedInstance.basket.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

// MARK: - IngredientCellDelegate
extension SearchManuallyViewController: IngredientCellDelegate {
    func didAddIngredient() {
        impactGenerator.impactOccurred()
        self.basketCollectionView.reloadData()
        self.resignFirstResponder()
    }
}
