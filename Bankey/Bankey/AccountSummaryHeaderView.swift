//
//  AccountSummaryHeaderView.swift
//  Bankey
//
//  Created by 藤門莉生 on 2024/06/16.
//

import UIKit

class AccountSummaryHeaderView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var welcomeLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    private let shakeyBellView = ShakeyBellView()
    
    struct ViewModel {
        let welcomeMessage: String
        let name: String
        let date: Date
        
        var dateFormated: String {
            date.monthDayYearString
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 144)
    }
}

extension AccountSummaryHeaderView {
    func configure(viewModel: ViewModel) {
        DispatchQueue.main.async {
            self.welcomeLabel.text = viewModel.welcomeMessage
            self.nameLabel.text = viewModel.name
            self.dateLabel.text = viewModel.dateFormated
        }
    }
}

private extension AccountSummaryHeaderView {
    func commonInit() {
        let bundle = Bundle(for: AccountSummaryHeaderView.self)
        bundle.loadNibNamed("AccountSummaryHeaderView", owner: self)
        addSubview(contentView)
        contentView.backgroundColor = appColor
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        setupShakeyBell()
    }
    
    func setupShakeyBell() {
        addSubview(shakeyBellView)
        
        shakeyBellView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            shakeyBellView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shakeyBellView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
