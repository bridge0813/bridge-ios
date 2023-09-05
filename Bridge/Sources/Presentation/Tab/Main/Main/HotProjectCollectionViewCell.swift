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
    private let projectBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 1.0
        return view
    }()
    
    private let rankingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bookmark.fill")
        imageView.tintColor = .blue
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(
            textColor: .black,
            font: .boldSystemFont(ofSize: 16),
            numberOfLines: 2
        )
        return label
    }()
    
    private let dDayLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(
            textColor: .blue,
            font: .systemFont(ofSize: 13.5),
            textAlignment: .center
        )
        label.layer.cornerRadius = 13
        label.layer.borderColor = UIColor.blue.cgColor
        label.layer.borderWidth = 1
        return label
    }()
    
    private let personImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .darkGray
        
        return imageView
    }()
    
    private let recruitsLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(
            textColor: .darkGray,
            font: .boldSystemFont(ofSize: 15)
        )
        return label
    }()
    
    private let scrapButton: UIButton = {
        let button = UIButton()
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let buttonImage = UIImage(systemName: "star", withConfiguration: imageConfig)
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .gray
        
        return button
    }()

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
        projectBackgroundView.flex.direction(.column).padding(5).define { flex in
            flex.addItem(rankingImageView).position(.absolute).top(-1).right(7).size(23)
            
            flex.addItem(titleLabel).height(50).marginTop(7).marginLeft(8).marginRight(20)
            
            flex.addItem(dDayLabel).height(25).width(60).marginLeft(8).marginTop(10)
            
            flex.addItem().grow(1)  // 빈 공간을 채우는 아이템 추가
            
            flex.addItem().direction(.row).justifyContent(.spaceBetween).alignItems(.center).define { flex in
                flex.addItem().direction(.row).alignItems(.center).marginBottom(10).define { flex in
                    flex.addItem(personImageView).size(15).marginLeft(10)
                    flex.addItem(recruitsLabel).marginLeft(5)
                }
                
                flex.addItem(scrapButton).size(23).marginRight(5).marginBottom(10)
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
    func configureCell(with project: HotProject) {
        titleLabel.text = project.title
        dDayLabel.text = "D-\(project.dDays)"
        recruitsLabel.text = "\(project.numberOfRecruits)명 모집"
    }
}
