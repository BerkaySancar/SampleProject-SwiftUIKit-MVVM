//
//  SliderCellViewModel.swift
//  
//
//  Created by Berkay Sancar on 17.11.2023.
//

import Foundation

protocol SliderCellDelegate: AnyObject {
    func didSelectMovie(with id: Int)
}

final class SliderCellViewModel: BaseCellVM {
    
    weak var delegate: SliderCellDelegate?
    
    var nowPlayings: [Movie]?
    
    init(_ nowPlayings: [Movie]) {
        self.nowPlayings = nowPlayings
    }
    
    var numberOfRows: Int {
        return nowPlayings?.prefix(5).count ?? 0
    }
    
    func getViewModel(indexPath: IndexPath) -> BaseCellVM {
        return NowPlayingCellVM(self.nowPlayings?[indexPath.row])
    }
    
    func didSelectItemAt(indexPath: IndexPath) {
        delegate?.didSelectMovie(with: self.nowPlayings?[indexPath.item].id ?? 0)
    }
}
