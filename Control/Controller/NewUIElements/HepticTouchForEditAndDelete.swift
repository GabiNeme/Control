//
//  HepticTouchForEditAndDelete.swift
//  Control
//
//  Created by Gabriela Neme on 25/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

struct HepticTouchForEditAndDelete {
    
    func get(editHandler: @escaping UIActionHandler, deleteHandler: @escaping UIActionHandler, extraActions: [UIAction]? = nil) -> UIContextMenuConfiguration? {
        
        let editAction = UIAction(title: "Editar", image: UIImage(systemName: "square.and.pencil"), handler: editHandler)

        let deleteAction = UIAction(title: "Apagar", image: UIImage(systemName: "trash"), attributes: .destructive, handler: deleteHandler)

        var actions = [editAction, deleteAction]
        if let newActions = extraActions {
            actions = newActions + actions
        }
        
        let contextMenu = UIContextMenuConfiguration( identifier: nil, previewProvider: nil) { _ in
            return UIMenu(title: "", image: nil, children: actions)
        }

        return contextMenu
    }
    
}
