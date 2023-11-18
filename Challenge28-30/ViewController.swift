import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    @IBOutlet var startGameButton: UIButton!
    @IBOutlet var wordPairsButton: UIButton!
    @IBOutlet var unlockButton: UIButton!
    var wordPairs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        performSelector(inBackground: #selector(loadWordPairs), with: nil)
    }
    
    @IBAction func startGame(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Game") as? GameViewController {
            vc.wordPairsCopy = wordPairs
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func openWordsMenu(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Words") as? WordsViewController {
            vc.wordPairsCopy = wordPairs
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func saveWordPairs() {
        let defaults = UserDefaults.standard
        let jsonEncoder = JSONEncoder()
        
        if let savedWordPairs = try? jsonEncoder.encode(wordPairs) {
            defaults.setValue(savedWordPairs, forKey: "wordPairs")
        }
    }
    
    @objc func loadWordPairs() {
        let defaults = UserDefaults.standard
        let jsonDecoder = JSONDecoder()
        
        if let wordPairsToLoad = defaults.object(forKey: "wordPairs") as? Data {
            do {
                wordPairs = try jsonDecoder.decode([String].self, from: wordPairsToLoad)
            } catch {
                print("Failed to load word pairs.")
            }
        }
    }
    
    @IBAction func unlockTapped(_ sender: UIButton) {
        let context = LAContext()
        let reason = "Identify yourself"
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockButton.isHidden = true
                        self?.startGameButton.isHidden = false
                        self?.wordPairsButton.isHidden = false
                    } else {
                        let ac = UIAlertController(title: "Authentication Failed", message: "Please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Error", message: "Biometric authentication is disabled ot unavailable.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

