//
//  ProfileViewController.swift
//  Schingen
//
//  Created by Ozan Barış Günaydın on 10.11.2021.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import SDWebImage

/// Controller for the profile of users
final class ProfileViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    private let imageView = UIImageView()
    private let headerView = UIView()
    
    var data = [ProfileViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableViewConfigure()
        signOutFromProfile()
    }
    
    /// Profile table view properties
    private func profileTableViewConfigure() {
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeader()
    }
    
    /// Function for the log out of current user
    private func signOutFromProfile() {
        
        data.append(ProfileViewModel(viewModelType: .info, title: "Name: \(UserDefaults.standard.value(forKey: "name") as? String ?? "Undefined Name")", handler: nil))
        data.append(ProfileViewModel(viewModelType: .info, title: "Email: \(UserDefaults.standard.value(forKey: "email") as? String ?? "Undefined Email")", handler: nil))
        data.append(ProfileViewModel(viewModelType: .logOut, title: "Log Out", handler: { [weak self] in
            
            guard let strongSelf = self else { return }
            
            let actionSheet = UIAlertController(title: "Log Out", message: "If you want to log out from current user please tap the Log Out button.", preferredStyle: .alert)
            actionSheet.addAction(UIAlertAction(title: "Log Out.", style: .destructive, handler: { [weak self] _ in
                guard let strongSelf = self else { return }
                
                UserDefaults.standard.set(nil, forKey: "email")
                UserDefaults.standard.set(nil, forKey: "name")
                
//                Facebook sign out.
                FBSDKLoginKit.LoginManager().logOut()
//                Google sign out.
                GIDSignIn.sharedInstance().signOut()
                
                do {
                    try FirebaseAuth.Auth.auth().signOut()
                    let loginVC = LoginViewController()
                    let navVC = UINavigationController(rootViewController: loginVC)
                    navVC.modalPresentationStyle = .fullScreen
                    strongSelf.present(navVC, animated: true)
                } catch {
                    print("Failed to lof out: \(error.localizedDescription)")
                }
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            strongSelf.present(actionSheet, animated: true)
        }))
    }
    ///  Header of the profile view's table view
    private func createTableHeader() -> UIView? {
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return nil }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let fileName = safeEmail + "_profile_picture.png"
        let path = "images/"+fileName
        
        // MARK: Frame Settings for Views of ProfileVC
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 300))
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = headerView.bounds
        gradientLayer.colors = [UIColor.systemBackground.cgColor, UIColor.systemMint.cgColor, UIColor.systemBackground.cgColor]
        headerView.layer.addSublayer(gradientLayer)
    
        let imageView = UIImageView(frame: CGRect(x: (headerView.width - 300) / 2, y: 0, width: 300, height: 300))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.width / 2
        headerView.addSubview(imageView)
        
        StorageManager.shared.downloadURL(for: path, completion: { result in
            switch result {
            case .success(let url):
                imageView.sd_setImage(with: url, completed: nil)
            case .failure(let error):
                imageView.image = UIImage(systemName: "person.circle")
                print("Failed to get download url: \(error)")
            }
        })
        return headerView
    }
}
// MARK: Profile Table Settings:
/// Profile view tableview apperance settings
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
        let viewModel = data[indexPath.row]
        cell.setUp(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.row].handler?()
    }
}

// MARK: Profile View Cell
///  Simple cell class of the profile view
final class ProfileTableViewCell: UITableViewCell {
    
    static let identifier = "ProfileTableViewCell"
    
    public func setUp(with viewModel: ProfileViewModel) {
        
        self.textLabel?.text = viewModel.title
        
        switch viewModel.viewModelType {
        case .info:
            textLabel?.textAlignment = .center
            selectionStyle = .none
        case .logOut:
            textLabel?.textColor = .red
            textLabel?.textAlignment = .center
        }
    }
}
