'use strict'

###*
 # @ngdoc function
 # @name gerritTellMeWhatToDoApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the gerritTellMeWhatToDoApp
###
angular.module('gerritTellMeWhatToDoApp')
    .controller 'MainCtrl', ($scope, $mdSidenav, ChangeSetService, NewsService) ->
        $scope.getChangesets = ->
            ChangeSetService.getChangesets().then (res)->
                data = res.data
                result = []
                if data[0] instanceof Array
                    for arr in data
                        result = result.concat arr
                else
                    result = data
                $scope.changes = result
                for change in $scope.changes
                    # populateComments change
                    NewsService.getNews(change).then (data)->
                        console.log data
                        return
                return
            return

        populateComments = (change)->
            change.files ?= {}
            for revision in Object.keys(change.revisions)
                ChangeSetService.getComments(change, revision)
                    .then (res)->
                        _revision = res.data
                        _change = res.passenger
                        files = Object.keys(_revision)
                        for file in files
                            _change.files[file] ?= {}
                            for comment in _revision[file]
                                if comment.in_reply_to?
                                    _change.files[file][comment.in_reply_to] ?= {}
                                    _change.files[file][comment.in_reply_to].children ?=[]
                                    _change.files[file][comment.in_reply_to].children.push comment
                                else if _change.files[file][comment.id]?
                                    children = _change.files[file][comment.id].children
                                    _change.files[file][comment.id] = comment
                                    _change.files[file][comment.id].children = children
                                else
                                    _change.files[file][comment.id] = comment
                        return
            return

        $scope.getChangesets()
        return
