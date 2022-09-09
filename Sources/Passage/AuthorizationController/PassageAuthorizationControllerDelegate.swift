//
//  PassageAuthorizationControllerDelegate.swift
//  Shiny
//
//  Created by blayne bayer on 8/22/22.
//  Copyright © 2022 Apple. All rights reserved.
//

protocol PassageAuthorizationControllerDelegate {
    
    func success() -> Void
    func error(error: Error) -> Void
    func didCancelModalSheet() -> Void
    
}


