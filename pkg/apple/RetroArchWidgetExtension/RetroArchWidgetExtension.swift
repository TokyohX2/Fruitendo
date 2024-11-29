//
//  FruitendoWidgetExtension.swift
//  FruitendoWidgetExtension
//
//  Created by Yoshi Sugawara on 10/10/22.
//  Copyright © 2022 Fruitendo. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct DummyProvider: TimelineProvider {
   func getSnapshot(in context: Context, completion: @escaping (DummyEntry) -> Void) {
      completion(DummyEntry())
   }

   func getTimeline(in context: Context, completion: @escaping (Timeline<DummyEntry>) -> Void) {
      completion(Timeline(entries: [DummyEntry()], policy: .never))
   }
   
   func placeholder(in context: Context) -> DummyEntry {
      DummyEntry()
   }
}

struct DummyEntry: TimelineEntry {
   let date = Date()
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct FruitendoImageView : View {
    var body: some View {
#if swift(>=5.9)
       if #available(iOSApplicationExtension 17.0, *) {
          ZStack {
             AccessoryWidgetBackground()
             Image("logo")
          }
          .containerBackground(for: .widget) {}
       } else {
          ZStack {
             AccessoryWidgetBackground()
             Image("logo")
          }
       }
#else
       ZStack {
          AccessoryWidgetBackground()
          Image("logo")
       }
#endif
    }
}

@main
struct FruitendoWidgetExtension: Widget {
    let kind: String = "FruitendoWidgetExtension"

    var body: some WidgetConfiguration {
       if #available(iOSApplicationExtension 16.0, *) {
          return StaticConfiguration(kind: kind, provider: DummyProvider()) { _ in
             FruitendoImageView()
          }
          .configurationDisplayName("Icon")
          .description("Launch Fruitendo.")
          .supportedFamilies([.accessoryCircular])
       } else {
          return EmptyWidgetConfiguration()
       }
    }
}

struct FruitendoWidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
       FruitendoImageView()           .previewContext(WidgetPreviewContext(family: .accessoryCircular))
    }
}
