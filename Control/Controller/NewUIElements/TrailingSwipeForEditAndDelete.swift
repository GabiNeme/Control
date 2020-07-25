//
//  leadingSwipeForEditAndDelete.swift
//  Control
//
//  Created by Gabriela Neme on 25/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

struct TrailingSwipeForEditAndDelete {
    
    
    
    func get(editHandler: @escaping UIContextualAction.Handler, deleteHandler: @escaping UIContextualAction.Handler  ) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "Editar", handler: editHandler)
                                            
        editAction.image = UIImage(systemName: "square.and.pencil")
        editAction.backgroundColor = .orange
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: deleteHandler)
        deleteAction.image = UIImage(systemName: "trash")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    
}
