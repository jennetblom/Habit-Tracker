////
////  CalendarView.swift
////  Habit Tracker
////
////  Created by Jennet on 2024-04-27.
////
//
//
//import SwiftUI
//import UIKit
//
//struct CalendarView: UIViewRepresentable {
//    typealias UIViewType = UICollectionView
//
//    func makeUIView(context: Context) -> UICollectionView {
//        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
//            // Define your calendar layout here
//            // This is a basic example, you can customize it according to your needs
//            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//            let item = NSCollectionLayoutItem(layoutSize: itemSize)
//            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.1))
//            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 7)
//            let section = NSCollectionLayoutSection(group: group)
//            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
//            return section
//        }
//
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .clear
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//        collectionView.dataSource = context.coordinator
//        return collectionView
//    }
//
//    func updateUIView(_ uiView: UICollectionView, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator()
//    }
//
//    class Coordinator: NSObject, UICollectionViewDataSource {
//        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//            // Return the number of items in the section (e.g., number of days in the month)
//            return 31 // Change this to the actual number of days in the month
//        }
//
//        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//            // Customize the cell appearance here
//            cell.backgroundColor = .lightGray
//            return cell
//        }
//    }
//}
//#Preview {
//    CalendarView()
//}
