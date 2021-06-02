//
//  ViewController.swift
//  blackJack
//
//  Created by 羅承志 on 2021/5/27.
//

import UIKit

class ViewController: UIViewController {
    //Ａ、Ｂ cards
    @IBOutlet var cardsAViews: [UIView]!
    @IBOutlet var cardsBViews: [UIView]!
    //cardA Suit、Rank
    @IBOutlet var cardsARankLabels: [UILabel]!
    @IBOutlet var cardsA1SuitLabels: [UILabel]!
    @IBOutlet var cardsA2SuitLabels: [UILabel]!
    //cardB Suit、Rank
    @IBOutlet var cardsBRankLabels: [UILabel]!
    @IBOutlet var cardsB1SuitLabels: [UILabel]!
    @IBOutlet var cardsB2SuitLabels: [UILabel]!
    //卡片點數
    @IBOutlet var cardsPointsLabels: [UILabel]!
    //總共賭金
    @IBOutlet weak var totalCounterLabel: UILabel!
    //下注的金額
    @IBOutlet weak var betAmountLabel: UILabel!
    //+ - 下注金額
    @IBOutlet weak var betAmountSegmented: UISegmentedControl!
    @IBOutlet weak var betAddButton: UIButton!
    @IBOutlet weak var betMinusButton: UIButton!
    
    var cards = [Card]()
    var playerACards = [Card]()
    var playerBCards = [Card]()
    
    var index = 1
    var cardAPoint = 0
    var cardBPoint = 0
    var sumA = 0
    var sumB = 0
    var takeCard = Int.random(in: 0...51)
    var betAmount = 0
    var totalCounter = 100
    
    var controller = UIAlertController()
    var action = UIAlertAction()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //生成52卡牌
        for rank in ranks {
            for suit in suits {
                let card = Card()
                card.rank = rank
                card.suit = suit
                cards.append(card)
            }
        }
        gameInit()
        //卡牌UIView加入邊框＆邊框色＆底色
        for i in 0...4 {
            cardsAViews[i].layer.borderWidth = 0.5
            cardsAViews[i].layer.borderColor = UIColor.black.cgColor
            cardsAViews[i].backgroundColor = UIColor.white
            cardsBViews[i].layer.borderWidth = 0.5
            cardsBViews[i].layer.borderColor = UIColor.black.cgColor
            cardsBViews[i].backgroundColor = UIColor.white
        }
    }
    //遊戲初始
    func gameInit() {
        playerACards = [Card]()
        playerBCards = [Card]()
        
        index = 1
        cardAPoint = 0
        cardBPoint = 0
        sumA = 0
        sumB = 0
        
        betAmount = 0
        cardsPointsLabels[0].textColor = UIColor.black
        cardsPointsLabels[1].textColor = UIColor.black
        
        betAmountSegmented.selectedSegmentIndex = 0
        totalCounterLabel.text = "$\(totalCounter)"
        betAmountLabel.text = "$\(betAmount)"
        //使卡牌imageView顯示兩張，並抽兩張牌
        for i in 0...4 {
            if i < 2 {
                cardsAViews[i].isHidden = false
                cardsBViews[i].isHidden = false
                cards.shuffle()
                playerACards.append(cards[i])
                cards.shuffle()
                playerBCards.append(cards[i])
                cardsARankLabels[i].text = playerACards[i].rank
                cardsA1SuitLabels[i].text = playerACards[i].suit
                cardsA2SuitLabels[i].text = playerACards[i].suit
                cardsBRankLabels[i].text = playerBCards[i].rank
                cardsB1SuitLabels[i].text = playerBCards[i].suit
                cardsB2SuitLabels[i].text = playerBCards[i].suit
            } else {
                cardsAViews[i].isHidden = true
                cardsBViews[i].isHidden = true
            }
        }
        //計算兩張卡牌點數總和
        for i in 0...1 {
            cardAPoint = calculateRankNumber(card: playerACards[i])
            cardBPoint = calculateRankNumber(card: playerBCards[i])
            sumA = sumA + cardAPoint
            sumB = sumB + cardBPoint
        }
        cardsPointsLabels[0].text = "\(sumA)"
        cardsPointsLabels[1].text = "\(sumB)"
    }
    //定義rank相對應之Int
    func calculateRankNumber(card: Card) -> Int {
        var cardRankNumber = 0
        switch card.rank {
        case "A":
            cardRankNumber = 1
        case "J","Q","K":
            cardRankNumber = 10
        default:
            cardRankNumber = Int(card.rank)!
        }
        return cardRankNumber
    }
    
    @IBAction func betAmountCount(_ sender: UIButton) {
        if betAmountSegmented.selectedSegmentIndex == 0 {
            if sender == betMinusButton {
                betAmount -= 1
            } else {
                betAmount += 1
            }
        } else if betAmountSegmented.selectedSegmentIndex == 1 {
            if sender == betMinusButton {
                betAmount -= 5
            } else {
                betAmount += 5
            }
        } else {
            if sender == betMinusButton {
                betAmount -= 10
            } else {
                betAmount += 10
            }
        }
        
        //當欲出籌碼金額小於零，皆為零（欲出籌碼不為負數），單場欲出籌碼不得超出持有的籌碼
        if betAmount < 0 {
            betAmount = 0
        } else if betAmount > totalCounter {
            betAmount = totalCounter
        }
        betAmountLabel.text = "$\(betAmount)"
    }
    
    @IBAction func getCard(_ sender: UIButton) {
        //亂數（隨機抽一張牌),index控制牌的張數
        takeCard = Int.random(in: 0...51)
        index += 1
        //每點選一次，抽一張牌
        cardsBViews[index].isHidden = false
        playerBCards.append(cards[takeCard])
        cardsBRankLabels[index].text = playerBCards[index].rank
        cardsB1SuitLabels[index].text = playerBCards[index].suit
        cardsB2SuitLabels[index].text = playerBCards[index].suit
        //playerB: 我方卡牌點數總數
        cardBPoint = calculateRankNumber(card: playerBCards[index])
        sumB = sumB + cardBPoint
        cardsPointsLabels[1].text = "\(sumB)"
        //當我方卡牌超過21點
        if sumB > 21 {
            //totalBetAmountLabel.text = "$\(totalBetAmount)"
            totalCounter -= betAmount
            totalCounterLabel.text = "$\(totalCounter)"
            cardsPointsLabels[1].textColor = UIColor.red
            //當我方卡牌超過21點：持有賭金為零時，遊戲重新開始
            if totalCounter <= 0 {
                betAmount = 0
                betAmountLabel.text = "$\(betAmount)"
                totalCounterLabel.text = "$\(totalCounter)"
                controller = UIAlertController(title: "Game Over!", message: "您的點數 \(sumB)\n⚠️⚠️⚠️\nOpps!\n您的下注金額 \(betAmount)!", preferredStyle: .alert)
                action = UIAlertAction(title: "Play Again!", style: .default) { (_) in
                    self.gameInit()
                }
                totalCounter = 100
                controller.addAction(action)
                present(controller, animated: true, completion: nil)
            //當我方卡牌超過21點：持有賭金不是零時，扣掉欲出賭金，繼續下一局
            } else {
                controller = UIAlertController(title: "⚠️⚠️⚠️", message: "下注金額 - \(betAmount)", preferredStyle: .alert)
                action = UIAlertAction(title: "OK", style: .default) { (_) in
                    self.gameInit()
                }
                controller.addAction(action)
                present(controller, animated: true, completion: nil)
            }
        //我方卡牌BlackJack!! 我方獲勝，持有賭金加上欲出賭金
        } else if sumB == 21 {
            totalCounterLabel.text = "$\(totalCounter)"
            totalCounter = totalCounter + betAmount
            cardsPointsLabels[1].textColor = UIColor.red
            controller = UIAlertController(title: "BLACKJACK!", message: "🥳🥳🥳\n下注金額 + \(betAmount)", preferredStyle: .alert)
            action = UIAlertAction(title: "OK", style: .default) { (_) in
                self.gameInit()
            }
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
            
        //我方卡牌過五關 我方獲勝，持有賭金加上欲出賭金
        } else if sumB <= 21, index == 4 {
            cardsPointsLabels[1].textColor = UIColor.red
            totalCounterLabel.text = "$\(totalCounter)"
            totalCounter = totalCounter + betAmount
            controller = UIAlertController(title: "五牌自動勝!", message: "下注金額 + \(betAmount)", preferredStyle: .alert)
            action = UIAlertAction(title: "OK", style: .default) { (_) in
                self.gameInit()
            }
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
        }
    }
    //判斷敵方抽牌與否，及判斷輸贏
    @IBAction func showCard(_ sender: UIButton) {
        //當敵方卡牌點數小於等於16時抽牌
        if sumA <= 16 {
            //抽牌迴圈，如敵方卡點數小於17時繼續抽牌，算出卡牌總點數
            for i in 2...4 {
                if sumA <= 17 {
                    takeCard = Int.random(in: 0...51)
                    cardsAViews[i].isHidden = false
                    playerACards.append(cards[takeCard])
                    cardsARankLabels[i].text = playerACards[i].rank
                    cardsA1SuitLabels[i].text = playerACards[i].suit
                    cardsA2SuitLabels[i].text = playerACards[i].suit
                    cardAPoint = calculateRankNumber(card: playerACards[i])
                    sumA = sumA + cardAPoint
                }
            }
        }
        cardsPointsLabels[0].text = "\(sumA)"
        
        //判斷輸贏 Ａ敵方 Ｂ我方
        // 當A > B時，有可能會遇到 a>21, a=21, a過五關, a = b, a < b, a > b
        if sumA > sumB {
            cardsPointsLabels[0].textColor = UIColor.red
            
        //a方點數超過21，a方輸 b方持有賭金加上欲出賭金
        if sumA > 21 {
            totalCounter = totalCounter + betAmount
            //print("\(sumA) > 21, total:\(totalCounter)")
            controller = UIAlertController(title: "YOU WIN!", message: "🥳🥳🥳\nComputer: \(sumA) 點數爆炸!\n下注金額 + \(betAmount)", preferredStyle: .alert)
            action = UIAlertAction(title: "OK", style: .default) { (_) in
                self.gameInit()
            }
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
        //a方BlackJack，a方贏
        } else if sumA == 21 {
            totalCounterLabel.text = "$\(totalCounter)"
            totalCounter = totalCounter - betAmount
            cardsPointsLabels[0].textColor = UIColor.red
            //當a方卡牌超過21點：b方持有賭金為零時，遊戲重新開始
            if totalCounter <= 0 {
                //print("a方blackJack，餘額0")
                totalCounterLabel.text = "$\(totalCounter)"
                betAmount = 0
                betAmountLabel.text = "$\(betAmount)"
                controller = UIAlertController(title: "Game Over!", message: "Computer: BlackJack!\nOpps!\n您的下注金額 \(betAmount)!", preferredStyle: .alert)
                action = UIAlertAction(title: "Play Again!", style: .default) { (_) in
                    self.gameInit()
                }
                controller.addAction(action)
                present(controller, animated: true, completion: nil)
                totalCounter = 100
            //當a方卡牌超過21點：b方持有賭金不是零時，扣掉欲出賭金，繼續下一局
            } else {
                //print("a方blackJack")
                controller = UIAlertController(title: "YOU LOSE!", message: "Computer: BlackJack!\n下注金額 - \(betAmount)", preferredStyle: .alert)
                action = UIAlertAction(title: "OK", style: .default) { (_) in
                    self.gameInit()
                }
                controller.addAction(action)
                present(controller, animated: true, completion: nil)
            }
        //a方過五關，a贏
        } else if sumA <= 21, playerACards.count == 5 {
            totalCounterLabel.text = "$\(totalCounter)"
            totalCounter = totalCounter - betAmount
            cardsPointsLabels[0].textColor = UIColor.red
            //當a方卡牌過五關：b方持有賭金為零時，遊戲重新開始
            if totalCounter <= 0 {
                //print("a方過五關，餘額0")
                totalCounterLabel.text = "$\(totalCounter)"
                betAmount = 0
                betAmountLabel.text = "$\(betAmount)"
                controller = UIAlertController(title: "Game Over!", message: "Computer: 五牌自動勝!\nOpps!\n您的下注金額 \(betAmount)!", preferredStyle: .alert)
                action = UIAlertAction(title: "Play Again!", style: .default) { (_) in
                    self.gameInit()
                }
                controller.addAction(action)
                present(controller, animated: true, completion: nil)
                totalCounter = 100
                //當a方卡牌過五關：b方持有賭金不是零時，扣掉欲出賭金，繼續下一局
                } else {
                    //print("a方過五關")
                    controller = UIAlertController(title: "YOU LOSE!", message: "Computer: 五牌自動勝!\n下注金額 - \(betAmount)", preferredStyle: .alert)
                    action = UIAlertAction(title: "OK", style: .default) { (_) in
                        self.gameInit()
                    }
                    controller.addAction(action)
                    present(controller, animated: true, completion: nil)
                }
            
        //a > b，a贏
        } else if sumA > sumB {
            totalCounterLabel.text = "$\(totalCounter)"
            totalCounter = totalCounter - betAmount
            cardsPointsLabels[0].textColor = UIColor.red
            
            //當a>b：b方持有賭金為零時，遊戲重新開始
            if totalCounter <= 0 {
                //print("sumA > sumB，餘額0")
                totalCounterLabel.text = "$\(totalCounter)"
                betAmount = 0
                betAmountLabel.text = "$\(betAmount)"
                controller = UIAlertController(title: "Game Over!", message: "Computer: \(sumA)>\(sumB)\nOpps!\n您的下注金額 \(betAmount)!", preferredStyle: .alert)
                action = UIAlertAction(title: "Play Again!", style: .default) { (_) in
                    self.gameInit()
                }
                totalCounter = 100
                controller.addAction(action)
                present(controller, animated: true, completion: nil)
            } else {
                //print("sumA > sumB")
                controller = UIAlertController(title: "YOU LOSE!", message: "下注金額 - \(betAmount)", preferredStyle: .alert)
                action = UIAlertAction(title: "OK", style: .default) { (_) in
                    self.gameInit()
                }
                controller.addAction(action)
                present(controller, animated: true, completion: nil)
            }
        }
        
        //a=b，平手
        } else if sumA == sumB {
            //print("aSum == bSum")
            cardsPointsLabels[0].textColor = UIColor.red
            cardsPointsLabels[1].textColor = UIColor.red
            controller = UIAlertController(title: "TIE GAME!", message: "", preferredStyle: .alert)
            action = UIAlertAction(title: "OK", style: .default) { (_) in
                self.gameInit()
            }
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
            totalCounterLabel.text = "$\(totalCounter)"
            
        //a<b，a方輸 b方持有賭金加上欲出賭金
        } else if sumA < sumB {
            //print("sumA < sumB")
            totalCounter = totalCounter + betAmount
            cardsPointsLabels[1].textColor = UIColor.red
            
            controller = UIAlertController(title: "YOU WIN!", message: "🥳🥳🥳\nComputer: \(sumA) < \(sumB)\n下注金額 + \(betAmount)", preferredStyle: .alert)
            action = UIAlertAction(title: "OK", style: .default) { (_) in
                self.gameInit()
            }
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
            totalCounterLabel.text = "$\(totalCounter)"
        }
    }
}

