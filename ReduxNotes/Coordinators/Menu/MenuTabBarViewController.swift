//
//  MenuTabBarViewController.swift
//  ReduxNotes
//
//  Created by Dima Osadchy on 12/08/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

import UIKit

private enum TabBarItem {
    case personalNotes
    case commonNotes
    
    var tag: Int {
        switch self {
        case .personalNotes:
            return 1
        case .commonNotes:
            return 2
        }
    }
    
    var ui: UITabBarItem {
        switch self {
        case .personalNotes:
            return UITabBarItem(title: "Personal Notes", image: nil, tag: tag)
        case .commonNotes:
            return UITabBarItem(title: "Common Notes", image: nil, tag: tag)
        }
    }
    
    init?(tag: Int) {
        switch tag {
        case TabBarItem.personalNotes.tag:
            self = .personalNotes
        case TabBarItem.commonNotes.tag:
            self = .commonNotes
        default:
            return nil
        }
    }
}

class MenuTabBarViewController: UITabBarController {
    struct Props {
        let personalNote: Command
        let commonNotes: Command
        let endObserving: Command
    }
    
    private var props = Props(personalNote: .nop, commonNotes: .nop, endObserving: .nop)
    
    deinit {
        props.endObserving.perform()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar(personalNotes: UINavigationController(rootViewController: MenuScreenFactory().personalNotes(router: self)), commonNotes: UINavigationController(rootViewController: MenuScreenFactory().commonNotes(router: self)))
    }
    
    func render(props: Props) {
        self.props = props
        view.setNeedsLayout()
    }

    func configureTabBar(personalNotes: UINavigationController, commonNotes: UINavigationController) {
        personalNotes.tabBarItem = TabBarItem.personalNotes.ui
        commonNotes.tabBarItem = TabBarItem.commonNotes.ui
        setViewControllers([personalNotes, commonNotes], animated: false)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let tabBarItem = TabBarItem(tag: item.tag) else {
            return
        }
        
        switch tabBarItem {
        case .commonNotes:
            props.commonNotes.perform()
        case .personalNotes:
            props.personalNote.perform()
        }
    }
    
    // MARK: - Private
    //
    private func push(controller: UIViewController) {
        guard let navigation = selectedViewController as? UINavigationController else { return }
        navigation.pushViewController(controller, animated: true)
    }
    
    private func present(controller: UIViewController, command: Command? = nil) {
        present(controller, animated: false, completion: { command?.perform() })
    }
    
    private func popCurrentViewController() {
        guard let navigation = selectedViewController as? UINavigationController else { return }
        navigation.popViewController(animated: false)
    }
    
    private func dismissCurrentViewController() {
        dismiss(animated: true)
    }
}

extension MenuTabBarViewController: AllNotesRouting {
    func selectNote(noteId: AllNotes.Id) {
        push(controller: MenuScreenFactory().connectDetails(router: self, noteID: noteId))
    }
    
    func addNewNote(context: NewNotePresenter.Context) {
        present(controller: UINavigationController(rootViewController: MenuScreenFactory().newNote(router: self, context: context)))
    }
}

extension MenuTabBarViewController: NoteDetailsRouting {
    func edit(noteId: AllNotes.Id) {
        present(controller: UINavigationController(rootViewController: MenuScreenFactory().editNote(router: self, noteId: noteId)), command: Command { self.popCurrentViewController() })
    }
}

extension MenuTabBarViewController: NewNoteRouting {
    func dismiss() {
        dismissCurrentViewController()
    }
}
