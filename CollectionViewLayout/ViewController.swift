//
//  ViewController.swift
//  CollectionViewLayout
//
//  Created by 顾钱想 on 2023/7/22.
//

//https://mario-ol.sns.sohu.com/mario/aggr/v1/today?version=2.20.0&appid=330007&flyer=1691048254592&app_key_vs=2.20.0&platform=2&uid=1141103&cid=027085068827205583104&client=1&supportTpls=7%2C8%2C9%2C10%2C11%2C12%2C13&sig=96454bc7971d69cfc5947c6956097809

import UIKit

class ViewController: UIViewController {
    
    let layout = AnimatedCollectionViewLayout()
    
    var items: [Card] = []
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        //collectionView.isPagingEnabled = true
        let dis = UIScreen.main.bounds.height / 2 - (UIScreen.main.bounds.height - layout.visibleNextCardHeight) / 2
        collectionView.contentInset = UIEdgeInsets.init(top: k_Height_StatusBar, left: 0, bottom: dis, right: 0)
        self.view.addSubview(collectionView)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        getData()
    }
    
    func getData() {
        let str = "https://mario-ol.sns.sohu.com/mario/aggr/v1/today?version=2.20.0&appid=330007&flyer=1691048254592&app_key_vs=2.20.0&platform=2&uid=1141103&cid=027085068827205583104&client=1&supportTpls=7%2C8%2C9%2C10%2C11%2C12%2C13&sig=96454bc7971d69cfc5947c6956097809"
        let url = URL(string: str)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: url) { [self] data, response, error in
            if let data = data {
                do {
                    let my = try JSONDecoder().decode(MY.self, from: data)
                    items = my.data.cards
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.collectionView.scrollToItem(at: .init(row: self.items.count, section: 0), at: .top, animated: false)
                    }
                } catch {
                    print(error)
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        task.resume()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count * 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.card = items[indexPath.row % items.count]
        //print(items[indexPath.row % items.count].url)
        return cell
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pointInView = view.convert(collectionView.center, to: collectionView)
        let indexPath = collectionView.indexPathForItem(at: pointInView)
        let pageHeight = layout.itemSize.height + layout.minimumLineSpacing
        if (indexPath?.row == 0) {
            collectionView.scrollToItem(at: IndexPath.init(row: items.count, section: 0), at: UICollectionView.ScrollPosition.top, animated: false)
        } else if (indexPath?.row == items.count * 2 - 1) {
            collectionView.scrollToItem(at: IndexPath.init(row: items.count - 1, section: 0), at: UICollectionView.ScrollPosition.top, animated: false)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {

    }
}
