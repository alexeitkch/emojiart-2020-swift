//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by Aleksey on 9/5/23.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        Group {
            if uiImage != nil {
                Image(uiImage: uiImage!)
            }
        }
    }
}
