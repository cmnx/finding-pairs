//
//  ViewController.swift
//  Finding pairs
//
//  Created by Constantin on 02.12.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        loadLayout()
        firstLoad()
    }
    
//MARK: - variables
//    let randomIndex = Int(arc4random_uniform(UInt32(idx)))
    var game = Game()
// MARK: - views
    
    private lazy var backgndImView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.image = UIImage(named: "background.png")
        return $0
    }(UIImageView())
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.dataSource = self
        collection.delegate = self
        collection.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        return collection
    }()
    
    private lazy var restartButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .black
        $0.setTitle("Сброс", for: .normal)
        $0.setTitleColor(UIColor(red: 0.73, green: 0.59, blue: 0.33, alpha: 1.0), for: .normal)
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = CGColor(red: 0.73, green: 0.59, blue: 0.33, alpha: 1.0)
        $0.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var clickCounterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = UIColor(red: 0.73, green: 0.59, blue: 0.33, alpha: 0.8)
        label.textAlignment = .center
        label.text = ""
        return label
    }()
    

// MARK: - layout
    
    private func loadLayout() {
        
        [backgndImView,
         collectionView,
         restartButton,
         clickCounterLabel
        ].forEach({ view.addSubview($0) })

        NSLayoutConstraint.activate([
            backgndImView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgndImView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgndImView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgndImView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restartButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            restartButton.heightAnchor.constraint(equalToConstant: 50),
            restartButton.widthAnchor.constraint(equalToConstant: 200),
            clickCounterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clickCounterLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            clickCounterLabel.heightAnchor.constraint(equalToConstant: 50),
            clickCounterLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}

//MARK: - collection data source

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        game.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        
        cell.layer.cornerRadius = 12
        cell.config(img: game.cards[indexPath.item].imageView, backImg: game.cards[indexPath.item].backSideImageView)
        
//        cell.config(img: UIImageView(image: UIImage(systemName: "xmark")))
        cell.backgroundColor = game.cards[indexPath.item].background
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
}

//MARK: - collection delegate

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    private var inset: CGFloat { return 8 }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.bounds.width - inset * 5) / 4
        return CGSize(width: width, height: width)
    }

// MARK: - insets for collection
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        inset
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        inset
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("- tap cell \(indexPath.item), card id \(game.cards[indexPath.item].ID)")
        flip(cellID: indexPath)
    }
}

// MARK: - functions - gestures

extension ViewController {
   
    func firstLoad() {
        UIView.animate(withDuration: 1.0,
                       delay: 0.5,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.2,
                       options: .transitionFlipFromTop) { [self] in
            for i in game.cards.indices {
                game.cards[i].imageView.layer.cornerRadius = 12
                game.cards[i].backSideImageView.layer.opacity = 0
                game.cards[i].imageView.layer.opacity = 1
                game.cards[i].isCardShow = true
            }
        } completion: { _ in
            UIView.animate(withDuration: 0.8, delay: 3.0,
                           animations: { [self] in
                for i in game.cards.indices {
                    game.cards[i].imageView.layer.opacity = 0
                    game.cards[i].backSideImageView.layer.opacity = 1
                    game.cards[i].isCardShow = false
                }
            })
        }
        clickCounterLabel.text = "Кликов минимум 16. Всего: \(game.clickCounter)"
    }
    
    func flip(cellID: IndexPath) {
    
        if !game.cards[cellID.item].isMatched {
            
            game.clickCounter += 1
            clickCounterLabel.text = "Кликов минимум 16. Всего: \(game.clickCounter)"
            
            game.cards[cellID.item].isCardShow = !game.cards[cellID.item].isCardShow
            animatedSelection(cell: cellID)
            
            game.chooseCard(id: game.cards[cellID.item].ID, idx: cellID)
            
            if game.cards[cellID.item].isMatched {
                animatedSelection(cell: cellID)
                animatedSelection(cell: game.firstCardIdx!)
                game.cards[cellID.item].background = .clear
                game.cards[game.firstCardIdx!.item].background = .clear
                collectionView.reloadItems(at: [cellID, game.firstCardIdx!])
            } else {
                if let firstIdx = game.firstCardIdx {
                    game.cards[firstIdx.item].isCardShow = false
                    animatedSelection(cell: firstIdx)
                    game.firstCardIdx = nil
                }
                animatedSelection(cell: cellID)
            }

        }
    }
    
    private func animatedSelection(cell: IndexPath) {
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.3,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.2,
                       options: .transitionFlipFromTop) { [self] in
            if game.cards[cell.item].isCardShow {
                game.cards[cell.item].imageView.layer.opacity = 0
                game.cards[cell.item].backSideImageView.layer.opacity = 1
            } else {
                game.cards[cell.item].backSideImageView.layer.opacity = 0
                game.cards[cell.item].imageView.layer.opacity = 1
            }
        } completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0.3,
                           animations: { [self] in
                if game.cards[cell.item].isCardShow {
                    game.cards[cell.item].backSideImageView.layer.opacity = 0
                    game.cards[cell.item].imageView.layer.opacity = 1
                } else {
                    game.cards[cell.item].imageView.layer.opacity = 0
                    if !game.cards[cell.item].isMatched {
                        game.cards[cell.item].backSideImageView.layer.opacity = 1
                    }
                }
            })
        }
        
        view.layoutIfNeeded()
    }
    
    @objc private func restartGame() {
        
        game.cards.shuffle()
        game.clickCounter = 0
        clickCounterLabel.text = "Кликов минимум 16. Всего: \(game.clickCounter)"
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.5,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.2,
                       options: .transitionFlipFromTop) { [self] in
            for i in game.cards.indices {
                game.cards[i].imageView.layer.cornerRadius = 12
                game.cards[i].backSideImageView.layer.opacity = 0
                game.cards[i].imageView.layer.opacity = 1
                game.cards[i].isMatched = false
                game.cards[i].isCardShow = true
                game.cards[i].background = .black
            }
        } completion: { _ in
            UIView.animate(withDuration: 0.8, delay: 3.0,
                           animations: { [self] in
                for i in game.cards.indices {
                    game.cards[i].imageView.layer.opacity = 0
                    game.cards[i].backSideImageView.layer.opacity = 1
                    game.cards[i].isCardShow = false
                    game.cards[i].background = .black
                }
            })
        }
        
        collectionView.reloadData()
        view.layoutIfNeeded()
    }
}
