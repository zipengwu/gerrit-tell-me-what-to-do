'use strict'

###*
 # @ngdoc service
 # @name gerritTellMeWhatToDoApp.plugin
 # @description
 # # plugin
 # Service in the gerritTellMeWhatToDoApp.
###
angular.module('gerritTellMeWhatToDoApp')
  .service 'Plugin', ($q)->
    # AngularJS will instantiate a singleton by calling "new" on this function
    @get = (url)->
        deferred = $q.defer()
        chrome.runtime.sendMessage 'gmfnpeeckhbcbckcfcaemgdpnbkoegcn', url, (data)->
            deferred.resolve data:JSON.parse(data.substr(4))
            return
        return deferred.promise

    return
