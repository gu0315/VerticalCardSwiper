//
//  CollectionViewCell.swift
//  CollectionViewLayout
//
//  Created by 顾钱想 on 2023/7/22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView.init()
    
    var card: Card? {
        didSet {
            guard let card = card else { return }
            if let imageURL = URL(string: card.url) {
                let task = URLSession.shared.dataTask(with: .init(url: imageURL), completionHandler: { (data, response, error) in
                    // 在这里处理获取的图片数据
                    if let error = error {
                        print("Error fetching image: \(error)")
                        return
                    }
                    // 确保有数据返回
                    guard let data = data else {
                        print("No image data received")
                        return
                    }
                    if let img = UIImage.init(data: data) {
                        DispatchQueue.main.async {
                            self.imageView.image = img
                        }
                    }
                })
                task.resume()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = .init(x: 16, y: 0, width: frame.width - 32, height: frame.height)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        self.contentView.addSubview(imageView)
        self.contentView.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
