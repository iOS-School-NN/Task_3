//
//  ModuleAssembler.swift
//  task3.ios.school
//
//  Created by XO on 19.07.2021.
//  Copyright © 2021 XO. All rights reserved.
//

import UIKit

protocol ModuleAssembling {
    func createMainModule(router: MainRouting) -> UIViewController
    func createDetailModule(character: Character, image: UIImage, router: MainRouting) -> UIViewController
}

class ModuleAssembler: ModuleAssembling {

    
    func createMainModule(router: MainRouting) -> UIViewController {
        let startViewComtroller = ViewController()
        startViewComtroller.router = router
        return startViewComtroller
    }
    
    func createDetailModule(character: Character, image: UIImage, router: MainRouting) -> UIViewController {
        let detailViewController = DetailViewController()
        detailViewController.router = router
        detailViewController.passedCharacter = character
        detailViewController.passedImage = image
        return detailViewController
    }
}
