gradePattern = /Code-Review([+-]?\d)/

angular.module 'gerritTellMeWhatToDoApp'
	.factory 'HistoryService', () ->
		_jenkinsGrade = (messages)->
			grade = 0
			for message in messages
				if message.author.username is 'builder'
					if message.message.indexOf('SUCCESS') >= 0 then grade = 1
					else if message.message.indexOf('UNSTABLE') >=0 then grade = -1
					else if message.message.indexOf('FAILURE') >=0 then grade = -1
			return grade

		_robotGrade = (messages)->
			grade = 0
			for message in messages
				if message.author.username is 'bot'
					if message.message.indexOf('Verified+1') >=0 then grade = 1
					else if message.message.indexOf('Verified-1') >=0 then grade = -1
					else if message.message.indexOf('Verified-2') >=0 then grade = -1
			return grade

		_reviewGrade = (messages)->
			grade = 0
			for message in messages
				grade = gradeMatch[1] if (gradeMatch = gradePattern.exec(message.message))
			return grade

		_getLastRevision = (change)->
			lastRevision = 0
			lastRevision = message._revision_number if lastRevision < message._revision_number for message in change.messages
			result = []
			for message in change.messages
				if message._revision_number is lastRevision
					result.push message
			return result

		grade: (change) ->
			messages = _getLastRevision change
			change.reviewGrade = _reviewGrade messages
			change.jenkinsGrade = _jenkinsGrade messages
			change.robotGrade = _robotGrade messages
			return

