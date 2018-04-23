//
//  AccountViewController.swift
//  Appella Health
//
//  Created by F.Q. on 28.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SVProgressHUD

class AccountViewController: BaseViewController {
    
    //MARK: - Properties
    
    var kitchen: AccountKitchen!

    //MARK: - Outlets
    
    @IBOutlet private var tableView: UITableView!
    
    //MARK: - Dependency Injection
    
    func inject(kitchen: AccountKitchen) {
        self.kitchen = kitchen
    }
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: AccountTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: AccountTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        removeBackButtonTitle()
        addTextToRightBarItem(text: NSLocalizedString("Appella Health", comment: ""))
        setMenuIcon(#selector(didTapMenuIcon))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        kitchen.receive(event: .viewWillAppear)
    }
    
    //MARK: - Helpers
    
    func changeNotificationSwitch(value: Bool) {
        let notificationsCellIndexPath = IndexPath(row: SettingsSection.enableNotifications.rawValue, section: Section.settings.rawValue)
        guard let notificationCell = tableView.cellForRow(at: notificationsCellIndexPath) as? AccountTableViewCell else {
            return
        }
        notificationCell.changeSwitch(value: value)
    }
    
    //MARK: - Navigation
    
    func logout() {
        Logout.perform()
    }
    
    @objc func didTapMenuIcon() {
        showMenu()
    }
}

//MARK: - UITableView Data Source

extension AccountViewController: UITableViewDataSource {
    
    private enum Section: Int {
        case account
        case settings
        case support
        
        var description: String {
            switch self {
            case .account:
                return NSLocalizedString("Account", comment: "")
            case .settings:
                return NSLocalizedString("Settings", comment: "")
            case .support:
                return NSLocalizedString("Support", comment: "")
            }
        }
        
        static var count: Int {
            return (Section.support.rawValue + 1)
        }
    }
    
    private enum AccountSection: Int {
        case logOut
        
        var description: String {
            switch self {
            case .logOut:
                return NSLocalizedString("LogOut", comment: "")
            }
        }
    }
    
    private enum SettingsSection: Int {
        case enableNotifications
        
        var description: String {
            switch self {
            case .enableNotifications:
                return NSLocalizedString("Enable notifications", comment: "")
            }
        }
    }
    
    private enum SupportSection: Int {
        case privacyPolicy
        
        var description: String {
            switch self {
            case .privacyPolicy:
                return NSLocalizedString("Privacy Policy", comment: "")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let title = Section(rawValue: section)?.description else {
            fatalError("Unexpected section index")
        }
        return title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unexpected section index")
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountTableViewCell.identifier, for: indexPath) as? AccountTableViewCell else {
            fatalError("failed to deque AccountTableViewCell")
        }
        switch section {
        case .account:
            guard let accountSection = AccountSection(rawValue: indexPath.row) else {
                fatalError("Unexpected account section index")
            }
            cell.setupCell(title: accountSection.description)
        case .settings:
            guard let settingsSection = SettingsSection(rawValue: indexPath.row) else {
                fatalError("Unexpected settings section index")
            }
            cell.setupCell(title: settingsSection.description) { [weak self] value in
                guard let _self = self else {
                    return
                }
                _self.kitchen.receive(event: .didSwitchReceiveNotificationsStatus(status: value))
            }
        case .support:
            guard let supportSection = SupportSection(rawValue: indexPath.row) else {
                fatalError("Unexpected support section index")
            }
            cell.setupCell(title: supportSection.description)
        }
        return cell
    }
}

//MARK: - UITableView Delegate

extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unexpected section index")
        }
        switch section {
        case .account:
            kitchen.receive(event: .didLogout)
            logout()
        case .settings:
            break
        case .support:
            let storyboard = UIStoryboard.privacyPolicy
            guard let viewController = storyboard.instantiateInitialViewController() else {
                fatalError("failed to instantiateInitialViewController for privacyPolicy storyboard")
            }
            navigationController?.show(viewController, sender: self)
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unexpected section index")
        }
        if section == .settings {
            return false
        }
        return true
    }
}

//MARK: - Kitchen Delegate

extension AccountViewController: KitchenDelegate {
    typealias Command = AccountState
    
    func perform(_ command: Command) {
        switch command {
        case .startLoading:
            SVProgressHUD.show()
        case .finishLoading:
            SVProgressHUD.dismiss()
        case .logout:
            logout()
        case .errorHappend(let error):
            SVProgressHUD.showError(withStatus: error)
        case .setupNotificationStatus(let status):
            changeNotificationSwitch(value: status)
        case .notificationStatusChanged(let message):
            SVProgressHUD.showSuccess(withStatus: message)
        }
    }
}

//MARK: - Remove Back Button Title

extension AccountViewController: RemoveBackButtonTitle {
    
}

//MARK: - Add Label To Right Bar Item

extension AccountViewController: AddLabelToRightBarItem {
    
}

//MARK: - MenuIcon

extension AccountViewController: MenuIcon {
    
}
