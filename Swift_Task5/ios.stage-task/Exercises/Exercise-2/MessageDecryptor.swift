import UIKit

extension String {
    func match(_ regex: String) -> [[String]] {
        let nsString = self as NSString
        return (try? NSRegularExpression(pattern: regex, options: []))?.matches(in: self, options: [], range: NSMakeRange(0, nsString.length)).map { match in
            (0..<match.numberOfRanges).map { match.range(at: $0).location == NSNotFound ? "" : nsString.substring(with: match.range(at: $0)) }
        } ?? []
    }
}


class MessageDecryptor: NSObject {
    
    fileprivate func getGroups(_ message: String) -> [String] {
        var isInGroup = false;
        var bracersCounter=0;
        var buffer = "";
        var groups: [String] = []
        
        func writeBuffer(){
            if(!buffer.isEmpty){
                groups.append(buffer)
                buffer = ""
            }
        }
        
        for char in message{
            if(char > "0" && char < "9"){
                if(!buffer.isEmpty && !isInGroup){
                    writeBuffer()
                }
                isInGroup = true
                buffer.append(char)
            }else if(char == "["){
                isInGroup = true;
                bracersCounter+=1
                buffer.append(char)
            } else if( char == "]"){
                bracersCounter-=1
                buffer.append(char)
                if(bracersCounter == 0){
                    isInGroup=false
                    writeBuffer()
                }
            }
            else {
                buffer.append(char)
            }
        }
        writeBuffer()
        
        return groups;
    }
    
    func decryptMessage(_ message: String) -> String {
        if (message.count > 60 ){
            return ""
        }
        
        let groups = getGroups(message)
        if(groups.count == 0){
            return message
        }
        
        var result = ""
        for group in groups{
            let matches = group.match(#"(\d*)\[(.*)\]"#)
            if(matches.count > 0) {
                let subString = matches[0][2]
                let count = Int(matches[0][1]) ?? 1
                if(count>300){
                    return ""
                }else if(count > 0){
                    let decoded = decryptMessage(subString)
                    result.append(String(repeating: decoded, count: count))
                }
            }
            else{
                result.append(group)
            }
        }
        
        return result
    }
}
