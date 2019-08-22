//
//  AppCoordinator.swift
//  ReduxNotes
//
//  Created by Dima Osadchy on 12/08/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

import UIKit

extension Actions {
    enum Application {
        struct DidFinishLaunch: Action {}
    }
}

final class AppCoordinator {
    private lazy var window: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        return window
    }()
    
    private lazy var dispatch = CommandWith(action: StoreLocator.shared.dispatch)
    private var rootViewController = ContainerScreenFactory.default()
    
    func configure() {
        UIView.appearance().isExclusiveTouch = true
        window.rootViewController = rootViewController
        rootViewController.displayContentController(ContainerScreenFactory.splash())
    }
    
    func handle(_ state: State, action: Action) {
        switch action {
        case is Actions.Application.DidFinishLaunch:
            self.rootViewController.displayContentController(MenuScreenFactory().mainMenu())
        default:
            break
        }
    }
}
