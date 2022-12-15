//
//  ViewController.swift
//  Finding pairs
//
//  Created by Constantin on 02.12.2022.
//

import UIKit

class ViewController: UIViewController {

    deinit {
        clock.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        loadLayout()
        firstLoad()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isPortrait {
            NSLayoutConstraint.deactivate(layoutLandscape)
            NSLayoutConstraint.activate(layoutPortrait)
        } else {
            NSLayoutConstraint.deactivate(layoutPortrait)
            NSLayoutConstraint.activate(layoutLandscape)
        }
        collectionView.layoutIfNeeded()
        view.layoutIfNeeded()
    }
    
//MARK: - variables

    var game = Game()

    var layoutPortrait = [NSLayoutConstraint]()
    var layoutLandscape = [NSLayoutConstraint]()

    private let clickLabelPrefix = "Ходов: "
    private lazy var clock = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
    //lazy var displayLink: Void = CADisplayLink(target: self, selector: #selector(updateClock)).add(to: .current, forMode: .default)
    private var seconds = 0
    private var minutes = 0
    //    let randomIndex = Int(arc4random_uniform(UInt32(idx)))
        
// MARK: - views
    
    private var backgndImView: UIImageView = {
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
        $0.backgroundColor = .white
        $0.setTitle("Новая игра", for: .normal)
        $0.setTitleColor(UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0), for: .normal)
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = CGColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        $0.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private var clickCounterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .lightGray //UIColor(red: 0.73, green: 0.59, blue: 0.33, alpha: 0.8)
        label.textAlignment = .center
        label.text = ""
        return label
    }()
    
    private var clockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .lightGray //UIColor(red: 0.73, green: 0.59, blue: 0.33, alpha: 0.8)
        label.textAlignment = .center
        label.text = "00 : 00"
        return label
    }()

// MARK: - layout
    
    private func loadLayout() {
        
        [backgndImView,
         collectionView,
         restartButton,
         clickCounterLabel,
         clockLabel
        ].forEach({ view.addSubview($0) })
        
        layoutPortrait = [
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
            restartButton.heightAnchor.constraint(equalToConstant: 60),
            restartButton.widthAnchor.constraint(equalToConstant: 200),
            
            clickCounterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clickCounterLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            clickCounterLabel.heightAnchor.constraint(equalToConstant: 30),
            clickCounterLabel.widthAnchor.constraint(equalTo: view.widthAnchor),

            clockLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clockLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            clockLabel.heightAnchor.constraint(equalToConstant: 30),
            clockLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
        ]
        
        layoutLandscape = [
            backgndImView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgndImView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgndImView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgndImView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 190),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            
            restartButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            restartButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            restartButton.heightAnchor.constraint(equalToConstant: 50),
            restartButton.widthAnchor.constraint(equalToConstant: 150),
            
            clickCounterLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            clickCounterLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            clickCounterLabel.heightAnchor.constraint(equalToConstant: 30),
            clickCounterLabel.widthAnchor.constraint(equalToConstant: 150),

            clockLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            clockLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            clockLabel.heightAnchor.constraint(equalToConstant: 30),
            clockLabel.widthAnchor.constraint(equalToConstant: 150)
            
//            equalToConstant: UIScreen.main.bounds.height
        ]
        
        UIDevice.current.orientation.isPortrait ?
        NSLayoutConstraint.activate(layoutPortrait) : NSLayoutConstraint.activate(layoutLandscape)
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
        
        let size: CGFloat
        
        if UIDevice.current.orientation.isPortrait {
            size = (collectionView.bounds.width - inset * 5) / 4
        } else {
            size = (collectionView.bounds.height - inset * 5) / 4
        }
        
        return CGSize(width: size, height: size)
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
            self.clock = self.clock
            RunLoop.main.add(self.clock, forMode: RunLoop.Mode.common)
        }
        clickCounterLabel.text = clickLabelPrefix + String(game.clickCounter)


    }
    
    func flip(cellID: IndexPath) {
    
        if !game.cards[cellID.item].isMatched {
            
            game.clickCounter += 1
            clickCounterLabel.text = clickLabelPrefix + String(game.clickCounter)

            game.cards[cellID.item].isCardShow = !game.cards[cellID.item].isCardShow
            animatedSelection(cell: cellID)
            
            game.chooseCard(id: game.cards[cellID.item].ID, idx: cellID)
            
            if game.cards[cellID.item].isMatched {
                animatedSelection(cell: cellID)
                animatedSelection(cell: game.firstCardIdx!)
                game.cards[cellID.item].background = .clear
                game.cards[game.firstCardIdx!.item].background = .clear
                collectionView.reloadItems(at: [cellID, game.firstCardIdx!])
                if game.cards.filter({ $0.isMatched == true }).count == game.cards.count {
                    clock.invalidate()
                }
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
        
        clock.invalidate()
        clockLabel.text = "00 : 00"
        seconds = 0
        minutes = 0
        game.cards.shuffle()
        game.clickCounter = 0
        game.firstCardIdx = nil
        game.oneCardShowIdx = nil
        clickCounterLabel.text = clickLabelPrefix + String(game.clickCounter)
        
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
                game.cards[i].background = .white
            }
        } completion: { [self] _ in
            UIView.animate(withDuration: 0.8, delay: 3.0,
                           animations: { [self] in
                for i in game.cards.indices {
                    game.cards[i].imageView.layer.opacity = 0
                    game.cards[i].backSideImageView.layer.opacity = 1
                    game.cards[i].isCardShow = false
                    game.cards[i].background = .white
                }
            })
            clock = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
            RunLoop.main.add(clock, forMode: RunLoop.Mode.common)
        }
        collectionView.reloadData()
        view.layoutIfNeeded()
    }
    
//MARK: - clock

    @objc private func updateClock() {
        
        seconds += 1
        if  seconds == 60 {
            minutes += 1
            seconds = 0
        }
        let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        self.clockLabel.text = minutesString + " : " + secondsString
    }
}
