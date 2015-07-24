SELECT
  id, "progress" name, createdAt, collectedAt, userId, sessionId, platform, language, game.key appId,
  '{ "type":"level", ' +
  '"name":"' + JSON_EXTRACT_SCALAR(event.json, '$.missionName') + '", ' +
  '"time":' + JSON_EXTRACT_SCALAR(event.json, '$.missionTime') + ', ' +
  '"status":"' + event.action + '" }'
  as json
FROM [superpower.insightView]
where event.category = 'mission'
