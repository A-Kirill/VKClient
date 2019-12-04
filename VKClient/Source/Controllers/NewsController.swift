//
//  NewsController.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 29.09.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit

class NewsController: UITableViewController {
    
    var allNews: [News] = [
        News(name: "SlashGear", date: "26.09.2019", avatar: UIImage(named: "Slash"), image: UIImage(named: "S3"), description: "Wheat is one of the world's vital crops, joining corn and rice in feeding a vast number of people around the world. Experts have been raising the alarm bell about climate change and its potential impact on these crops for years"),
        News(name: "SlashGear", date: "29.09.2019", avatar: UIImage(named: "Slash"), image: UIImage(named: "S1"), description: "iOS 13 already rolled out but, unlike the betas and Apple's announcements, it launched alone. The much-hyped iPadOS came a few days later but the matching macOS Catalina, a.k.a. macOS 10.15 was still nowhere in sight. Apple said it would start rolling out some time in October but didn't give a date users could pin on their calendar."),
        News(name: "SlashGear", date: "26.09.2019", avatar: UIImage(named: "Slash"), image: UIImage(named: "S2"), description: "It's been a big week for iFixit teardowns. First, we saw the company teardown the iPhone 11 after last week's look inside the iPhone 11 Pro. That was followed by a teardown of the Nintendo Switch Lite, but today we're back to looking at Apple devices."),
        News(name: "GeekBrains", date: "26.09.2019", avatar: UIImage(named: "GeekBrains"), image: UIImage(named: "G1"), description: "Программист должен быть ленивым, нетерпеливым и самоуверенным. Так считает Ларри Уолл, создатель языка Perl. И большинство IT-специалистов подтвердят, что это правда.")
    ]
    
    let vkApi = VKApi()
    var allUserNews: NewsResponse?
//    var allUserNews = [NewsModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "newsIdentifier")

        //request news
        vkApi.getUserNews() { [weak self] allUserNews in
            self?.allUserNews = allUserNews
            self?.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 388
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNews.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsIdentifier", for: indexPath) as! NewsCell
        cell.nameLabel.text = allNews[indexPath.row].name
        cell.dateLabel.text = allNews[indexPath.row].date
        cell.descriptionLabel.text = allNews[indexPath.row].description
        cell.avaImage?.image = allNews[indexPath.row].avatar
        cell.newsImage?.image = allNews[indexPath.row].image
        return cell
    }

}
