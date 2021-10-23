// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public enum MediaType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case photo
  case video
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "Photo": self = .photo
      case "Video": self = .video
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .photo: return "Photo"
      case .video: return "Video"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: MediaType, rhs: MediaType) -> Bool {
    switch (lhs, rhs) {
      case (.photo, .photo): return true
      case (.video, .video): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [MediaType] {
    return [
      .photo,
      .video,
    ]
  }
}

public final class InitialSetupQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query InitialSetup {
      siteInfo {
        __typename
        initialSetup
      }
    }
    """

  public let operationName: String = "InitialSetup"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("siteInfo", type: .nonNull(.object(SiteInfo.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(siteInfo: SiteInfo) {
      self.init(unsafeResultMap: ["__typename": "Query", "siteInfo": siteInfo.resultMap])
    }

    public var siteInfo: SiteInfo {
      get {
        return SiteInfo(unsafeResultMap: resultMap["siteInfo"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "siteInfo")
      }
    }

    public struct SiteInfo: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["SiteInfo"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("initialSetup", type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(initialSetup: Bool) {
        self.init(unsafeResultMap: ["__typename": "SiteInfo", "initialSetup": initialSetup])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Whether or not the initial setup wizard should be shown
      public var initialSetup: Bool {
        get {
          return resultMap["initialSetup"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "initialSetup")
        }
      }
    }
  }
}

public final class AlbumViewSingleAlbumQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query albumViewSingleAlbum($albumID: ID!) {
      album(id: $albumID) {
        __typename
        id
        title
        media {
          __typename
          id
          thumbnail {
            __typename
            url
            width
            height
          }
          favorite
        }
        subAlbums {
          __typename
          id
          title
          thumbnail {
            __typename
            thumbnail {
              __typename
              url
            }
          }
        }
      }
    }
    """

  public let operationName: String = "albumViewSingleAlbum"

  public var albumID: GraphQLID

  public init(albumID: GraphQLID) {
    self.albumID = albumID
  }

  public var variables: GraphQLMap? {
    return ["albumID": albumID]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("album", arguments: ["id": GraphQLVariable("albumID")], type: .nonNull(.object(Album.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(album: Album) {
      self.init(unsafeResultMap: ["__typename": "Query", "album": album.resultMap])
    }

    /// Get album by id, user must own the album or be admin
    /// If valid tokenCredentials are provided, the album may be retrived without further authentication
    public var album: Album {
      get {
        return Album(unsafeResultMap: resultMap["album"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "album")
      }
    }

    public struct Album: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Album"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("media", type: .nonNull(.list(.nonNull(.object(Medium.selections))))),
          GraphQLField("subAlbums", type: .nonNull(.list(.nonNull(.object(SubAlbum.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, title: String, media: [Medium], subAlbums: [SubAlbum]) {
        self.init(unsafeResultMap: ["__typename": "Album", "id": id, "title": title, "media": media.map { (value: Medium) -> ResultMap in value.resultMap }, "subAlbums": subAlbums.map { (value: SubAlbum) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String {
        get {
          return resultMap["title"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "title")
        }
      }

      /// The media inside this album
      public var media: [Medium] {
        get {
          return (resultMap["media"] as! [ResultMap]).map { (value: ResultMap) -> Medium in Medium(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Medium) -> ResultMap in value.resultMap }, forKey: "media")
        }
      }

      /// The albums contained in this album
      public var subAlbums: [SubAlbum] {
        get {
          return (resultMap["subAlbums"] as! [ResultMap]).map { (value: ResultMap) -> SubAlbum in SubAlbum(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: SubAlbum) -> ResultMap in value.resultMap }, forKey: "subAlbums")
        }
      }

      public struct Medium: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Media"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("thumbnail", type: .object(Thumbnail.selections)),
            GraphQLField("favorite", type: .nonNull(.scalar(Bool.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, thumbnail: Thumbnail? = nil, favorite: Bool) {
          self.init(unsafeResultMap: ["__typename": "Media", "id": id, "thumbnail": thumbnail.flatMap { (value: Thumbnail) -> ResultMap in value.resultMap }, "favorite": favorite])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        /// URL to display the media in a smaller resolution
        public var thumbnail: Thumbnail? {
          get {
            return (resultMap["thumbnail"] as? ResultMap).flatMap { Thumbnail(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "thumbnail")
          }
        }

        public var favorite: Bool {
          get {
            return resultMap["favorite"]! as! Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "favorite")
          }
        }

        public struct Thumbnail: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["MediaURL"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("url", type: .nonNull(.scalar(String.self))),
              GraphQLField("width", type: .nonNull(.scalar(Int.self))),
              GraphQLField("height", type: .nonNull(.scalar(Int.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(url: String, width: Int, height: Int) {
            self.init(unsafeResultMap: ["__typename": "MediaURL", "url": url, "width": width, "height": height])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// URL for previewing the image
          public var url: String {
            get {
              return resultMap["url"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "url")
            }
          }

          /// Width of the image in pixels
          public var width: Int {
            get {
              return resultMap["width"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "width")
            }
          }

          /// Height of the image in pixels
          public var height: Int {
            get {
              return resultMap["height"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "height")
            }
          }
        }
      }

      public struct SubAlbum: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Album"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("title", type: .nonNull(.scalar(String.self))),
            GraphQLField("thumbnail", type: .object(Thumbnail.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, title: String, thumbnail: Thumbnail? = nil) {
          self.init(unsafeResultMap: ["__typename": "Album", "id": id, "title": title, "thumbnail": thumbnail.flatMap { (value: Thumbnail) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var title: String {
          get {
            return resultMap["title"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "title")
          }
        }

        /// An image in this album used for previewing this album
        public var thumbnail: Thumbnail? {
          get {
            return (resultMap["thumbnail"] as? ResultMap).flatMap { Thumbnail(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "thumbnail")
          }
        }

        public struct Thumbnail: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Media"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("thumbnail", type: .object(Thumbnail.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(thumbnail: Thumbnail? = nil) {
            self.init(unsafeResultMap: ["__typename": "Media", "thumbnail": thumbnail.flatMap { (value: Thumbnail) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// URL to display the media in a smaller resolution
          public var thumbnail: Thumbnail? {
            get {
              return (resultMap["thumbnail"] as? ResultMap).flatMap { Thumbnail(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "thumbnail")
            }
          }

          public struct Thumbnail: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["MediaURL"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("url", type: .nonNull(.scalar(String.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(url: String) {
              self.init(unsafeResultMap: ["__typename": "MediaURL", "url": url])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// URL for previewing the image
            public var url: String {
              get {
                return resultMap["url"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "url")
              }
            }
          }
        }
      }
    }
  }
}

public final class MyAlbumsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query myAlbums {
      myAlbums(order: {order_by: "title"}, onlyRoot: true, showEmpty: true) {
        __typename
        id
        title
        thumbnail {
          __typename
          thumbnail {
            __typename
            url
          }
        }
      }
    }
    """

  public let operationName: String = "myAlbums"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("myAlbums", arguments: ["order": ["order_by": "title"], "onlyRoot": true, "showEmpty": true], type: .nonNull(.list(.nonNull(.object(MyAlbum.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(myAlbums: [MyAlbum]) {
      self.init(unsafeResultMap: ["__typename": "Query", "myAlbums": myAlbums.map { (value: MyAlbum) -> ResultMap in value.resultMap }])
    }

    /// List of albums owned by the logged in user.
    public var myAlbums: [MyAlbum] {
      get {
        return (resultMap["myAlbums"] as! [ResultMap]).map { (value: ResultMap) -> MyAlbum in MyAlbum(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: MyAlbum) -> ResultMap in value.resultMap }, forKey: "myAlbums")
      }
    }

    public struct MyAlbum: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Album"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("thumbnail", type: .object(Thumbnail.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, title: String, thumbnail: Thumbnail? = nil) {
        self.init(unsafeResultMap: ["__typename": "Album", "id": id, "title": title, "thumbnail": thumbnail.flatMap { (value: Thumbnail) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String {
        get {
          return resultMap["title"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "title")
        }
      }

      /// An image in this album used for previewing this album
      public var thumbnail: Thumbnail? {
        get {
          return (resultMap["thumbnail"] as? ResultMap).flatMap { Thumbnail(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "thumbnail")
        }
      }

      public struct Thumbnail: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Media"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("thumbnail", type: .object(Thumbnail.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(thumbnail: Thumbnail? = nil) {
          self.init(unsafeResultMap: ["__typename": "Media", "thumbnail": thumbnail.flatMap { (value: Thumbnail) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// URL to display the media in a smaller resolution
        public var thumbnail: Thumbnail? {
          get {
            return (resultMap["thumbnail"] as? ResultMap).flatMap { Thumbnail(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "thumbnail")
          }
        }

        public struct Thumbnail: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["MediaURL"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("url", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(url: String) {
            self.init(unsafeResultMap: ["__typename": "MediaURL", "url": url])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// URL for previewing the image
          public var url: String {
            get {
              return resultMap["url"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "url")
            }
          }
        }
      }
    }
  }
}

public final class MyFacesThumbnailsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query myFacesThumbnails {
      myFaceGroups {
        __typename
        id
        label
        imageFaceCount
        imageFaces(paginate: {limit: 1}) {
          __typename
          id
          rectangle {
            __typename
            minX
            maxX
            minY
            maxY
          }
          media {
            __typename
            id
            thumbnail {
              __typename
              url
              width
              height
            }
          }
        }
      }
    }
    """

  public let operationName: String = "myFacesThumbnails"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("myFaceGroups", type: .nonNull(.list(.nonNull(.object(MyFaceGroup.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(myFaceGroups: [MyFaceGroup]) {
      self.init(unsafeResultMap: ["__typename": "Query", "myFaceGroups": myFaceGroups.map { (value: MyFaceGroup) -> ResultMap in value.resultMap }])
    }

    public var myFaceGroups: [MyFaceGroup] {
      get {
        return (resultMap["myFaceGroups"] as! [ResultMap]).map { (value: ResultMap) -> MyFaceGroup in MyFaceGroup(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: MyFaceGroup) -> ResultMap in value.resultMap }, forKey: "myFaceGroups")
      }
    }

    public struct MyFaceGroup: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["FaceGroup"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("label", type: .scalar(String.self)),
          GraphQLField("imageFaceCount", type: .nonNull(.scalar(Int.self))),
          GraphQLField("imageFaces", arguments: ["paginate": ["limit": 1]], type: .nonNull(.list(.nonNull(.object(ImageFace.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, label: String? = nil, imageFaceCount: Int, imageFaces: [ImageFace]) {
        self.init(unsafeResultMap: ["__typename": "FaceGroup", "id": id, "label": label, "imageFaceCount": imageFaceCount, "imageFaces": imageFaces.map { (value: ImageFace) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var label: String? {
        get {
          return resultMap["label"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "label")
        }
      }

      public var imageFaceCount: Int {
        get {
          return resultMap["imageFaceCount"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "imageFaceCount")
        }
      }

      public var imageFaces: [ImageFace] {
        get {
          return (resultMap["imageFaces"] as! [ResultMap]).map { (value: ResultMap) -> ImageFace in ImageFace(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: ImageFace) -> ResultMap in value.resultMap }, forKey: "imageFaces")
        }
      }

      public struct ImageFace: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ImageFace"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("rectangle", type: .nonNull(.object(Rectangle.selections))),
            GraphQLField("media", type: .nonNull(.object(Medium.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, rectangle: Rectangle, media: Medium) {
          self.init(unsafeResultMap: ["__typename": "ImageFace", "id": id, "rectangle": rectangle.resultMap, "media": media.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var rectangle: Rectangle {
          get {
            return Rectangle(unsafeResultMap: resultMap["rectangle"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "rectangle")
          }
        }

        public var media: Medium {
          get {
            return Medium(unsafeResultMap: resultMap["media"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "media")
          }
        }

        public struct Rectangle: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["FaceRectangle"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("minX", type: .nonNull(.scalar(Double.self))),
              GraphQLField("maxX", type: .nonNull(.scalar(Double.self))),
              GraphQLField("minY", type: .nonNull(.scalar(Double.self))),
              GraphQLField("maxY", type: .nonNull(.scalar(Double.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(minX: Double, maxX: Double, minY: Double, maxY: Double) {
            self.init(unsafeResultMap: ["__typename": "FaceRectangle", "minX": minX, "maxX": maxX, "minY": minY, "maxY": maxY])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var minX: Double {
            get {
              return resultMap["minX"]! as! Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "minX")
            }
          }

          public var maxX: Double {
            get {
              return resultMap["maxX"]! as! Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "maxX")
            }
          }

          public var minY: Double {
            get {
              return resultMap["minY"]! as! Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "minY")
            }
          }

          public var maxY: Double {
            get {
              return resultMap["maxY"]! as! Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "maxY")
            }
          }
        }

        public struct Medium: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Media"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("thumbnail", type: .object(Thumbnail.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, thumbnail: Thumbnail? = nil) {
            self.init(unsafeResultMap: ["__typename": "Media", "id": id, "thumbnail": thumbnail.flatMap { (value: Thumbnail) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return resultMap["id"]! as! GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          /// URL to display the media in a smaller resolution
          public var thumbnail: Thumbnail? {
            get {
              return (resultMap["thumbnail"] as? ResultMap).flatMap { Thumbnail(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "thumbnail")
            }
          }

          public struct Thumbnail: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["MediaURL"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("url", type: .nonNull(.scalar(String.self))),
                GraphQLField("width", type: .nonNull(.scalar(Int.self))),
                GraphQLField("height", type: .nonNull(.scalar(Int.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(url: String, width: Int, height: Int) {
              self.init(unsafeResultMap: ["__typename": "MediaURL", "url": url, "width": width, "height": height])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// URL for previewing the image
            public var url: String {
              get {
                return resultMap["url"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "url")
              }
            }

            /// Width of the image in pixels
            public var width: Int {
              get {
                return resultMap["width"]! as! Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "width")
              }
            }

            /// Height of the image in pixels
            public var height: Int {
              get {
                return resultMap["height"]! as! Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "height")
              }
            }
          }
        }
      }
    }
  }
}

public final class SinglePersonQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query singlePerson($faceGroupID: ID!) {
      faceGroup(id: $faceGroupID) {
        __typename
        id
        label
        imageFaces {
          __typename
          id
          media {
            __typename
            id
            favorite
            thumbnail {
              __typename
              url
              width
              height
            }
          }
        }
      }
    }
    """

  public let operationName: String = "singlePerson"

  public var faceGroupID: GraphQLID

  public init(faceGroupID: GraphQLID) {
    self.faceGroupID = faceGroupID
  }

  public var variables: GraphQLMap? {
    return ["faceGroupID": faceGroupID]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("faceGroup", arguments: ["id": GraphQLVariable("faceGroupID")], type: .nonNull(.object(FaceGroup.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(faceGroup: FaceGroup) {
      self.init(unsafeResultMap: ["__typename": "Query", "faceGroup": faceGroup.resultMap])
    }

    public var faceGroup: FaceGroup {
      get {
        return FaceGroup(unsafeResultMap: resultMap["faceGroup"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "faceGroup")
      }
    }

    public struct FaceGroup: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["FaceGroup"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("label", type: .scalar(String.self)),
          GraphQLField("imageFaces", type: .nonNull(.list(.nonNull(.object(ImageFace.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, label: String? = nil, imageFaces: [ImageFace]) {
        self.init(unsafeResultMap: ["__typename": "FaceGroup", "id": id, "label": label, "imageFaces": imageFaces.map { (value: ImageFace) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var label: String? {
        get {
          return resultMap["label"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "label")
        }
      }

      public var imageFaces: [ImageFace] {
        get {
          return (resultMap["imageFaces"] as! [ResultMap]).map { (value: ResultMap) -> ImageFace in ImageFace(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: ImageFace) -> ResultMap in value.resultMap }, forKey: "imageFaces")
        }
      }

      public struct ImageFace: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ImageFace"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("media", type: .nonNull(.object(Medium.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, media: Medium) {
          self.init(unsafeResultMap: ["__typename": "ImageFace", "id": id, "media": media.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var media: Medium {
          get {
            return Medium(unsafeResultMap: resultMap["media"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "media")
          }
        }

        public struct Medium: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Media"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("favorite", type: .nonNull(.scalar(Bool.self))),
              GraphQLField("thumbnail", type: .object(Thumbnail.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, favorite: Bool, thumbnail: Thumbnail? = nil) {
            self.init(unsafeResultMap: ["__typename": "Media", "id": id, "favorite": favorite, "thumbnail": thumbnail.flatMap { (value: Thumbnail) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return resultMap["id"]! as! GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          public var favorite: Bool {
            get {
              return resultMap["favorite"]! as! Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "favorite")
            }
          }

          /// URL to display the media in a smaller resolution
          public var thumbnail: Thumbnail? {
            get {
              return (resultMap["thumbnail"] as? ResultMap).flatMap { Thumbnail(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "thumbnail")
            }
          }

          public struct Thumbnail: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["MediaURL"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("url", type: .nonNull(.scalar(String.self))),
                GraphQLField("width", type: .nonNull(.scalar(Int.self))),
                GraphQLField("height", type: .nonNull(.scalar(Int.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(url: String, width: Int, height: Int) {
              self.init(unsafeResultMap: ["__typename": "MediaURL", "url": url, "width": width, "height": height])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// URL for previewing the image
            public var url: String {
              get {
                return resultMap["url"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "url")
              }
            }

            /// Width of the image in pixels
            public var width: Int {
              get {
                return resultMap["width"]! as! Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "width")
              }
            }

            /// Height of the image in pixels
            public var height: Int {
              get {
                return resultMap["height"]! as! Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "height")
              }
            }
          }
        }
      }
    }
  }
}

public final class MediaGeoJsonQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query mediaGeoJson {
      myMediaGeoJson
    }
    """

  public let operationName: String = "mediaGeoJson"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("myMediaGeoJson", type: .nonNull(.scalar(`Any`.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(myMediaGeoJson: `Any`) {
      self.init(unsafeResultMap: ["__typename": "Query", "myMediaGeoJson": myMediaGeoJson])
    }

    /// Get media owned by the logged in user, returned in GeoJson format
    public var myMediaGeoJson: `Any` {
      get {
        return resultMap["myMediaGeoJson"]! as! `Any`
      }
      set {
        resultMap.updateValue(newValue, forKey: "myMediaGeoJson")
      }
    }
  }
}

public final class PlacesClusterDetailsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query placesClusterDetails($ids: [ID!]!) {
      mediaList(ids: $ids) {
        __typename
        id
        thumbnail {
          __typename
          url
          width
          height
        }
        favorite
      }
    }
    """

  public let operationName: String = "placesClusterDetails"

  public var ids: [GraphQLID]

  public init(ids: [GraphQLID]) {
    self.ids = ids
  }

  public var variables: GraphQLMap? {
    return ["ids": ids]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("mediaList", arguments: ["ids": GraphQLVariable("ids")], type: .nonNull(.list(.nonNull(.object(MediaList.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(mediaList: [MediaList]) {
      self.init(unsafeResultMap: ["__typename": "Query", "mediaList": mediaList.map { (value: MediaList) -> ResultMap in value.resultMap }])
    }

    /// Get a list of media by their ids, user must own the media or be admin
    public var mediaList: [MediaList] {
      get {
        return (resultMap["mediaList"] as! [ResultMap]).map { (value: ResultMap) -> MediaList in MediaList(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: MediaList) -> ResultMap in value.resultMap }, forKey: "mediaList")
      }
    }

    public struct MediaList: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Media"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("thumbnail", type: .object(Thumbnail.selections)),
          GraphQLField("favorite", type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, thumbnail: Thumbnail? = nil, favorite: Bool) {
        self.init(unsafeResultMap: ["__typename": "Media", "id": id, "thumbnail": thumbnail.flatMap { (value: Thumbnail) -> ResultMap in value.resultMap }, "favorite": favorite])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      /// URL to display the media in a smaller resolution
      public var thumbnail: Thumbnail? {
        get {
          return (resultMap["thumbnail"] as? ResultMap).flatMap { Thumbnail(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "thumbnail")
        }
      }

      public var favorite: Bool {
        get {
          return resultMap["favorite"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "favorite")
        }
      }

      public struct Thumbnail: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["MediaURL"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("url", type: .nonNull(.scalar(String.self))),
            GraphQLField("width", type: .nonNull(.scalar(Int.self))),
            GraphQLField("height", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(url: String, width: Int, height: Int) {
          self.init(unsafeResultMap: ["__typename": "MediaURL", "url": url, "width": width, "height": height])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// URL for previewing the image
        public var url: String {
          get {
            return resultMap["url"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "url")
          }
        }

        /// Width of the image in pixels
        public var width: Int {
          get {
            return resultMap["width"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "width")
          }
        }

        /// Height of the image in pixels
        public var height: Int {
          get {
            return resultMap["height"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "height")
          }
        }
      }
    }
  }
}

public final class TimelineQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query timeline($limit: Int!, $offset: Int!) {
      myTimeline(paginate: {limit: $limit, offset: $offset}) {
        __typename
        id
        date
        thumbnail {
          __typename
          url
          width
          height
        }
        favorite
        album {
          __typename
          id
          title
        }
      }
    }
    """

  public let operationName: String = "timeline"

  public var limit: Int
  public var offset: Int

  public init(limit: Int, offset: Int) {
    self.limit = limit
    self.offset = offset
  }

  public var variables: GraphQLMap? {
    return ["limit": limit, "offset": offset]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("myTimeline", arguments: ["paginate": ["limit": GraphQLVariable("limit"), "offset": GraphQLVariable("offset")]], type: .nonNull(.list(.nonNull(.object(MyTimeline.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(myTimeline: [MyTimeline]) {
      self.init(unsafeResultMap: ["__typename": "Query", "myTimeline": myTimeline.map { (value: MyTimeline) -> ResultMap in value.resultMap }])
    }

    /// Get a list of media, ordered first by day, then by album if multiple media was found for the same day.
    public var myTimeline: [MyTimeline] {
      get {
        return (resultMap["myTimeline"] as! [ResultMap]).map { (value: ResultMap) -> MyTimeline in MyTimeline(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: MyTimeline) -> ResultMap in value.resultMap }, forKey: "myTimeline")
      }
    }

    public struct MyTimeline: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Media"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("date", type: .nonNull(.scalar(Time.self))),
          GraphQLField("thumbnail", type: .object(Thumbnail.selections)),
          GraphQLField("favorite", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("album", type: .nonNull(.object(Album.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, date: Time, thumbnail: Thumbnail? = nil, favorite: Bool, album: Album) {
        self.init(unsafeResultMap: ["__typename": "Media", "id": id, "date": date, "thumbnail": thumbnail.flatMap { (value: Thumbnail) -> ResultMap in value.resultMap }, "favorite": favorite, "album": album.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      /// The date the image was shot or the date it was imported as a fallback
      public var date: Time {
        get {
          return resultMap["date"]! as! Time
        }
        set {
          resultMap.updateValue(newValue, forKey: "date")
        }
      }

      /// URL to display the media in a smaller resolution
      public var thumbnail: Thumbnail? {
        get {
          return (resultMap["thumbnail"] as? ResultMap).flatMap { Thumbnail(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "thumbnail")
        }
      }

      public var favorite: Bool {
        get {
          return resultMap["favorite"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "favorite")
        }
      }

      /// The album that holds the media
      public var album: Album {
        get {
          return Album(unsafeResultMap: resultMap["album"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "album")
        }
      }

      public struct Thumbnail: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["MediaURL"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("url", type: .nonNull(.scalar(String.self))),
            GraphQLField("width", type: .nonNull(.scalar(Int.self))),
            GraphQLField("height", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(url: String, width: Int, height: Int) {
          self.init(unsafeResultMap: ["__typename": "MediaURL", "url": url, "width": width, "height": height])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// URL for previewing the image
        public var url: String {
          get {
            return resultMap["url"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "url")
          }
        }

        /// Width of the image in pixels
        public var width: Int {
          get {
            return resultMap["width"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "width")
          }
        }

        /// Height of the image in pixels
        public var height: Int {
          get {
            return resultMap["height"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "height")
          }
        }
      }

      public struct Album: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Album"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("title", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, title: String) {
          self.init(unsafeResultMap: ["__typename": "Album", "id": id, "title": title])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var title: String {
          get {
            return resultMap["title"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "title")
          }
        }
      }
    }
  }
}

public final class AuthorizeUserMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation AuthorizeUser($username: String!, $password: String!) {
      authorizeUser(username: $username, password: $password) {
        __typename
        success
        status
        token
      }
    }
    """

  public let operationName: String = "AuthorizeUser"

  public var username: String
  public var password: String

  public init(username: String, password: String) {
    self.username = username
    self.password = password
  }

  public var variables: GraphQLMap? {
    return ["username": username, "password": password]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("authorizeUser", arguments: ["username": GraphQLVariable("username"), "password": GraphQLVariable("password")], type: .nonNull(.object(AuthorizeUser.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(authorizeUser: AuthorizeUser) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "authorizeUser": authorizeUser.resultMap])
    }

    public var authorizeUser: AuthorizeUser {
      get {
        return AuthorizeUser(unsafeResultMap: resultMap["authorizeUser"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "authorizeUser")
      }
    }

    public struct AuthorizeUser: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["AuthorizeResult"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("success", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("status", type: .nonNull(.scalar(String.self))),
          GraphQLField("token", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(success: Bool, status: String, token: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "AuthorizeResult", "success": success, "status": status, "token": token])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var success: Bool {
        get {
          return resultMap["success"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "success")
        }
      }

      public var status: String {
        get {
          return resultMap["status"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "status")
        }
      }

      public var token: String? {
        get {
          return resultMap["token"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "token")
        }
      }
    }
  }
}

public final class MediaDetailsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query mediaDetails($mediaID: ID!) {
      media(id: $mediaID) {
        __typename
        id
        title
        thumbnail {
          __typename
          url
          width
          height
        }
        exif {
          __typename
          camera
          maker
          lens
          dateShot
          exposure
          aperture
          iso
          focalLength
          flash
          exposureProgram
        }
        type
        shares {
          __typename
          id
          token
        }
        downloads {
          __typename
          title
          mediaUrl {
            __typename
            url
            width
            height
            fileSize
          }
        }
      }
    }
    """

  public let operationName: String = "mediaDetails"

  public var mediaID: GraphQLID

  public init(mediaID: GraphQLID) {
    self.mediaID = mediaID
  }

  public var variables: GraphQLMap? {
    return ["mediaID": mediaID]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("media", arguments: ["id": GraphQLVariable("mediaID")], type: .nonNull(.object(Medium.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(media: Medium) {
      self.init(unsafeResultMap: ["__typename": "Query", "media": media.resultMap])
    }

    /// Get media by id, user must own the media or be admin.
    /// If valid tokenCredentials are provided, the media may be retrived without further authentication
    public var media: Medium {
      get {
        return Medium(unsafeResultMap: resultMap["media"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "media")
      }
    }

    public struct Medium: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Media"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("thumbnail", type: .object(Thumbnail.selections)),
          GraphQLField("exif", type: .object(Exif.selections)),
          GraphQLField("type", type: .nonNull(.scalar(MediaType.self))),
          GraphQLField("shares", type: .nonNull(.list(.nonNull(.object(Share.selections))))),
          GraphQLField("downloads", type: .nonNull(.list(.nonNull(.object(Download.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, title: String, thumbnail: Thumbnail? = nil, exif: Exif? = nil, type: MediaType, shares: [Share], downloads: [Download]) {
        self.init(unsafeResultMap: ["__typename": "Media", "id": id, "title": title, "thumbnail": thumbnail.flatMap { (value: Thumbnail) -> ResultMap in value.resultMap }, "exif": exif.flatMap { (value: Exif) -> ResultMap in value.resultMap }, "type": type, "shares": shares.map { (value: Share) -> ResultMap in value.resultMap }, "downloads": downloads.map { (value: Download) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String {
        get {
          return resultMap["title"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "title")
        }
      }

      /// URL to display the media in a smaller resolution
      public var thumbnail: Thumbnail? {
        get {
          return (resultMap["thumbnail"] as? ResultMap).flatMap { Thumbnail(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "thumbnail")
        }
      }

      public var exif: Exif? {
        get {
          return (resultMap["exif"] as? ResultMap).flatMap { Exif(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "exif")
        }
      }

      public var type: MediaType {
        get {
          return resultMap["type"]! as! MediaType
        }
        set {
          resultMap.updateValue(newValue, forKey: "type")
        }
      }

      public var shares: [Share] {
        get {
          return (resultMap["shares"] as! [ResultMap]).map { (value: ResultMap) -> Share in Share(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Share) -> ResultMap in value.resultMap }, forKey: "shares")
        }
      }

      public var downloads: [Download] {
        get {
          return (resultMap["downloads"] as! [ResultMap]).map { (value: ResultMap) -> Download in Download(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Download) -> ResultMap in value.resultMap }, forKey: "downloads")
        }
      }

      public struct Thumbnail: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["MediaURL"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("url", type: .nonNull(.scalar(String.self))),
            GraphQLField("width", type: .nonNull(.scalar(Int.self))),
            GraphQLField("height", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(url: String, width: Int, height: Int) {
          self.init(unsafeResultMap: ["__typename": "MediaURL", "url": url, "width": width, "height": height])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// URL for previewing the image
        public var url: String {
          get {
            return resultMap["url"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "url")
          }
        }

        /// Width of the image in pixels
        public var width: Int {
          get {
            return resultMap["width"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "width")
          }
        }

        /// Height of the image in pixels
        public var height: Int {
          get {
            return resultMap["height"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "height")
          }
        }
      }

      public struct Exif: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["MediaEXIF"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("camera", type: .scalar(String.self)),
            GraphQLField("maker", type: .scalar(String.self)),
            GraphQLField("lens", type: .scalar(String.self)),
            GraphQLField("dateShot", type: .scalar(Time.self)),
            GraphQLField("exposure", type: .scalar(Double.self)),
            GraphQLField("aperture", type: .scalar(Double.self)),
            GraphQLField("iso", type: .scalar(Int.self)),
            GraphQLField("focalLength", type: .scalar(Double.self)),
            GraphQLField("flash", type: .scalar(Int.self)),
            GraphQLField("exposureProgram", type: .scalar(Int.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(camera: String? = nil, maker: String? = nil, lens: String? = nil, dateShot: Time? = nil, exposure: Double? = nil, aperture: Double? = nil, iso: Int? = nil, focalLength: Double? = nil, flash: Int? = nil, exposureProgram: Int? = nil) {
          self.init(unsafeResultMap: ["__typename": "MediaEXIF", "camera": camera, "maker": maker, "lens": lens, "dateShot": dateShot, "exposure": exposure, "aperture": aperture, "iso": iso, "focalLength": focalLength, "flash": flash, "exposureProgram": exposureProgram])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The model name of the camera
        public var camera: String? {
          get {
            return resultMap["camera"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "camera")
          }
        }

        /// The maker of the camera
        public var maker: String? {
          get {
            return resultMap["maker"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "maker")
          }
        }

        /// The name of the lens
        public var lens: String? {
          get {
            return resultMap["lens"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "lens")
          }
        }

        public var dateShot: Time? {
          get {
            return resultMap["dateShot"] as? Time
          }
          set {
            resultMap.updateValue(newValue, forKey: "dateShot")
          }
        }

        /// The exposure time of the image
        public var exposure: Double? {
          get {
            return resultMap["exposure"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "exposure")
          }
        }

        /// The aperature stops of the image
        public var aperture: Double? {
          get {
            return resultMap["aperture"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "aperture")
          }
        }

        /// The ISO setting of the image
        public var iso: Int? {
          get {
            return resultMap["iso"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "iso")
          }
        }

        /// The focal length of the lens, when the image was taken
        public var focalLength: Double? {
          get {
            return resultMap["focalLength"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "focalLength")
          }
        }

        /// A formatted description of the flash settings, when the image was taken
        public var flash: Int? {
          get {
            return resultMap["flash"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "flash")
          }
        }

        /// An index describing the mode for adjusting the exposure of the image
        public var exposureProgram: Int? {
          get {
            return resultMap["exposureProgram"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "exposureProgram")
          }
        }
      }

      public struct Share: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ShareToken"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("token", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, token: String) {
          self.init(unsafeResultMap: ["__typename": "ShareToken", "id": id, "token": token])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var token: String {
          get {
            return resultMap["token"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "token")
          }
        }
      }

      public struct Download: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["MediaDownload"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("title", type: .nonNull(.scalar(String.self))),
            GraphQLField("mediaUrl", type: .nonNull(.object(MediaUrl.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(title: String, mediaUrl: MediaUrl) {
          self.init(unsafeResultMap: ["__typename": "MediaDownload", "title": title, "mediaUrl": mediaUrl.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var title: String {
          get {
            return resultMap["title"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "title")
          }
        }

        public var mediaUrl: MediaUrl {
          get {
            return MediaUrl(unsafeResultMap: resultMap["mediaUrl"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "mediaUrl")
          }
        }

        public struct MediaUrl: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["MediaURL"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("url", type: .nonNull(.scalar(String.self))),
              GraphQLField("width", type: .nonNull(.scalar(Int.self))),
              GraphQLField("height", type: .nonNull(.scalar(Int.self))),
              GraphQLField("fileSize", type: .nonNull(.scalar(Int.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(url: String, width: Int, height: Int, fileSize: Int) {
            self.init(unsafeResultMap: ["__typename": "MediaURL", "url": url, "width": width, "height": height, "fileSize": fileSize])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// URL for previewing the image
          public var url: String {
            get {
              return resultMap["url"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "url")
            }
          }

          /// Width of the image in pixels
          public var width: Int {
            get {
              return resultMap["width"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "width")
            }
          }

          /// Height of the image in pixels
          public var height: Int {
            get {
              return resultMap["height"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "height")
            }
          }

          /// The file size of the resource in bytes
          public var fileSize: Int {
            get {
              return resultMap["fileSize"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "fileSize")
            }
          }
        }
      }
    }
  }
}

public final class DeleteShareTokenMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation deleteShareToken($token: String!) {
      deleteShareToken(token: $token) {
        __typename
        id
        token
      }
    }
    """

  public let operationName: String = "deleteShareToken"

  public var token: String

  public init(token: String) {
    self.token = token
  }

  public var variables: GraphQLMap? {
    return ["token": token]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("deleteShareToken", arguments: ["token": GraphQLVariable("token")], type: .nonNull(.object(DeleteShareToken.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(deleteShareToken: DeleteShareToken) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "deleteShareToken": deleteShareToken.resultMap])
    }

    /// Delete a share token by it's token value
    public var deleteShareToken: DeleteShareToken {
      get {
        return DeleteShareToken(unsafeResultMap: resultMap["deleteShareToken"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "deleteShareToken")
      }
    }

    public struct DeleteShareToken: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ShareToken"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("token", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, token: String) {
        self.init(unsafeResultMap: ["__typename": "ShareToken", "id": id, "token": token])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var token: String {
        get {
          return resultMap["token"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "token")
        }
      }
    }
  }
}

public final class ShareMediaMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation shareMedia($id: ID!) {
      shareMedia(mediaId: $id) {
        __typename
        id
        token
      }
    }
    """

  public let operationName: String = "shareMedia"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("shareMedia", arguments: ["mediaId": GraphQLVariable("id")], type: .nonNull(.object(ShareMedium.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(shareMedia: ShareMedium) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "shareMedia": shareMedia.resultMap])
    }

    /// Generate share token for media
    public var shareMedia: ShareMedium {
      get {
        return ShareMedium(unsafeResultMap: resultMap["shareMedia"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "shareMedia")
      }
    }

    public struct ShareMedium: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ShareToken"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("token", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, token: String) {
        self.init(unsafeResultMap: ["__typename": "ShareToken", "id": id, "token": token])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var token: String {
        get {
          return resultMap["token"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "token")
        }
      }
    }
  }
}
