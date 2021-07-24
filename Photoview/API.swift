// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

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
