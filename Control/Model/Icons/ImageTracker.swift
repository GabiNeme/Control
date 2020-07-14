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
        "trash",
        "folder",
        "paperplane",
        "tray",
        "tray.2",
        "tray.full",
        "archivebox",
        "doc",
        "doc.richtext",
        "doc.plaintext",
        "book",
        "rosette",
        "paperclip",
        "link",
        "pencil.tip",
        "person",
        "person.2",
        "person.crop.square",
        "globe",
        "sun.max",
        "moon",
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
        "android",
        "apartment",
        "architecture",
        "bank",
        "beach",
        "beauty",
        "bed",
        "beer",
        "bible",
        "boat",
        "bone",
        "book",
        "bus",
        "cafe",
        "cake",
        "calculator_2",
        "calculator",
        "card_travel",
        "cat",
        "child_cart",
        "child",
        "cleaning",
        "clothes",
        "coin",
        "couch",
        "dinning",
        "eco",
        "email",
        "family",
        "fast_food",
        "fitness",
        "flower",
        "fridge",
        "gas_station",
        "gavel",
        "grass",
        "hanger",
        "heart_tag",
        "heels",
        "home",
        "hospital",
        "lab",
        "makeup",
        "martini",
        "money",
        "money_2",
        "money_3",
        "motorcycle",
        "needle",
        "notebook",
        "other",
        "pants_f",
        "pants",
        "panty",
        "penalty",
        "pets",
        "phone_android",
        "phone_iphone",
        "pig",
        "pill",
        "power",
        "puzzle",
        "restaurant",
        "room_service",
        "saloon_2",
        "saloon",
        "shoes",
        "socks",
        "spa",
        "sports_baseball",
        "sports_basketball",
        "sports_esports",
        "sports_motorsports",
        "sports_soccer",
        "sports_tennis",
        "sports_volleyball",
        "store",
        "suitcase",
        "taxi",
        "ticket",
        "tools",
        "tooth",
        "transport",
        "trophy",
        "tshirt_2",
        "tshirt",
        "tv",
        "university",
        "usb",
        "van",
        "wallet",
        "waves",
        "wine",
        "work",
        "work_black",
        "b01",
        "b02",
        "b03",
        "b04",
        "b05",
        "b06",
        "b07",
        "b08",
        "b09",
        "b10",
        "b11",
        "b12",
        "b13",
        "b14",
        "b15",
        "b16",
        "b17",
        "b18",
        "b19",
        "b20"
    
    
    ]
    
    
}


