//
//  ProjectCollectionViewCell.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/02.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class AllProjectCollectionViewCell: BaseCollectionViewCell {
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(
            textColor: .black,
            font: .boldSystemFont(ofSize: 18),
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
    
    private let tagLabel1: UILabel = {
        let label = UILabel()
        label.configureLabel(
            textColor: .darkGray,
            font: .systemFont(ofSize: 13.5),
            textAlignment: .center
        )
        label.layer.cornerRadius = 13
        label.layer.borderColor = UIColor.darkGray.cgColor
        label.layer.borderWidth = 1
        return label
    }()
    
    private let tagLabel2: UILabel = {
        let label = UILabel()
        label.configureLabel(
            textColor: .darkGray,
            font: .systemFont(ofSize: 13.5),
            textAlignment: .center
        )
        label.layer.cornerRadius = 13
        label.layer.borderColor = UIColor.darkGray.cgColor
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
    
    private let rectangleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "rectangle.fill")
        imageView.tintColor = .darkGray
        
        return imageView
    }()
    
    private let periodLabel: UILabel = {
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
        tagLabel1.text = ""
        tagLabel2.text = ""
        recruitsLabel.text = ""
        disposeBag = DisposeBag()
    }
    
    // MARK: - Configurations
    override func configureLayouts() {
        addSubview(projectBackgroundView)
        
        projectBackgroundView.flex.direction(.column).padding(5).define { flex in
            flex.addItem().direction(.row).justifyContent(.spaceBetween).define { flex in
                flex.addItem(titleLabel).height(50).width(150).marginTop(10).marginLeft(15)
                flex.addItem(dDayLabel).width(60).height(25).marginTop(10).marginRight(15)
            }
            
            flex.addItem().direction(.row).alignItems(.center).marginTop(10).define { flex in
                flex.addItem(tagLabel1).width(60).height(25).marginLeft(15)
                flex.addItem(tagLabel2).width(60).height(25).marginLeft(8)
            }
            
            flex.addItem().grow(1)  // 빈 공간을 채우는 아이템 추가
            
            flex.addItem().direction(.row).marginBottom(10).justifyContent(.spaceBetween).define { flex in
                flex.addItem().direction(.row).alignItems(.center).define { flex in
                    flex.addItem(personImageView).size(15).marginLeft(15)
                    flex.addItem(recruitsLabel).marginLeft(5)
                }
                
                flex.addItem().direction(.row).alignItems(.center).define { flex in
                    flex.addItem(rectangleImageView).size(15)
                    flex.addItem(periodLabel).marginLeft(5)
                }
                
                flex.addItem(scrapButton).size(23).marginRight(15)
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
extension AllProjectCollectionViewCell {
    func configureCell(with project: Project) {
        titleLabel.text = project.title
        dDayLabel.text = "D-\(project.dDays)"
        tagLabel1.text = project.recruitmentField[0]
        tagLabel2.text = project.techStackTags[0]
        recruitsLabel.text = "\(project.numberOfRecruits)명 모집"
        periodLabel.text = "\(project.startDate)-\(project.endDate)"
    }
}
