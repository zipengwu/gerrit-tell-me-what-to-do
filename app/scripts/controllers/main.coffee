'use strict'

###*
 # @ngdoc function
 # @name gerritTellMeWhatToDoApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the gerritTellMeWhatToDoApp
###
angular.module('gerritTellMeWhatToDoApp')
    .controller 'MainCtrl', ($scope, $mdSidenav, Change, NewsService) ->
        $scope.newsfeed = {}
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
                fetchNews(change) for change in $scope.changes
                return
            return

        fetchNews = (change)->
            NewsService.getNews(change).then (data)->
                for news in data
                    if news.type is 'COMMENT'
                        $scope.newsfeed[news.id] = news
                return
            return

        $scope.init()

        return
