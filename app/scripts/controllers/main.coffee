'use strict'

###*
 # @ngdoc function
 # @name gerritTellMeWhatToDoApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the gerritTellMeWhatToDoApp
###
angular.module('gerritTellMeWhatToDoApp')
	.controller 'MainCtrl', ($scope, $mdSidenav, Change, NewsService, HistoryService) ->
		$scope.newsfeed = []
		$scope.select = (change) ->
			$scope.newsfeed = []
			fetchNews change
			return

		# TODO for Zipeng, list change set status
		$scope.init = ->
			Change.query().then (res)->
				data = res.data
				result = []
				if data[0] instanceof Array
					for arr in data
						result = result.concat arr
				else
					result = data
				$scope.changes = result
				HistoryService.grade(change) for change in $scope.changes
				fetchNews(change) for change in $scope.changes
				return
			return

		# TODO for Francois, list news with priority
		fetchNews = (change)->
			NewsService.getNews(change).then (data2)->
				for threadId, thread of data2
					$scope.newsfeed.push thread
					console.log thread
#				for news in data
#					switch news.type
#						when 'COMMENT'
#							$scope.newsfeed[news.id] = news
#						when 'REVIEW'
#						# TODO
#							$scope.newsfeed[news.id] = news
#						else
#							console.log "unknow news type #{news.type}"
				return
			return

		$scope.isExpanded = (value, index) ->
			console.log "expand #{value}"
			true

		$scope.init()

		return
