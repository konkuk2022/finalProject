//
//  DailyViewController.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/01.
//

import UIKit

final class DailyViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .systemBackground
        self.configure()
    }
    
    private func configure() {
        self.configureTabBarItems()
    }
    
    private func configureTabBarItems() {
        let emotion = EmotionViewController()
        let movie = MovieViewController()
        self.configureTab(controller: emotion, title: "감정", imageName: "face.smiling", selectedImageName: "face.smiling.fill")
        self.configureTab(controller: movie, title: "영화", imageName: "film", selectedImageName: "film.fill")
        self.viewControllers = [emotion, movie]
    }
    
    private func configureTab(controller: UIViewController, title: String, imageName: String, selectedImageName: String) {
        let image = UIImage(systemName: imageName)
        let selectedImage = UIImage(systemName: imageName)
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        controller.tabBarItem = tabBarItem
    }    
}
