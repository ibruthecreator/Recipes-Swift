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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /// API search for recipes to populate table view with suggestions
    /// - Parameter sender: Data source of text, like a text field (searchTextField, in this case)
    @IBAction func searchChanged(_ sender: Any) {
        if let sender = sender as? UITextField, let search = sender.text {
            Recipes.sharedInstance.autocompleteIngredients(from: search) { (success) in
                if success {
                    print("updated")
                    self.autocompleteTableView.reloadData()
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
        print("Count: \(Recipes.sharedInstance.autocompleteIngredients.count)")
        return Recipes.sharedInstance.autocompleteIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as? IngredientSearchTableViewCell {
            
            cell.delegate = self
            cell.ingredient = Recipes.sharedInstance.autocompleteIngredients[indexPath.row]
            cell.updateContent()
        }
        
        return UITableViewCell()
    }
}

// MARK: - IngredientCellDelegate
extension SearchManuallyViewController: IngredientCellDelegate {
    func didAddIngredient() {
        self.basketCollectionView.reloadData()
    }
}
