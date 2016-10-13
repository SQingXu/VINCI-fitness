//
//  PageControlViewController.swift
//  VINCIFitness
//
//  Created by David Xu on 10/1/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit

class PageControlViewController: UIViewController,UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var viewcontrollers: [UIViewController] = [SignupViewController(nibName: "SignupViewController", bundle: nil), SecondProfileViewController(nibName: "SecondProfileViewController", bundle: nil)]
    
    var pageControl = UIPageControl(frame: CGRect(x: 50, y: 300, width: 200, height: 20))
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageControl()
    }
    func configurePageControl(){
        func configurePageControl() {
            self.pageControl.numberOfPages = 2
            self.pageControl.currentPage = 0
            self.pageControl.tintColor = UIColor.red
            self.pageControl.pageIndicatorTintColor = UIColor.black
            self.pageControl.currentPageIndicatorTintColor = UIColor.green
            self.view.addSubview(pageControl)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewcontrollers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard viewcontrollers.count > previousIndex else {
            return nil
        }
        pageControl.currentPage = previousIndex
        return viewcontrollers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewcontrollers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = viewcontrollers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        pageControl.currentPage = nextIndex
        return viewcontrollers[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewcontrollers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewcontrollers.first,
            let firstViewControllerIndex = viewcontrollers.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }


}
