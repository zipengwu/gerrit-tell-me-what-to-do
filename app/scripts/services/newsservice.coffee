reviewPattern = /^Patch Set (\d+):( Code-Review([+-]?\d))?(\s+\((\d+) comment\))?(\s+(.*))?/

angular.module 'gerritTellMeWhatToDoApp'
	.factory 'NewsService', ($http, $q, Comment) ->
			getNews: (change, limit) ->
				news = []

				for index, message of change.messages
					console.log(message)
					if reviewMatch = reviewPattern.exec(message.message)
						news.push {
							type: 'REVIEW'
							revision: reviewMatch[1]
							grade: reviewMatch[3]
							comments: reviewMatch[5]
							reply: reviewMatch[7]
							authorId: message.author._account_id
							timestamp: message.date
						}

				gerritComments = (Comment.query(change.id, revisionId) for revisionId, revision of change.revisions)
				$q.all(gerritComments).then (results) ->
					for gerritComment in results
						for file, fileComments of gerritComment.data
							for comment in fileComments
								news.push {
									type: 'COMMENT'
									id: comment.id
									message: comment.message
									file: file
									authorId: comment.author._account_id
									timestamp: comment.updated
								}
					news
