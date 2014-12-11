gradePattern = /Code-Review([+-]?\d)/

angular.module 'gerritTellMeWhatToDoApp'
	.factory 'HistoryService', () ->
		getLastGrade: (change, accountId) ->
			for i, message of change.messages
				grade = gradeMatch[1] if message.author._account_id is accountId and (gradeMatch = gradePattern.exec(message.message))
			grade ? 0
