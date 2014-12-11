'use strict'

###*
 # @ngdoc service
 # @name gerritTellMeWhatToDoApp.ChangeSetService
 # @description
 # # ChangeSetService
 # Service in the gerritTellMeWhatToDoApp.
###
angular.module('gerritTellMeWhatToDoApp')
    .service 'ChangeSetService', ($q, $http)->

        host = "http://git.ullink.lan:8080"

        @getChangesets = ->
            query = "/changes/?q=is:open+owner:self&q=is:open+reviewer:self+-owner:self&o=ALL_REVISIONS"
            plugin_get host + query

        @getComments = (id, revision)->
            query = "/changes/#{id}/revisions/#{revision}/comments/"
            plugin_get host + query

        http_get = (url)->
            deferred = $q.defer()
            $http.get url
                .success (data, status)->
                    console.log data
                    deferred.resolve data
                    return
                .error (data, status)->
                    console.log data
                    deferred.reject data
                    return
            return deferred.promise

        plugin_get = (url)->
            deferred = $q.defer()
            chrome.runtime.sendMessage 'gmfnpeeckhbcbckcfcaemgdpnbkoegcn', url, (data)->
                console.log "client receive data from extension"
                deferred.resolve JSON.parse(data.substr(4))
                return
            return deferred.promise

        return
