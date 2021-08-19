//
//  ViewController.swift
//  TestApp
//
//  Created by Михаил Красильник on 15.08.2021.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    var searchText = "picture"
    
    var images = [CellModel]()
    
    var searchBar = UISearchBar()
    
    private var nextButton = UIButton(type: .system)
    private var backButton = UIButton(type: .system)
    
    var pageNumber = 1
    
    enum Section: Int, CaseIterable {
        case searchedImages
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section,CellModel>?
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Unsplash images"
        createSearchBar()
        fetchImages()
        createCollcetionView()
        createDataSource()
        reloadData()
        
        configureNavigationsButtons()
        
        backButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        searchBar.isHidden = true
    }
    
    private func configureNavigationsButtons() {

        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.addTarget(self, action: #selector(goToNextPage), for: .touchUpInside)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.addTarget(self, action: #selector(goToBackPage), for: .touchUpInside)
        
        view.addSubview(nextButton)
        view.addSubview(backButton)
        
        let quarterWidth = view.bounds.width * 0.25
        let buttomWidth = quarterWidth - 10
        let height: CGFloat = 50
        
        NSLayoutConstraint.activate([
            backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: quarterWidth),
            backButton.widthAnchor.constraint(equalToConstant: buttomWidth),
            backButton.heightAnchor.constraint(equalToConstant: height)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -quarterWidth),
            nextButton.widthAnchor.constraint(equalToConstant: buttomWidth),
            nextButton.heightAnchor.constraint(equalToConstant: height)
        ])
    }

    
    private func fetchImages() {
        images = []
        reloadData()
        
        let url = "https://api.unsplash.com/search/photos?per_page=60&page=\(self.pageNumber)&query=\(self.searchText)"

        DispatchQueue.main.async {
            DataManager.fetchImage(url: url) { results in
                for result in results.results {
                    let image = CellModel(description: result.description,
                                          smallImage: result.urls.small,
                                          fullImage: result.urls.full)
                    self.images.append(image)
                    print(self.images.count)
                    
                }
                self.reloadData()
            }
        }
    }
    
    private func createCollcetionView() {
        
        let layout = createCompositionalLayout()
        let frame = CGRect(x: 0, y: 70, width: view.bounds.width, height: view.bounds.height * 0.8)
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        view.addSubview(collectionView)
        
        
        navigationController?.navigationBar.backgroundColor = .black
        
        let insets = navigationController!.navigationBar.bounds.height
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: insets),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets)
        ])

        collectionView.register(SearchedImageCell.self, forCellWithReuseIdentifier: SearchedImageCell.reuseID)
        
        collectionView.delegate = self
        
    }
    
    private func createSearchBar() {

        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, CellModel>()
        snapShot.appendSections([.searchedImages])
        snapShot.appendItems(images, toSection: .searchedImages)
        dataSource?.apply(snapShot, animatingDifferences: true)
    }
    
    @objc func goToNextPage() {
        pageNumber += 1
        fetchImages()
        backButton.isEnabled = true
    }
    
    @objc func goToBackPage() {
        if pageNumber > 1 {
            pageNumber -= 1
            fetchImages()
        } else {
            backButton.isEnabled = false
        }
    }
}

//MARK: - UISearchBarDelegate, UISearchControllerDelegate
extension MainScreenViewController: UISearchBarDelegate, UISearchControllerDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText = searchText
        fetchImages()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchText = "picture"
        fetchImages()
    }
}

//MARK: - UICollectionViewDelegate
extension MainScreenViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cellModel = dataSource?.itemIdentifier(for: indexPath) else { return }
        guard let section = Section.init(rawValue: indexPath.section) else { return }
        
        switch section {
        
        case .searchedImages:
            
            navigationController?.pushViewController(ImagePresenterVC(cellModel: cellModel), animated: true)
        }
    }
}

//MARK: - createCompositionalLayout
extension MainScreenViewController {
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = Section.init(rawValue: sectionIndex) else {
                fatalError("Unknown kind section")
            }
            
            switch section {
            case .searchedImages:
                return self.createSearchedImagesSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    private func createSearchedImagesSection() -> NSCollectionLayoutSection {
        let sizeItem = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: sizeItem)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(0.1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 4)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
}

//MARK: - createDataSource
extension MainScreenViewController {
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, CellModel>(collectionView: collectionView, cellProvider: { collectionView, indexPath, cellModel in
            
            guard let section = Section.init(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            
            switch section {
            case .searchedImages:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchedImageCell.reuseID, for: indexPath) as! SearchedImageCell
            
                if !self.images.isEmpty {
                    DispatchQueue.main.async {
                        cell.imageVeiw.fetchData(url: self.images[indexPath.item].smallImage)
                    }
                }
                
                return cell
            }
        })
    }
}
