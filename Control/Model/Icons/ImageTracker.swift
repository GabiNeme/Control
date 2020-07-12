//
//  ImageTracker.swift
//  Control
//
//  Created by Gabriela Neme on 12/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//
import UIKit


struct ImageTracker {
    
    func getImage(index: Int) -> UIImage? {
        if index < imageListSFSymbols.count {
            return UIImage(systemName: imageListSFSymbols[index])
        }else{
            return UIImage(named: imageListExternal[index - imageListSFSymbols.count])
        }
    }
    
    func getImage(index: Int) -> IconImage {
        var type: imageType
        var name: String
        
        if index < imageListSFSymbols.count {
            type = .SFSymbol
            name = imageListSFSymbols[index]
        }else{
            type = .external
            name = imageListExternal[index - imageListSFSymbols.count]
        }
        return IconImage(type: type, name: name)
    }
    
    var imagesCount: Int {
        return imageListSFSymbols.count + imageListExternal.count
    }
    
    private var imageListSFSymbols = [
        "square.and.arrow.up",
        "square.and.arrow.down",
        "pencil",
        "pencil.and.outline",
        "trash",
        "folder",
        "paperplane",
        "tray",
        "tray.and.arrow.up",
        "tray.and.arrow.down",
        "tray.2",
        "tray.full",
        "archivebox",
        "doc",
        "doc.richtext",
        "doc.plaintext",
        "book",
        "bookmark",
        "rosette",
        "paperclip",
        "link",
        "pencil.tip",
        "person",
        "person.2",
        "person.3",
        "person.crop.square",
        "globe",
        "sun.max",
        "moon",
        "zzz",
        "cloud",
        "sparkles",
        "umbrella",
        "flame",
        "speaker.2",
        "music.note",
        "music.mic",
        "suit.heart",
        "suit.club",
        "suit.spade",
        "suit.diamond",
        "star",
        "flag",
        "bell",
        "bolt",
        "ant",
        "flashlight.off.fill",
        "camera",
        "message",
        "phone",
        "video",
        "envelope",
        "gear",
        "scissors",
        "bag",
        "bag.fill",
        "cart",
        "cart.fill",
        "creditcard",
        "creditcard.fill",
        "gauge",
        "paintbrush",
        "bandage",
        "wrench",
        "hammer",
        "printer",
        "briefcase",
        "house",
        "lock",
        "wifi",
        "pin",
        "map",
        "tv",
        "guitars",
        "car",
        "tram.fill",
        "bed.double",
        "film",
        "sportscourt",
        "smiley",
        "qrcode",
        "barcode",
        "photo",
        "shield",
        "clock",
        "alarm",
        "gamecontroller",
        "ear",
        "chart.bar",
        "chart.pie",
        "waveform.path.ecg",
        "headphones",
        "gift",
        "airplane",
        "studentdesk",
        "hourglass",
        "scribble",
        "eyeglasses",
        "lightbulb",
        "percent",
        "at",
        "dollarsign.circle",
        "dollarsign.circle.fill",
        "dollarsign.square",
        "dollarsign.square.fill"
    ]
    
    private var imageListExternal = [
        "wallet",
        "bank"
    
    
    ]
    
    
}


