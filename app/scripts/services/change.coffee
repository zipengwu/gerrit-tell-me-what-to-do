'use strict'

angular.module 'gerritTellMeWhatToDoApp'
    .factory 'Change', ($http, Plugin) ->
        query: () ->
            url = "#{config.host}/changes/?q=is:open+owner:self&q=is:open+reviewer:self+-owner:self&o=DETAILED_ACCOUNTS&o=MESSAGES&o=ALL_REVISIONS"
            if config.plugin then Plugin.get url else $http.get url

