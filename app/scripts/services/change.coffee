angular.module 'gerritTellMeWhatToDoApp'
  .factory 'Change', ($http) ->
    query: () ->
        host = "http://git.ullink.lan:8080"
        return $http.get "#{host}/changes/?o=DETAILED_ACCOUNTS&o=MESSAGES&o=ALL_REVISIONS"
