'use strict'

describe 'Service: ChangeSetService', ->

  # load the service's module
  beforeEach module 'gerritTellMeWhatToDoApp'

  # instantiate service
  ChangeSetService = {}
  beforeEach inject (_ChangeSetService_) ->
    ChangeSetService = _ChangeSetService_

  it 'should do something', ->
    expect(!!ChangeSetService).toBe true
