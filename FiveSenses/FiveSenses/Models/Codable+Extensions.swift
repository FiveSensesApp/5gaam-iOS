//
//  Codable+Extensions.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/12.
//


import Foundation

struct AnyKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    init(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}

enum CustomDecodingError: Error {
    case keyNotFound
}


// MARK: - Decoding Extensions
extension KeyedDecodingContainer {
    
    private func decodeTypeCast<T>(_ type: T.Type, forKey key: KeyedDecodingContainer.Key) throws -> T where T: Decodable {
        var result:Any? = nil
        switch T.self {
        case is Bool.Type, is Bool?.Type:
            result = try decode(Bool.self, key: key)
        case is String.Type, is String?.Type:
            result = try decode(String.self, key: key)
        case is Int.Type, is Int?.Type:
            result = try decode(Int.self, key: key)
        default:
            result = try decode(T.self, forKey: key)
        }
        if let ret = result as? T {
            return ret
        }
        throw CustomDecodingError.keyNotFound
    }
    
    func decode<T>(_ key: KeyedDecodingContainer.Key) throws -> T where T: Decodable {
        return try decodeTypeCast(T.self, forKey: key)
    }
    
    func decode<T>(_ keyArray: [KeyedDecodingContainer.Key]) throws -> T where T: Decodable {
        
        for key in keyArray {
            if let value = try? decodeTypeCast(T.self, forKey: key) {
                return value
            }
        }
        
        throw CustomDecodingError.keyNotFound
    }
    
    subscript<T>(key: Key) -> T where T: Decodable {
        return try! decode(T.self, forKey: key)
    }
}

extension SingleValueDecodingContainer {
    mutating func decode<T>() throws -> [T] where T: Decodable {
        return try decode([T].self)
    }
}

extension UnkeyedDecodingContainer {
    mutating func decode<T>() throws -> T where T: Decodable {
        return try decode(T.self)
    }
}

extension KeyedDecodingContainer where K == AnyKey {

    func decode<T>(_ type: T.Type, forMappedKey key: String, in keyMap: [String: [String]]) throws -> T where T : Decodable{

        for key in keyMap[key] ?? [] {
            if let value = try? decode(T.self, forKey: AnyKey(stringValue: key)) {
                return value
            }
        }

        return try decode(T.self, forKey: AnyKey(stringValue: key))
    }
}

extension KeyedDecodingContainer {
    
    func decode(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any] {
        let container = try self.nestedContainer(keyedBy: AnyKey.self, forKey: key)
        return try container.decode(type)
    }

    func decode(_ type: [[String: Any]].Type, forKey key: K) throws -> [[String: Any]] {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        if let decodedData = try container.decode([Any].self) as? [[String: Any]] {
            return decodedData
        } else {
            return []
        }
    }
    
    func decode(_ type: [Any].Type, forKey key: K) throws -> [Any] {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }

    func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        var dictionary = [String: Any]()
        for key in allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if let nestedArray = try? decode(Array<Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedArray
            }
        }
        return dictionary
    }
}

extension UnkeyedDecodingContainer {
    mutating func decode(_ type: [Any].Type) throws -> [Any] {
        var array: [Any] = []
        while isAtEnd == false {
            // See if the current value in the JSON array is `null` first and prevent infite recursion with nested arrays.
            if try decodeNil() {
                continue
            } else if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? decode(Array<Any>.self) {
                array.append(nestedArray)
            }
        }
        return array
    }

    mutating func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        let nestedContainer = try self.nestedContainer(keyedBy: AnyKey.self)
        return try nestedContainer.decode(type)
    }
}

//MARK: - Encoding Extensions
extension KeyedEncodingContainer {
    mutating func encodeIfPresent(_ value: [String: Any]?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        guard let safeValue = value, !safeValue.isEmpty else {
            return
        }
        var container = self.nestedContainer(keyedBy: AnyKey.self, forKey: key)
        for item in safeValue {
            if let val = item.value as? Int {
                try container.encodeIfPresent(val, forKey: AnyKey(stringValue: item.key))
            } else if let val = item.value as? String {
                try container.encodeIfPresent(val, forKey: AnyKey(stringValue: item.key))
            } else if let val = item.value as? Double {
                try container.encodeIfPresent(val, forKey: AnyKey(stringValue: item.key))
            } else if let val = item.value as? Float {
                try container.encodeIfPresent(val, forKey: AnyKey(stringValue: item.key))
            } else if let val = item.value as? Bool {
                try container.encodeIfPresent(val, forKey: AnyKey(stringValue: item.key))
            } else if let val = item.value as? [Any] {
                try container.encodeIfPresent(val, forKey: AnyKey(stringValue: item.key))
            } else if let val = item.value as? [String: Any] {
                try container.encodeIfPresent(val, forKey: AnyKey(stringValue: item.key))
            }
        }
    }
    
    mutating func encodeIfPresent(_ value: [Any]?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        guard let safeValue = value else {
            return
        }
        if let val = safeValue as? [Int] {
            try self.encodeIfPresent(val, forKey: key)
        } else if let val = safeValue as? [String] {
            try self.encodeIfPresent(val, forKey: key)
        } else if let val = safeValue as? [Double] {
            try self.encodeIfPresent(val, forKey: key)
        } else if let val = safeValue as? [Float] {
            try self.encodeIfPresent(val, forKey: key)
        } else if let val = safeValue as? [Bool] {
            try self.encodeIfPresent(val, forKey: key)
        } else if let val = value as? [[String: Any]] {
            var container = self.nestedUnkeyedContainer(forKey: key)
            try container.encode(contentsOf: val)
        }
    }
}

extension UnkeyedEncodingContainer {
    mutating func encode(contentsOf sequence: [[String: Any]]) throws {
        for dict in sequence {
            try self.encodeIfPresent(dict)
        }
    }
    
    mutating func encodeIfPresent(_ value: [String: Any]) throws {
        var container = self.nestedContainer(keyedBy: AnyKey.self)
        for item in value {
            if let val = item.value as? Int {
                try container.encodeIfPresent(val, forKey: AnyKey(stringValue: item.key))
            } else if let val = item.value as? String {
                try container.encodeIfPresent(val, forKey: AnyKey(stringValue: item.key))
            } else if let val = item.value as? Double {
                try container.encodeIfPresent(val, forKey: AnyKey(stringValue: item.key))
            } else if let val = item.value as? Float {
                try container.encodeIfPresent(val, forKey: AnyKey(stringValue: item.key))
            } else if let val = item.value as? Bool {
                try container.encodeIfPresent(val, forKey: AnyKey(stringValue: item.key))
            } else if let val = item.value as? [Any] {
                try container.encodeIfPresent(val, forKey: AnyKey(stringValue: item.key))
            } else if let val = item.value as? [String: Any] {
                try container.encodeIfPresent(val, forKey: AnyKey(stringValue: item.key))
            }
        }
    }
}


extension Encodable {
    func toDictionary() -> [String: Any]? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        
        let data = try? encoder.encode(self)
        let jsonData = try? JSONSerialization.jsonObject(with: data ?? Data())
        return jsonData as? [String: Any]
    }
}

extension JSONSerialization {
    static func data(from value: Any?) -> Data? {
        guard let value = value else {
            return nil
        }
        return try? JSONSerialization.data(withJSONObject: value, options: [.prettyPrinted])
    }
}

extension JSONDecoder {
    static var defaultJSONDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatType.Server.rawValue
        
        // Date format이 다른 경우 대응
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            
            if let dateStr = try? container.decode(String.self) {
                if let date = dateFormatter.date(from: dateStr) {
                    return date
                } else {
                    dateFormatter.dateFormat = DateFormatType.Parameter.rawValue
                    if let date = dateFormatter.date(from: dateStr) {
                        return date
                    }
                    
                    return Date(timeIntervalSince1970: Double(dateStr) ?? 0.0)
                }
            } else {
                if let dateInt = try? container.decode(Int64.self) {
                    // 13자리 time stamp ex) 1649922681000
                    if String(dateInt).count == 13 {
                        return Date(timeIntervalSince1970: TimeInterval(dateInt/1000))
                    }
                    
                    // 10자리 time stamp ex) 1650136348
                    if String(dateInt).count == 10 {
                        return Date(timeIntervalSince1970: TimeInterval(dateInt))
                    }
                }
            }
        
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date")
        })
        
        return decoder
    }
}

extension Data {
    func decode<T: Decodable>(_ type: T.Type) -> T? {
        return try? JSONDecoder.defaultJSONDecoder.decode(type, from: self)
    }
}

extension KeyedDecodingContainer {
    
    // boolean decode
    func decode(_ type: Bool.Type, key: KeyedDecodingContainer.Key) throws -> Bool {
        //Handle Int self
        if let stringValue = try? decode(String.self, forKey: key) {
            switch stringValue.lowercased() {
//            case "false", "no", "0": return false
            case "true", "yes", "1": return true
            default: return false
//            default: throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: "Expect true/false, yes/no or 0/1 but`\(stringValue)` instead")
            }
        }
        
        //Handle Int value
        else if let intValue = try? decode(Int.self, forKey: key) {
            return (intValue > 0)
        }
        
        //Handle Double value
        else if let doubleValue = try? decode(Double.self, forKey: key) {
            return (doubleValue > 0.0)
        }
        
        else {
            return try decode(Bool.self, forKey: key)
        }
        
    }
    
    // Int decode
    func decode(_ type: Int.Type, key: KeyedDecodingContainer.Key) throws -> Int? {
        if let string = try? decode(String.self, forKey: key), let int = Int(string)  {
            return int
        }
        if let bool = try? decode(Bool.self, forKey: key), let int = (bool ? 1 : 0)  {
            return int
        }
        return try decode(Int.self, forKey: key)
    }
    
    // String decode
    func decode(_ type: String.Type, key: KeyedDecodingContainer.Key) throws -> String? {
        if let int = try? decode(Int.self, forKey: key) {
            return "\(int)"
        }
        if let bool = try? decode(Bool.self, forKey: key) {
            return "\(bool)"
        }
        return try decode(String.self, forKey: key)
    }
}

extension Encodable {
    func deepCopy<T: Codable>() -> T? {
        let data = try? JSONEncoder().encode(self)
        let copy = try? JSONDecoder.defaultJSONDecoder.decode(T.self, from: data ?? Data())
        
        return copy
    }
}

class APIMeta: Codable {
    
    var msg: String?
    var code: Int
    
    enum CodingKeys: String, CodingKey {
        case msg
        case code
    }
}
