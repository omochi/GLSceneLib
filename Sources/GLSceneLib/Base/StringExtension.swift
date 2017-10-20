import Foundation

extension String {
    public func stripped(characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        var s = self
        s = s.strippedRight(characterSet: characterSet)
        s = s.strippedLeft(characterSet: characterSet)
        return s
    }
    
    public func strippedLeft(characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        let view = unicodeScalars
        var newStartIndex = view.startIndex
        while true {
            if newStartIndex == view.endIndex {
                break
            }
            let char = view[newStartIndex]
            if !characterSet.contains(char) {
                break
            }
            newStartIndex = view.index(after: newStartIndex)
        }
        return String(view[newStartIndex..<view.endIndex])
    }
    
    public func strippedRight(characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        let view = unicodeScalars
        var newEndIndex = view.endIndex
        while true {
            if newEndIndex == view.startIndex {
                break
            }
            let leftIndex = view.index(before: newEndIndex)
            let leftChar = view[leftIndex]
            if !characterSet.contains(leftChar) {
                break
            }
            newEndIndex = leftIndex
        }
        return String(view[view.startIndex..<newEndIndex])
    }
    
    public func strippedRightNewline() -> String {
        return strippedRight(characterSet: CharacterSet.newlines)
    }
}
