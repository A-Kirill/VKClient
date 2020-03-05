//
//  GroupsViewModelFactory.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 03.03.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//

import UIKit

final class GroupsViewModelFactory {
    
    func constructViewModels(from groups: [Groups]) -> [GroupsViewModel] {
        return groups.compactMap(self.viewModel)
    }
    
    private func viewModel(from groups: Groups) -> GroupsViewModel {

        
        let nameLabel = groups.name
        let image = UIImage(named: groups.photo50)
//        if let imageURL = URL(string: groups.photo50) {
//            DispatchQueue.global().async {
//                let data = try? Data(contentsOf: imageURL)
//                if let data = data {
//                    let image = UIImage(data: data)
//                }
//            }
//        }
        
        return GroupsViewModel(nameLabel: nameLabel, groupImageView: image)
    }    
}
