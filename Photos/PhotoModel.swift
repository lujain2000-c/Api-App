//
//  PhotoModel.swift
//  AppStorge
//
//  Created by لجين إبراهيم الكنهل on 16/11/1444 AH.
//

import Foundation


struct Photos: Codable, Identifiable{
    var id: Int
    let title: String
    let thumbnailUrl: String
}
