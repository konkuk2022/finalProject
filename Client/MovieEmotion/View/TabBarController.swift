//
//  TabBarController.swift
//  MovieEmotion
//
//  Created by Inwoo Park on 2022/11/09.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private lazy var homeViewController: MainViewController = {
        let home = MainViewController()
        home.tabBarItem = UITabBarItem(
            title: .none,
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        return home
    }()
    
    private lazy var chartViewController: EmotionTotalViewController = {
        let chart = EmotionTotalViewController()
        chart.tabBarItem = UITabBarItem(
            title: .none,
            image: UIImage(systemName: "chart.bar"),
            selectedImage: UIImage(systemName: "chart.bar.fill")
        )
        return chart
    }()
    
    private lazy var settingViewController: SettingViewController = {
        let setting = SettingViewController()
        setting.tabBarItem = UITabBarItem(
            title: .none,
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        return setting
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 5)
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .black
        tabBar.backgroundColor = .white
        viewControllers = [UINavigationController(rootViewController: homeViewController), chartViewController, settingViewController]
    }
    
    public func resetSavedDiary() {
        homeViewController.updateSnapshot()
    }
    
}

extension CALayer {
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
}

extension UITabBar {
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
