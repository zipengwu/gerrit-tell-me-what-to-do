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
            http_get(host + query)

        @getComments = (change, revision)->
            query = "/changes/#{change.id}/revisions/#{revision}/comments/"
            http_get(host + query, change)

        http_get = (url, passenger)->
            deferred = $q.defer()
            $http.get url
                .success (data, status)->
                    console.log data
                    deferred.resolve {data:data, passenger: passenger}
                    return
                .error (data, status)->
                    console.log data
                    deferred.reject {data:data, passenger: passenger}
                    return
            return deferred.promise

        plugin_get = (url, passenger)->
            deferred = $q.defer()
            chrome.runtime.sendMessage 'gmfnpeeckhbcbckcfcaemgdpnbkoegcn', url, (data)->
                console.log "client receive data from extension"
                deferred.resolve {data:JSON.parse(data.substr(4)), passenger: passenger}
                return
            return deferred.promise

        return
