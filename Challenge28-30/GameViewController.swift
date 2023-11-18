import UIKit

class GameViewController: UIViewController {
    @IBOutlet var buttons: [UIButton]!
    var wordPairsCopy = [String]()
    var gamePairs = [String]()
    var soloWords = [String?]()
    var selectedWord: String?
    var firstTap = false
    var secondTap = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        loadWords()
    }
    
    func loadWords() {
        while gamePairs.count < 12 {
            wordPairsCopy.shuffle()
            if !gamePairs.contains(wordPairsCopy[0]) {
                gamePairs.append(wordPairsCopy[0])
            }
        }
        
        for pair in gamePairs {
            let words = pair.components(separatedBy: " | ")
            let word1 = words[0]
            let word2 = words[1]
            soloWords.append(word1)
            soloWords.append(word2)
        }
        
        soloWords.shuffle()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let tappedWord = soloWords[sender.tag] else { return }
        
        if !firstTap {
            firstTap = true
        } else if !secondTap {
            secondTap = true
            view.isUserInteractionEnabled = false
        }
        
        let wordCard = WordCard(word: tappedWord)
        sender.setImage(wordCard.image, for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            if self?.selectedWord == nil {
                self?.selectedWord = self?.soloWords[sender.tag]
            } else {
                let wordPair1 = (self?.selectedWord!)! + " | " + tappedWord
                let wordPair2 = tappedWord + " | " + (self?.selectedWord!)!
                
                if ((self?.gamePairs.contains(wordPair1)) == true) || ((self?.gamePairs.contains(wordPair2)) == true) {
                    self?.soloWords[sender.tag] = nil
                    sender.isHidden = true
                    if let index = self?.soloWords.firstIndex(of: self?.selectedWord) {
                        self?.soloWords[index] = nil
                        self?.selectedWord = nil
                        if let buttons = self?.buttons {
                            for button in buttons {
                                if button.tag == index {
                                    button.isHidden = true
                                }
                            }
                            self?.view.isUserInteractionEnabled = true
                            self?.firstTap = false
                            self?.secondTap = false
                        }
                    }
                    
                    var counter = 0
                    if let soloWords = self?.soloWords {
                        for word in soloWords {
                            if word != nil {
                                counter += 1
                            }
                        }
                        if counter == 0 {
                            self?.gameOver()
                        }
                    }
                } else {
                    sender.setImage(UIImage(named: "cardBack"), for: .normal)
                    
                    if let index = self?.soloWords.firstIndex(of: self?.selectedWord) {
                        self?.selectedWord = nil
                        if let buttons = self?.buttons {
                            for button in buttons {
                                if button.tag == index {
                                    button.setImage(UIImage(named: "cardBack"), for: .normal)
                                }
                            }
                            self?.view.isUserInteractionEnabled = true
                            self?.firstTap = false
                            self?.secondTap = false
                        }
                    }
                }
            }
        }
    }
    
    func gameOver() {
        let ac = UIAlertController(title: "Congratulations!", message: "You won!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Back to menu", style: .default) { [weak self] _ in
            if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "Main") as? ViewController {
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        })
        present(ac,animated: true)
    }
}
