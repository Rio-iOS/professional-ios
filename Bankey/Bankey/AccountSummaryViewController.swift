//
//  AccountSummaryViewController.swift
//  Bankey
//
//  Created by 藤門莉生 on 2024/06/16.
//

import UIKit

class AccountSummaryViewController: UIViewController {
    // Request Models
    var profile: Profile?
    var accounts: [Account] = []
    
    // View Models
    var headerViewModel = AccountSummaryHeaderView.ViewModel(
        welcomeMessage: "Welcome",
        name: "",
        date: Date()
    )
    var accountCellViewModels: [AccountSummaryCell.ViewModel] = []
 
    private lazy var logoutBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        barButtonItem.tintColor = .label
        return barButtonItem
    }()
    
    private var headerView = AccountSummaryHeaderView(frame: .zero)
    private var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension AccountSummaryViewController {
    func setup() {
        setupNavigationBar()
        setupTableView()
        setupTableHeaderView()
        fetchData()
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = logoutBarButtonItem
    }
    
    func setupTableView() {
        tableView.backgroundColor = appColor
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: AccountSummaryCell.reuseID)
        tableView.rowHeight = AccountSummaryCell.rowHeight
        tableView.tableFooterView = UIView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func setupTableHeaderView() {
        // let header = AccountSummaryHeaderView(frame: .zero)
        let header = headerView
        // このタイミングでHeightが決定
        var size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        // このタイミングでWidthが決定
        size.width = UIScreen.main.bounds.width
        header.frame.size = size
        
        tableView.tableHeaderView = header
    }
    
    @objc func logoutTapped(sender: UIButton) {
        NotificationCenter.default.post(name: .logout, object: nil)
    }
    
    func configureTableHeaderView(with profile: Profile) {
        let vm = AccountSummaryHeaderView.ViewModel(
            welcomeMessage: "Good morning",
            name: profile.firstName,
            date: Date()
        )
        
        headerView.configure(viewModel: vm)
    }
    
    func configureTableCells(with accounts: [Account]) {
        accountCellViewModels = accounts.map {
            AccountSummaryCell.ViewModel(
                accountType: $0.type,
                accountName: $0.name,
                balance: $0.amount
            )
        }
    }
    
    func fetchData() {
        let group = DispatchGroup()
       
        group.enter()
        fetchProfile(forUserId: "1") { result in
            switch result {
            case .success(let profile):
                self.profile = profile
                self.configureTableHeaderView(with: profile)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            group.leave()
        }
   
        group.enter()
        fetchAccounts(forUserId: "1") { result in
            switch result {
            case .success(let accounts):
                self.accounts = accounts
                self.configureTableCells(with: accounts)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
    
}

extension AccountSummaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension AccountSummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !accountCellViewModels.isEmpty else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.reuseID, for: indexPath) as! AccountSummaryCell
        let accounts = accountCellViewModels[indexPath.row]
        cell.configure(with: accounts)
        
        return cell
    }
}
