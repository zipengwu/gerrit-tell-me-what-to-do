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
                fetchNews(change) for change in $scope.changes
                return
            return

        # TODO for Francois, list news with priority
        fetchNews = (change)->
            NewsService.getNews(change).then (data)->
                for news in data
                    switch news.type
                        when 'COMMENT'
                            $scope.newsfeed[news.id] = news
                        when 'REVIEW'
                        # TODO
                            $scope.newsfeed[news.id] = news
                        else
                            console.log "unknow news type #{news.type}"
                return
            return

        $scope.init()

        return
