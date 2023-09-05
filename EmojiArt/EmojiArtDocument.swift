//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Aleksey on 9/4/23.
//

import SwiftUI

//ViewModel для каждой новой игры создается новый экземпляр класса
class EmojiArtDocument: ObservableObject {
    
    static let palette: String = "⭐️🌨🍎🥨⚾️"
    
    //при создании экземпляра класса создается экземпляр модели игры
    //@Published
    private var emojiArt: EmojiArt {
        willSet {
            objectWillChange.send()
        }
        didSet {
            print("json = \(emojiArt.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(emojiArt.json, forKey: EmojiArtDocument.untitled)
        }
    }
    
    private static let untitled = "EmojiArtDocument.Untitled"
    
    init() {
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocument.untitled)) ?? EmojiArt()
        fetchBackgroundImageData()
    }
    
    //изображение фона, которое будет получаться из браузера методом drag_and_drop
    @Published private(set) var backgroundImage: UIImage?
    
    //массив эмоджи для экземпляра игры
    var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
    
    //MARK: - Intent(s)
    //методы которыми можно изменять экземпляр модели
    
    //добавить новый объект в массив эмоджи
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    //переместить существующий объект
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    //изменить размер существующего объекта
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }
    
    func setBackgroundURL(_ url: URL?) {
        emojiArt.backgroundURL = url?.imageURL
        fetchBackgroundImageData()
    }
    
    private func fetchBackgroundImageData() {
        backgroundImage = nil
        if let url = self.emojiArt.backgroundURL {
            //применение многопоточности для выполнения длительных по времени запросов в глобальной сети
            DispatchQueue.global(qos: .userInitiated).async {
                //попытка получить картинку с сайта через ссылку
                if let imageData = try? Data(contentsOf: url) {
                    //если получилось возвращаемся в галавную очередь и устанавливаем ее фоном приложения
                    DispatchQueue.main.async {
                        if url == self.emojiArt.backgroundURL {
                            self.backgroundImage = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
