//
//  Category.swift
//  TreeTableViewDemo
//
//  Created by Anton Lisovoy on 21/07/2019.
//  Copyright © 2019 Anton Lisovoy. All rights reserved.
//

import Foundation
import UIKit

struct Category {
  let name: String
  let image: UIImage
  let subcategories: [Category]
}
