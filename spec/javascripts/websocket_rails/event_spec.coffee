describe 'WebSocketRails.Event', ->

  describe 'standard events', ->
    beforeEach ->
      @data = ['event',{data: { message: 'test'} },12345]
      @event = new WebSocketRails.Event(@data)

    it 'should generate an ID', ->
      expect(@event.id).not.toBeNull

    it 'should have a connection ID', ->
      expect(@event.connection_id).toEqual 12345

    it 'should assign the correct properties when passed a data array', ->
      expect(@event.name).toEqual 'event'
      expect(@event.data.message).toEqual 'test'

    describe '.serialize()', ->
      it 'should serialize the event as JSON', ->
        @event.id = 1
        serialized = "[\"event\",{\"id\":1,\"data\":{\"message\":\"test\"}}]"
        expect(@event.serialize()).toEqual serialized

    describe '.isChannel()', ->
      it 'should be false', ->
        expect(@event.isChannel()).toEqual false

    describe '.isFileUpload()', ->
      it 'should be false', ->
        expect(@event.isFileUpload()).toEqual false

  describe 'channel events', ->
    beforeEach ->
      @data = ['event',{channel:'channel',data:{message: 'test'}}]
      @event = new WebSocketRails.Event(@data)

    it 'should assign the channel property', ->
      expect(@event.channel).toEqual 'channel'
      expect(@event.name).toEqual 'event'
      expect(@event.data.message).toEqual 'test'

    describe '.isChannel()', ->
      it 'should be true', ->
        expect(@event.isChannel()).toEqual true

    describe '.serialize()', ->
      it 'should serialize the event as JSON', ->
        @event.id = 1
        serialized = "[\"event\",{\"id\":1,\"channel\":\"channel\",\"data\":{\"message\":\"test\"}}]"
        expect(@event.serialize()).toEqual serialized

  describe '.run_callbacks()', ->
    beforeEach ->
      successFunc = (data) ->
        data
      failureFunc = (data) ->
        data
      @data = ['event', {data: { message: 'test'} }, 12345]
      @event = new WebSocketRails.Event(@data, successFunc, failureFunc)

    describe 'when successful', ->
      it 'should run the success callback when passed true', ->
        expect(@event.run_callbacks(true,'success')).toEqual 'success'

      it 'should not run the failure callback', ->
        expect(@event.run_callbacks(true,'success')).toBeUndefined

    describe 'when failure', ->
      it 'should run the failure callback when passed true', ->
        expect(@event.run_callbacks(false,'failure')).toEqual 'failure'

      it 'should not run the failure callback', ->
        expect(@event.run_callbacks(false,'failure')).toBeUndefined
