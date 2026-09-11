import UIKit

final class AccountSummaryViewController: UIViewController {
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

private let viewModel: AccountSummaryViewModel

init(viewModel: AccountSummaryViewModel = AccountSummaryViewModel(fetchSummary: FetchAccountSummaryUseCase(profiles: ProfileManager(), accounts: AccountsManager()))) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
}

@available(*, unavailable)
required init?(coder: NSCoder) { fatalError("Use init(viewModel:)") }

private lazy var errorAlert: UIAlertController = {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onStateChange = { [weak self] state in self?.render(state) }
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
        let accounts = Array(repeating: row, count: 10)

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

func render(_ state: AccountSummaryViewModel.State) {
    switch state {
    case .loading:
        isLoaded = false
        setupSkeletons()
        tableView.reloadData()
    case .loaded(let summary):
        refreshControl.endRefreshing()
        isLoaded = true
        configureTableHeaderView(with: summary.profile)
        configureTableCells(with: summary.accounts)
        tableView.reloadData()
    case .failed(let error):
        refreshControl.endRefreshing()
        accountCellViewModels = []
        tableView.reloadData()
        let message = AccountSummaryViewModel.errorMessage(for: error)
        showErrorAlert(title: message.title, message: message.message)
    }
}

func fetchData() {
    viewModel.load(userID: String(Int.random(in: 1..<4)))
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
