SELECT
  id, "progress" name, createdAt, collectedAt, userId, sessionId, platform, language, appId,
  '{ "type":"funnel", ' +
  '"name":"' + f.name + '", ' +
  '"time": 0,' +
  '"status":"completed" }'
  as json
FROM [insight.eventFunnel] f
