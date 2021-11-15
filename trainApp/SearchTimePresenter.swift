//
//  TopPresenter.swift
//  trainApp
//
//  Created by Arai Kousuke on 2021/11/15.
//

import Foundation

protocol SearchTimePresenterInput {
    func didSearchButtonPressed(fromString: String, toString: String)
}

protocol SearchTimePresenterOutput {
    func updateTimes(timeText: String)
}

final class SearchTimePresenter: SearchTimePresenterInput {
    
    func didSearchButtonPressed(fromString: String, toString: String) {
        <#code#>
    }
}
