//
//  AccountSummaryViewController.swift
//  Bankey
//
//  Created by 藤門莉生 on 2024/06/16.
//

import UIKit

class AccountSummaryViewController: UIViewController {
    // Request Models
    private var profile: Profile?
    private var accounts: [Account] = []
    
    // View Models
    private var accountCellViewModels: [AccountSummaryCell.ViewModel] = []
 
    private lazy var logoutBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        barButtonItem.tintColor = .label
        return barButtonItem
    }()
    
    private var headerView = AccountSummaryHeaderView(frame: .zero)
    private var tableView = UITableView()
    private let refreshControl = UIRefreshControl()
   
    private var isLoaded = false
    
    var profileManager: ProfileManagable = ProfileManager()
    var accountsManager: AccountsManagable = AccountsManager()
    
    lazy var errorAlert: UIAlertController = {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }()
    
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
        setupRefreshControl()
        setupSkeletons()
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
        tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.reuseID)
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
    
    func setupRefreshControl() {
        refreshControl.tintColor = appColor
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func setupSkeletons() {
        let row = Account.makeSkeleton()
        accounts = Array(repeating: row, count: 10)
        
        configureTableCells(with: accounts)
    }
    
    @objc func logoutTapped(sender: UIButton) {
        NotificationCenter.default.post(name: .logout, object: nil)
    }
    
    @objc func refreshContent() {
        reset()
        setupSkeletons()
        tableView.reloadData()
        fetchData()
    }
    
    func reset() {
        profile = nil
        accounts = []
        isLoaded = false
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
    
    func showErrorAlert(title: String, message: String) {
        guard !(self.presentedViewController is UIAlertController) else { return }
        
        errorAlert.title = title
        errorAlert.message = message
        
        self.present(self.errorAlert, animated: true)
    }
    
    func titleAndMessage(error: NetworkError) -> (String, String) {
        let title: String
        let message: String
        switch error {
        case .serverError:
            title = "Server Error"
            message = "Ensure you are connected to the internet. Please try again."
        case .decodingError:
            title = "Decoding Error"
            message = "We could not process your request, Please try again."
        }
        return (title, message)
    }
    
    func displayError(error: NetworkError) {
        let (title, message) = titleAndMessage(error: error)
        DispatchQueue.main.async {
            self.showErrorAlert(title: title, message: message)
        }
    }
   
    func fetchProfile(group: DispatchGroup, userId: String) {
        group.enter()
        profileManager.fetchProfile(forUserId: userId) { result in
            switch result {
            case .success(let profile):
                self.profile = profile
                
            case .failure(let error):
                self.displayError(error: error)
            }
            group.leave()
        }
    }
    
    func reloadView() {
        self.refreshControl.endRefreshing()
        
        guard let profile = self.profile else { return }
        
        self.isLoaded = true
        self.configureTableHeaderView(with: profile)
        self.configureTableCells(with: self.accounts)
        self.tableView.reloadData()
    }
    
    func fetchAccounts(group: DispatchGroup, userId: String) {
        group.enter()
        accountsManager.fetchAccounts(forUserId: userId) { result in
            switch result {
            case .success(let accounts):
                self.accounts = accounts
                
            case .failure(let error):
                self.displayError(error: error)
            }
            group.leave()
        }
    }
    
    func fetchData() {
        let group = DispatchGroup()
      
        let userId = String(Int.random(in: 1..<4))
        
        self.fetchProfile(group: group, userId: userId)
        self.fetchAccounts(group: group, userId: userId)
        
        group.notify(queue: .main) {
            self.reloadView()
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
        
        let accounts = accountCellViewModels[indexPath.row]
        
        if isLoaded {
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.reuseID, for: indexPath) as! AccountSummaryCell
            cell.configure(with: accounts)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonCell.reuseID, for: indexPath) as! SkeletonCell
        return cell
    }
}

// MARK: For Unit Tests
extension AccountSummaryViewController {
    func titleAndMessageForTesting(for error: NetworkError) -> (String, String) {
        titleAndMessage(error: error)
    }
    
    func forceFetchProfile() {
        fetchProfile(group: DispatchGroup(), userId: "1")
    }
    
    func forceFetchAccounts() {
        fetchAccounts(group: DispatchGroup(), userId: "1")
    }
}
