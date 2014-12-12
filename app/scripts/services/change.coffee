'use strict'

angular.module 'gerritTellMeWhatToDoApp'
	.factory 'Change', ($http, Plugin) ->
		query: () ->
			if config.prod
				url = "#{config.host}/changes/?q=is:open+owner:self&q=is:open+reviewer:self+-owner:self&o=DETAILED_ACCOUNTS&o=MESSAGES&o=ALL_REVISIONS"
			else
				url = "#{config.host}/changes/?q=owner:%22Yi+Han+%3Cyi.han%40ullink.com%3E%22+status:open&o=DETAILED_ACCOUNTS&o=MESSAGES&o=ALL_REVISIONS"
			if config.plugin then Plugin.get url else $http.get url
