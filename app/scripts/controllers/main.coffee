'use strict'

###*
 # @ngdoc function
 # @name gerritTellMeWhatToDoApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the gerritTellMeWhatToDoApp
###
angular.module('gerritTellMeWhatToDoApp')
    .controller 'MainCtrl', ($scope, $mdSidenav, ChangeSetService) ->
        $scope.getChangesets = ->
            ChangeSetService.getChangesets().then (data)->
                result = []
                if data[0] instanceof Array
                    for arr in data
                        result = result.concat arr
                else
                    result = data
                $scope.changes = result
                return
            return

        $scope.getComments = ->
            $scope.comments  = []
            for change in $scope.changes
                for revision in Object.keys(change.revisions)
                    ChangeSetService.getComments(change.id, revision)
                        .then (rev)->
                            files = Object.keys(rev)
                            for file in files
                                $scope.comments.push comment for comment in rev[file]
                            return
            return

        $scope.getChangesets()
        return
