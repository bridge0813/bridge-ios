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
    
    private let rankingImageView = UIImageView()
    
    private let titleLabel = UILabel()
    private let dDayLabel = UILabel()
    
    private let personImageView = UIImageView()
    private let recruitsLabel = UILabel()
    private let scrapButton = UIButton()

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
        rankingImageView.image = UIImage(systemName: "bookmark.fill")
        rankingImageView.backgroundColor = .clear
        rankingImageView.tintColor = .blue
        
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 2
        
        dDayLabel.textColor = .darkGray
        dDayLabel.font = .systemFont(ofSize: 13.5)
        dDayLabel.clipsToBounds = true
        dDayLabel.layer.cornerRadius = 13
        dDayLabel.layer.borderColor = UIColor.darkGray.cgColor
        dDayLabel.layer.borderWidth = 1
        dDayLabel.textAlignment = .center
        
        personImageView.image = UIImage(systemName: "person.fill")
        personImageView.backgroundColor = .clear
        personImageView.tintColor = .darkGray
        
        recruitsLabel.textColor = .darkGray
        recruitsLabel.font = .boldSystemFont(ofSize: 15)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let buttonImage = UIImage(systemName: "star", withConfiguration: imageConfig)
        scrapButton.setImage(buttonImage, for: .normal)
        scrapButton.tintColor = .gray
        
        addSubview(projectBackgroundView)
        projectBackgroundView.backgroundColor = .white
        projectBackgroundView.layer.cornerRadius = 10
        projectBackgroundView.layer.shadowColor = UIColor.black.cgColor
        projectBackgroundView.layer.shadowOpacity = 0.5
        projectBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        projectBackgroundView.layer.shadowRadius = 1.0
        projectBackgroundView.clipsToBounds = true
        projectBackgroundView.layer.masksToBounds = false
        
        projectBackgroundView.flex.direction(.column).padding(5).define { flex in
            flex.addItem(rankingImageView).position(.absolute).top(-1).right(7).size(23)
            
            flex.addItem(titleLabel).height(50).marginTop(10).marginLeft(8).marginRight(30)
            
            flex.addItem(dDayLabel).height(25).width(60).marginLeft(8).marginTop(10)
            
            flex.addItem().direction(.column).grow(1).marginLeft(8).justifyContent(.end).define { flex in
                flex.addItem().direction(.row).marginBottom(10).justifyContent(.spaceBetween).define { flex in
                    flex.addItem().direction(.row).alignItems(.center).define { flex in
                        flex.addItem(personImageView).size(15)
                        flex.addItem(recruitsLabel).marginLeft(5)
                    }
                    
                    flex.addItem(scrapButton).size(23).marginRight(5)
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        projectBackgroundView.pin.all().margin(10)
        projectBackgroundView.flex.layout()
    }
}

// MARK: - Configuration
extension HotProjectCollectionViewCell {
    func configureCell(with project: Project) {
        titleLabel.text = project.title
        dDayLabel.text = "D-\(project.dDays)"
        recruitsLabel.text = "\(project.numberOfRecruits)명 모집"
    }
}
