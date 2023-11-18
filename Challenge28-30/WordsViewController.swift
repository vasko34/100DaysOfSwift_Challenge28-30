import UIKit

class WordsViewController: UITableViewController {
    var wordPairsCopy = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordPairsCopy.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordPair", for: indexPath)
        cell.textLabel?.text = wordPairsCopy[indexPath.row]
        return cell
    }
    
    @objc func addTapped() {
        let ac1 = UIAlertController(title: "Enter first word:", message: nil, preferredStyle: .alert)
        ac1.addTextField()
        ac1.addAction(UIAlertAction(title: "Done", style: .default) { [weak self, weak ac1] _ in
            if let textField1 = ac1?.textFields?[0].text {
                if textField1.count < 2 {
                    self?.showInvalidInputAlert()
                } else {
                    let ac2 = UIAlertController(title: "Enter second word:", message: nil, preferredStyle: .alert)
                    ac2.addTextField()
                    ac2.addAction(UIAlertAction(title: "Done", style: .default) { [weak self, weak ac2] _ in
                        if let textField2 = ac2?.textFields?[0].text {
                            if textField2.count < 2 {
                                self?.showInvalidInputAlert()
                            } else {
                                self?.addWordPair(word1: textField1, word2: textField2)
                            }
                        }
                    })
                    self?.present(ac2, animated: true)
                }
            }
        })
        present(ac1, animated: true)
    }
    
    func addWordPair(word1: String, word2: String) {
        let wordPair1 = word1 + " | " + word2
        let wordPair2 = word2 + " | " + word1
        if wordPairsCopy.contains(wordPair1) || wordPairsCopy.contains(wordPair2) {
            showInvalidInputAlert(isTooShort: false)
        } else {
            wordPairsCopy.append(wordPair1)
            if let vc = storyboard?.instantiateViewController(withIdentifier: "Main") as? ViewController {
                vc.wordPairs = wordPairsCopy
                vc.saveWordPairs()
            }
            tableView.reloadData()
        }
    }
    
    func showInvalidInputAlert(isTooShort: Bool = true) {
        let message: String
        
        if isTooShort {
            message = "The word must be atleast 2 letters long."
        } else {
            message = "This word pair is already in the game."
        }
        
        let ac = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}
