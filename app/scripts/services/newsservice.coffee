reviewPattern = /^Patch Set (\d+):( Code-Review([+-]?\d))?(\s+\((\d+) comment\))?(\s+(.*))?/

angular.module 'gerritTellMeWhatToDoApp'
	.factory 'NewsService', ($http, $q, Comment) ->

			getNews: (change, limit) ->
				getCommentList = (change) ->
					news = {}
					gerritComments = (Comment.query(change.id, revisionId) for revisionId, revision of change.revisions)
					$q.all(gerritComments).then (results) ->
						for gerritComment in results
							for file, fileComments of gerritComment.data
								for comment in fileComments
									news[comment.id] = {
										type: 'COMMENT'
										id: comment.id
										parent: comment.in_reply_to
										message: comment.message
										file: file
										authorId: comment.author._account_id
										authorName: comment.author.name
										timestamp: comment.updated
									}
						news

				news = []

				for index, message of change.messages
#					console.log(message)
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

				deferred = $q.defer()
				getCommentList(change).then (results) ->
#					console.log(results)
					threads = {}
					for commentId, comment of results
						parent = comment
						while parent.parent
							parent = results[parent.parent]
#						console.log "parent of #{comment.id} is #{parent.id}"
						if not threads[parent.id]
							threads[parent.id] = {}
							threads[parent.id].comments = []
							threads[parent.id].file = parent.file
							threads[parent.id].timestamp = moment(parent.timestamp)
							threads[parent.id].lastComment = parent
							threads[parent.id].change = change.subject
							threads[parent.id].gerritId = change._number
							threads[parent.id].expanded = false
#							console.log change
						timestamp = moment(comment.timestamp)
						threads[parent.id].comments.push comment
						comment.thread = threads[parent.id]
						if timestamp.isAfter threads[parent.id].timestamp
							threads[parent.id].timestamp = timestamp
							threads[parent.id].lastComment = comment
#					console.log threads
					results
					threads
					deferred.resolve(threads)
				deferred.promise
	.filter 'unixdate', () ->
		(input) -> moment.unix input
	.filter 'formatmoment', () ->
		(input) -> moment(input).fromNow()
#				gerritComments = (Comment.query(change.id, revisionId) for revisionId, revision of change.revisions)
#				$q.all(gerritComments).then (results) ->
#					for gerritComment in results
#						for file, fileComments of gerritComment.data
#							for comment in fileComments
#								news.push {
#									type: 'COMMENT'
#									id: comment.id
#									message: comment.message
#									file: file
#									authorId: comment.author._account_id
#									timestamp: comment.updated
#								}
#					news

