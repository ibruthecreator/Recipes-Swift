//
//  HomeViewController.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2019-12-30.
//  Copyright © 2019 Mohammed Ibrahim. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var startScanningButton: UIButton!
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // Onboarding collection view content
    let images: [String] = ["Scanning", "Results", "Recipes"]
    let titles: [String] = ["Scan for ingredients", "Add items to your basket", "Find recipes"]
    let descriptions: [String] = ["Using your camera, hover over any ingredients you have in your house. These can be anything from milk to cauliflower to salmon to pasta. Using an ML model, the app will recognize it right away!", "When you find the ingredient you're looking for from our results, simply add it to your basket and continue on with the next ingredient.", "Once you're finished, you'll be able to find all types of recipes that you can whip up using the ingredients you added to your basket, just like that!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
    }
    

    // MARK: - Setup Views
    func setupViews() {
        startScanningButton.layer.cornerRadius = 8
        startScanningButton.backgroundColor = UIColor.Theme.green
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        onboardingCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        onboardingCollectionView.collectionViewLayout = flowLayout
        
        pageControl.numberOfPages = titles.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor.Theme.green
        pageControl.pageIndicatorTintColor = UIColor.lightGray
    }
    
    // MARK: - Start Button
    @IBAction func startScanningButtonWasPressed(_ sender: Any) {
        #if targetEnvironment(simulator)
            let errorAlert = UIAlertController(title: "App must be used on a real device", message: "Since this app makes use of the built-in camera on an iPhone, it must be run on a real device and not in the simulator.\n\nAlso, in the case that this is a Shopify engineer using this, 👋.", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            errorAlert.addAction(dismissAction)
            present(errorAlert, animated: true, completion: nil)
        #else
            self.performSegue(withIdentifier: "goToScanView", sender: self)
        #endif
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onboardingCell", for: indexPath) as! OnboardingCollectionViewCell
        
        cell.onboardingImageView.image = UIImage(named: images[indexPath.row])
        cell.titleLabel.text = titles[indexPath.row]
        cell.descriptionTextView.text = descriptions[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}

