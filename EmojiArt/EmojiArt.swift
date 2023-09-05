//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Aleksey on 9/4/23.
//

import Foundation

//Модель игры EmojiArt
struct EmojiArt: Codable {
    //хранит ссылку на картинку фона или null
    var backgroundURL: URL?
    
    //массив - хранение добавленных в игру эмоджи с координатами и размером
    var emojis = [Emoji]()
    
    //структура элемента игры Emoji
    struct Emoji: Identifiable, Codable, Hashable {
        let text: String //не меняется, выбирается из палетты
        var x: Int //изменяется пользователем
        var y: Int //изменяется пользователем
        var size: Int //изменяется пользователем
        let id: Int //не меняется, создается при добавлении элемента
        
        //делает невозможным создание Emoji кроме как через метод addEmoji
        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init?(json: Data?) {
        if json != nil, let newEmojiArt = try? JSONDecoder().decode(EmojiArt.self, from: json!) {
            self = newEmojiArt
        } else {
            return nil
        }
    }
    
    init() { }
    
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
