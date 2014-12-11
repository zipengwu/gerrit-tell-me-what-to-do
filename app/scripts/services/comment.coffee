'use strict'

angular.module 'gerritTellMeWhatToDoApp'
	.factory 'Comment', ($http, Plugin) ->
		query: (changeId, revisionId) ->
			url = "#{config.host}/changes/#{changeId}/revisions/#{revisionId}/comments/"
			if config.plugin then Plugin.get url else $http.get url
