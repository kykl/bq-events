SELECT
  id, "session" name, createdAt, collectedAt, userId, sessionId, platform, language, appId,
  '{ "start":"' + f.sessionStarted + '", ' +
  '"end":"' + f.sessionEnded + '", ' +
  '"length":' + cast(f.sessionLength as string)+ ' }'
  as json
FROM (
  SELECT id, createdAt, collectedAt, userId, appId, name, sessionId, platform, language,
    JSON_EXTRACT_SCALAR(json, '$.timestampStarted') sessionStarted,
    JSON_EXTRACT_SCALAR(json, '$.timestampEnded') sessionEnded,
    CAST(JSON_EXTRACT_SCALAR(json, '$.engagementLength') AS INTEGER) sessionLength,
  FROM [insight.event] where name = 'engagement'
) f
