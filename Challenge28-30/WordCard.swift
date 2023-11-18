import UIKit

class WordCard: UIImageView {
    var word: String?
    var imageForSize = UIImage(named: "cardBack")
    
    init(word: String?) {
        super.init(frame: .zero)
        
        self.word = word
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        guard let size = imageForSize?.size else { return }
        guard let word = self.word else { return }
        
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image(actions: { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Noteworthy", size: 20) ?? UIFont.systemFont(ofSize: 20),
                .foregroundColor: UIColor.black,
                .paragraphStyle: paragraphStyle
            ]
            let attributedString = NSAttributedString(string: word, attributes: attrs)
            
            attributedString.draw(at: CGPoint(x: size.width / 2 - attributedString.size().width / 2, y: size.height / 2 - attributedString.size().height / 2))
            ctx.cgContext.stroke(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        })
        
        self.image = image
    }
}
