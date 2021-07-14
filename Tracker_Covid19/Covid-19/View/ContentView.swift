//
//  ContentView.swift
//  Covid-19
//
//  Created by Albert Cheng on 2020/4/14.
//  Copyright © 2020 Albert Cheng. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var data = getData()
    
    var body: some View {
        ScrollView {
            VStack {
                if self.data.countries.count != 0 && self.data.data != nil {
                    VStack {
                        HStack(alignment: .top) {
                            VStack(alignment: .center, spacing: 10) {
                                Text("THÔNG TIN MỚI NHẤT：\(getDate(time: self.data.data?.updated ?? 0))")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 10, weight: Font.Weight.regular, design: Font.Design.monospaced))
                                    .foregroundColor(.white)
                                Text("TÌNH HÌNH DỊCH BỆNH TRÊN THẾ GIỚI - COVID 19")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .font(.system(size: 11, weight: Font.Weight.regular, design: Font.Design.monospaced))
                                Text("SỐ NGƯỜI MẮC BỆNH TRÊN THẾ GIỚI")
                                    .fontWeight(.bold)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .font(.system(size: 10, weight: Font.Weight.regular, design: Font.Design.monospaced))
                                Text("\(getValue(data: self.data.data?.cases ?? 0))")
                                    .fontWeight(.bold)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .font(.system(size: 10, weight: Font.Weight.regular, design: Font.Design.monospaced))
                            }
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(20)
                            
                            
                        }
                        .frame(maxWidth:.infinity)
                        .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top))
                        .padding()
                        .padding(.bottom, 60)
                        .background(Color.secondary.opacity(0.7))
                        
                        HStack(spacing: 15) {
                            VStack(alignment: .center, spacing: 15) {
                                Text("Số người tử vong")
                                    .foregroundColor(Color.black)
                                Text(getValue(data: self.data.data?.deaths ?? 0))
                                    .font(.system(size: 20, weight: Font.Weight.regular, design: Font.Design.monospaced))
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                            }
                            .padding(30)
                            .background(Color.white)
                            .cornerRadius(12)
                            
                            VStack(alignment: .center, spacing: 15) {
                                Text("Số người khỏi bệnh")
                                    .foregroundColor(Color.black)
                                Text(getValue(data: self.data.data?.recovered ?? 0))
                                    .font(.system(size: 20, weight: Font.Weight.regular, design: Font.Design.monospaced))
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                            .padding(30)
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                        .offset(y: -60)
                        .padding(.bottom, -60)
                        .zIndex(25)
                        
                        VStack(alignment: .center, spacing: 15) {
                            Text("Số người mắc bệnh")
                                .foregroundColor(Color.black)
                            Text(getValue(data: self.data.data?.active ?? 0))
                                .font(.system(size: 20, weight: Font.Weight.regular, design: Font.Design.monospaced))
                                .fontWeight(.bold)
                                .foregroundColor(.yellow)
                        }
                        .padding(30)
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.top, 15)
                        
                        Button(action: {
                            self.data.data = nil //reset our data
                            self.data.countries.removeAll() //reset the list of countries
                            self.data.updateData() //refresh the data from API
                            
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.title)
                                .foregroundColor(.red)
                        }.padding(.top)
                        //.padding()
                        //.padding(.bottom, 60)
                        //.background(Color.blue.opacity(0.7))
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(self.data.countries, id: \.self) { myID in
                                    cellView(data: myID)
                                }
                            }
                            .padding()
                        }
                        VStack(alignment: .center, spacing: 12) {
                            Button(action: {
                                UIApplication.shared.open(URL(string: "https://tokhaiyte.vn")! as URL, options: [:], completionHandler: nil)
                            }, label: {
                                Text("Khai báo y tế")
                                    .font(.system(size: 15))
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(.white)
                                
                            })
                            .frame(width: 200, height: 50, alignment: .center)
                            .background(Color.orange)
                            .cornerRadius(8)
                            
                        }
                        
                        
                    }
                    HStack(alignment:.bottom) {
                        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                            Text("Hà Nội - Việt Nam")
                                .fontWeight(.bold)
                                .foregroundColor(.white).opacity(0.7)
                                .font(.system(size: 15))
                            
                            Text("Phiên bản mới nhất: 2021/06/21")
                                .fontWeight(.bold)
                                .foregroundColor(.white).opacity(0.7)
                                .font(.system(size: 15))
                        }
                        
                            
                    }
                    .frame(maxWidth: .infinity)
                    //.padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.top))
                    .padding()
                    .padding(.bottom, 10)
                    .background(Color.secondary.opacity(0.7))
                        
                } else {
                    VStack(alignment: .center, spacing: 12) {
                        GeometryReader { geometry in
                            Indicator().frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height)
                        }
                    }
                }
            }.background(Color.black.opacity(0.1).edgesIgnoringSafeArea(.all))
        }.edgesIgnoringSafeArea(.all)
    }
}

func getDate(time: Double) -> String {
       //How to parse the 'updated' params data from API
       let date = Double(time / 1000)
       let format = DateFormatter()
       //set the format of date(Month, Day, Year, Hour, Minute, AM/PM)
       format.dateFormat = "MMM - dd - YYYY hh:mm a"
    return format.string(from: Date(timeIntervalSince1970: TimeInterval(exactly: date)!))
   }

   func getValue(data: Double) -> String {
       let format = NumberFormatter()
       format.numberStyle = .decimal
       format.groupingSeparator = ","
       format.groupingSize = 3
    return format.string(for: data)!
   }

struct cellView: View {
    //cellView is the bottom view, which show the information from DetailsInfo Codable
    var data: DetailsInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Quốc gia：\(data.country)")
                .fontWeight(.bold)
            
            HStack(spacing: 15) {
            
                VStack(alignment: .center, spacing: 12) {
                    Text("Số người mắc bệnh")
                    Text(getValue(data: data.cases))
                        .foregroundColor(.orange)
                }
                
                Spacer()
                
                
                
                VStack(alignment: .center, spacing: 12) {
                    
                    VStack(alignment: .center, spacing: 10) {
                        Text("Số người tử vong")
                        Text(getValue(data: data.deaths))
                            .foregroundColor(.red)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .center, spacing: 10) {
                        Text("Số người khỏi bệnh")
                        Text(getValue(data: data.recovered))
                            .foregroundColor(.green)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .center, spacing: 10) {
                        Text("Bệnh nặng")
                        Text(getValue(data: data.critical))
                            .foregroundColor(.yellow)
                    }
                }
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(20)
    }
}


struct GlobalInfo: Decodable {
    var cases: Double
    var deaths: Double
    var recovered: Double
    var critical: Double
    var active: Double
    var updated: Double
}

struct DetailsInfo: Decodable, Hashable {
    var country: String
    var cases: Double
    var deaths: Double
    var recovered: Double
    var critical: Double
}






