//
//  Model.swift
//  Finding pairs
//
//  Created by Constantin on 02.12.2022.
//

import UIKit

let numberOfPairsOfCards = 8

//MARK: - card structure

struct Card {
    
    var isCardShow = false
    var isMatched = false
    let ID: Int
    var background: UIColor = .black
    
    lazy var imageView: UIImageView = {
        var img = UIImageView()
        img.image = UIImage(named: "\(ID)")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = background
        img.layer.opacity = 0
        img.contentMode = UIImageView.ContentMode.scaleAspectFill
        img.layer.cornerRadius = 12
        return img
    }()
    
    lazy var backSideImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "backside.png")
        $0.layer.opacity = 1
        $0.contentMode = UIImageView.ContentMode.scaleAspectFill
        $0.layer.cornerRadius = 12
        return $0
    }(UIImageView())
    
    static var counterID = 0
    static func generatorID() -> Int {
        counterID += 1
        return counterID
    }
    
    init() {
        self.ID = Card.generatorID()
    }
}

//MARK: - the array of images for the collection

class Game {
    
    var cards = [Card]()
    var uniqueCards = [Int: Card]()
    var oneCardShowIdx: IndexPath?
    var firstCardIdx: IndexPath?
    
    func chooseCard(id: Int, idx: IndexPath) {
        if let oneIdx = firstCardIdx {
            if cards[oneIdx.item].isMatched {
                firstCardIdx = nil
            }
        }
        if !cards[idx.item].isMatched {
            if let oneCardIdx = oneCardShowIdx?.item, cards[idx.item].isCardShow, idx.item != oneCardIdx {
                if cards[idx.item].ID == cards[oneCardIdx].ID {
                    cards[idx.item].isMatched = true
                    cards[oneCardIdx].isMatched = true
                    cards[idx.item].isCardShow = false
                    cards[oneCardIdx].isCardShow = false
//                    print("cards idx: \(idx.item) oneCardIdx: \(oneCardIdx) matched")
                    firstCardIdx = oneCardShowIdx
                    oneCardShowIdx = nil
                } else {
//                  print("hide idx and oneCard")
                    cards[idx.item].isCardShow = false
                    cards[oneCardIdx].isCardShow = false
                    firstCardIdx = oneCardShowIdx
                    oneCardShowIdx = nil
                }
            } else {
//                print("save one card idx")
                cards[idx.item].isCardShow = true
                oneCardShowIdx = idx
            }
        }
    }
    
    init() {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            uniqueCards[card.ID] = card
            cards += [card, card]
            cards.shuffle()
        }
    }
}
