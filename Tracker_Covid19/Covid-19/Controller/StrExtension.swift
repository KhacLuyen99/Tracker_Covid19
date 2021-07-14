//
//  StrExtension.swift
//  Covid-19
//
//  Created by Albert Cheng on 2020/8/31.
//  Copyright © 2020 Albert Cheng. All rights reserved.
//

import Foundation

//String  cua Extension => La cho URL(string: xxx) o giưa URL string (S. Korea)
extension String {
    //Ban goc URL String -> tro thanh Valid cua URL String
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    //Ban goc hoac da chinh sua URL String -> Giai ma và chuyen ve ban goc URL String
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
}
