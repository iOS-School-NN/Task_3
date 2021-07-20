//
//  MainRouter.swift
//  task3.ios.school
//
//  Created by XO on 19.07.2021.
//  Copyright © 2021 XO. All rights reserved.
//

import UIKit

protocol NavigationRouting {
    var navigationController: UINavigationController? { get set }
    var moduleAssembler: ModuleAssembling { get set }
}

protocol MainRouting: NavigationRouting {
    func initiateMainModule()
    func goToDetailModule(character: Character, image: UIImage)
    func goToModalDetailModule(character: Character, image: UIImage)
    
    init(navigationController: UINavigationController?, moduleAssembler: ModuleAssembling)
}

class MainRouter: MainRouting {
    

    var navigationController: UINavigationController?
    var moduleAssembler: ModuleAssembling
    
    required init(navigationController: UINavigationController?, moduleAssembler: ModuleAssembling) {
        self.navigationController = navigationController
        self.moduleAssembler = moduleAssembler
    }
    
    func initiateMainModule() {
        let startViewController = moduleAssembler.createMainModule(router: self)
        navigationController?.viewControllers = [startViewController]
    }
    
    func goToDetailModule(character: Character, image: UIImage) {
        let detailViewController = moduleAssembler.createDetailModule(character: character, image: image, router: self)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func goToModalDetailModule(character: Character, image: UIImage) {
        let detailViewController = moduleAssembler.createDetailModule(character: character, image: image, router: self)
        navigationController?.present(detailViewController, animated: true, completion: nil)
    }
}
