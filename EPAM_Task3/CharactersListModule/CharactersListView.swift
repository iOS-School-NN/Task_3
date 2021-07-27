import UIKit

protocol CharactersListViewProtocol: AnyObject {
    func updateCharacterList()
}

final class CharactersListView: UITableViewController, CharactersListViewProtocol {
    var presenter: CharactersListPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = view.bounds
        view.backgroundColor = .white
        navigationItem.title = "Characters list"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // Обновление информации о персонажах (вызывается из презентера)
    func updateCharacterList() {
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height * 0.15
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.characters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = presenter.characters[indexPath.item].name
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.layer.cornerRadius = UIScreen.main.bounds.height * 0.03
        cell.imageView?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        cell.imageView?.clipsToBounds = true

        // Загрузка изображения для ячейки
        presenter.fetchImage(urlString: presenter.characters[indexPath.item].imageURL) { image in
            cell.imageView?.image = image
            cell.layoutSubviews()
        }

        return  cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.toCharacterDetails(id: indexPath.item)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y

        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            presenter.fetchNewPage()
        }
    }
}
