//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Aleksey on 9/4/23.
//

import Foundation

//Модель игры EmojiArt
struct EmojiArt {
    //хранит ссылку на картинку фона или null
    var backgroundURL: URL?
    
    //массив - хранение добавленных в игру Emoji
    var emojis = [Emoji]()
    
    //структура элемента игры Emoji
    struct Emoji: Identifiable {
        let text: String //не меняется выбирается из палетты
        var x: Int //будет изменяться пользователем
        var y: Int //будет изменяться пользователем
        var size: Int //будет изменяться пользователем
        let id: Int //не будет меняться, создается при добавлении элемента
        
        //делает невозможным создание Emoji кроме как через метод addEmoji
        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
    
    //хранит номер последнего созданного Emoji
    private var uniqueEmojiId = 0
    
    //функция которую будем вызывать при добавлении нового элемента игры
    mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int) {
        //новый id
        uniqueEmojiId += 1
        //добавляем Emoji в массив
        emojis.append(Emoji(text: text, x: x, y: y, size: size, id: uniqueEmojiId))
    }
}
