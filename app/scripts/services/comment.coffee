angular.module 'gerritTellMeWhatToDoApp'
  .factory 'Comment', ($http) ->
    query: (changeId, revisionId) ->
        host = "http://git.ullink.lan:8080"
        return $http.get "#{host}/changes/#{changeId}/revisions/#{revisionId}/comments/"
