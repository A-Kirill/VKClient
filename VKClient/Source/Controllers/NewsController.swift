//
//  NewsController.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 29.09.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit
import RealmSwift

class NewsController: UITableViewController {
    
    
    let vkApi = VKApi()
    var allUserNews: NewsResponse?
    var allGroupsRealm: Results<Groups>!
    var photoNews: PhotoNewsResponse?
    lazy var photoService = PhotoService(container: self.tableView)
    var dateTextCache: [IndexPath: String] = [:]
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy HH.mm"
        return df
    }()
//    var allUserNews = [NewsModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "newsIdentifier")
        allGroupsRealm = DatabaseRealm.shared.getRealmGroups()
        //request news post
        vkApi.getUserNews() { [weak self] allUserNews in
            self?.allUserNews = allUserNews
            self?.tableView.reloadData()
        }
        //request news photo
        vkApi.getPhotoNews() { [weak self] photoNews in
            self?.photoNews = photoNews
            self?.tableView.reloadData()
        }
        
        setupRefreshControl()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 40
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUserNews?.items.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsIdentifier", for: indexPath) as! NewsCell
        let itemList = allUserNews?.items
        
        cell.descriptionLabel.text = itemList?[indexPath.row].text
        cell.counterLabel.text = "\(itemList?[indexPath.row].likes?.count ?? 0)"
        cell.viewCounter.text = "\(itemList?[indexPath.row].views?.count ?? 0)"
        cell.dateLabel.text = getCellDateText(forIndexPath: indexPath, andTimestamp: Double((itemList?[indexPath.row].date)!))
        for i in allGroupsRealm {
            if -i.id == itemList?[indexPath.row].sourceID {
                if let imageURL = URL(string: i.photo50) {
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: imageURL)
                        if let data = data {
                            let image = UIImage(data: data)
                            DispatchQueue.main.async {
                                cell.avaImage.image = image
                                cell.nameLabel.text = i.name
                            }
                        }
                    }
                }
            }
        }
        
        if let attach = itemList?[indexPath.row].attachments {
            for ph in attach {
                let photos = ph.photo?.sizes ?? []
                for urlPhoto in photos {
                    if urlPhoto.type == "x" {
                        cell.imageView?.image = photoService.photo(atIndexpath: indexPath, byUrl: urlPhoto.url)
//                        if let imageURL = URL(string: urlPhoto.url) {
//                            DispatchQueue.global().async {
//                                let data = try? Data(contentsOf: imageURL)
//                                if let data = data {
//                                    let image = UIImage(data: data)
//                                    DispatchQueue.main.async {
//                                        cell.imageView?.image = image
//                                    }
//                                }
//                            }
//                        }

                    }
                }
            }
        }

        return cell
    }
    
    func getCellDateText(forIndexPath indexPath: IndexPath, andTimestamp timestamp: Double) -> String {
        if let stringDate = dateTextCache[indexPath] {
            return stringDate
        } else {
            let date = Date(timeIntervalSince1970: timestamp)
            let stringDate = dateFormatter.string(from: date)
            dateTextCache[indexPath] = stringDate
            return stringDate
        }
    }
    
    //Pull-to-refresh
    fileprivate func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl?.tintColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }

    @objc func refreshNews() {
        self.refreshControl?.beginRefreshing()
        vkApi.getUserNews() { [weak self] allUserNews in
            self?.allUserNews = allUserNews
            self?.tableView.reloadData()
        }
        self.refreshControl?.endRefreshing()
    }

}


//var allNews: [News] = [
//    News(name: "SlashGear", date: "26.09.2019", avatar: UIImage(named: "Slash"), image: UIImage(named: "S3"), description: "Wheat is one of the world's vital crops, joining corn and rice in feeding a vast number of people around the world. Experts have been raising the alarm bell about climate change and its potential impact on these crops for years"),
//    News(name: "SlashGear", date: "29.09.2019", avatar: UIImage(named: "Slash"), image: UIImage(named: "S1"), description: "iOS 13 already rolled out but, unlike the betas and Apple's announcements, it launched alone. The much-hyped iPadOS came a few days later but the matching macOS Catalina, a.k.a. macOS 10.15 was still nowhere in sight. Apple said it would start rolling out some time in October but didn't give a date users could pin on their calendar."),
//    News(name: "SlashGear", date: "26.09.2019", avatar: UIImage(named: "Slash"), image: UIImage(named: "S2"), description: "It's been a big week for iFixit teardowns. First, we saw the company teardown the iPhone 11 after last week's look inside the iPhone 11 Pro. That was followed by a teardown of the Nintendo Switch Lite, but today we're back to looking at Apple devices."),
//    News(name: "GeekBrains", date: "26.09.2019", avatar: UIImage(named: "GeekBrains"), image: UIImage(named: "G1"), description: "Программист должен быть ленивым, нетерпеливым и самоуверенным. Так считает Ларри Уолл, создатель языка Perl. И большинство IT-специалистов подтвердят, что это правда.")
//]

//        cell.nameLabel.text = allNews[indexPath.row].name
//        cell.dateLabel.text = allNews[indexPath.row].date
//        cell.descriptionLabel.text = allNews[indexPath.row].description
//        cell.avaImage?.image = allNews[indexPath.row].avatar
//        cell.newsImage?.image = allNews[indexPath.row].image
