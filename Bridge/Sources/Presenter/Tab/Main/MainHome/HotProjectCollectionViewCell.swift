//
//  HotProjectCollectionViewCell.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/31.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class HotProjectCollectionViewCell: BaseCollectionViewCell {
    // MARK: - Properties
    private let projectBackgroundView = UIView()
    
    private let titleLabel = UILabel()
    private let dDayLabel = UILabel()
    
    private let personImageView = UIImageView()
    private let recruitsLabel = UILabel()

    func bind(_ chatRoom: Driver<Project>) {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
        dDayLabel.text = ""
        recruitsLabel.text = ""
        disposeBag = DisposeBag()
    }
    
    // MARK: - Configurations
    override func configureLayouts() {
        addSubview(projectBackgroundView)
        projectBackgroundView.backgroundColor = .black
        projectBackgroundView.layer.cornerRadius = 10
        projectBackgroundView.clipsToBounds = true
        
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 2
        
        dDayLabel.textColor = .darkGray
        dDayLabel.font = .systemFont(ofSize: 13.5)
        dDayLabel.clipsToBounds = true
        dDayLabel.layer.cornerRadius = 13
        dDayLabel.layer.borderColor = UIColor.darkGray.cgColor
        dDayLabel.layer.borderWidth = 1
        
        personImageView.image = UIImage(systemName: "person.fill")
        personImageView.backgroundColor = .clear
        personImageView.tintColor = .darkGray
        
        recruitsLabel.textColor = .darkGray
        recruitsLabel.font = .systemFont(ofSize: 13)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        projectBackgroundView.pin.all()
        projectBackgroundView.flex.layout()
    }
}

// MARK: - Configuration
extension HotProjectCollectionViewCell {
    func configureCell(with project: Project) {
        titleLabel.text = project.title
        dDayLabel.text = "\(project.dDays)"
        recruitsLabel.text = "\(project.numberOfRecruits)"
    }
}
