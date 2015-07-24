-- missionView
SELECT
  date(createdAt) dt, createdAt, collectedAt, userId, appId,
  JSON_EXTRACT_SCALAR(json, '$.type') type,
  JSON_EXTRACT_SCALAR(json, '$.name') name,
  JSON_EXTRACT_SCALAR(json, '$.status') status,
  CAST(JSON_EXTRACT_SCALAR(json, '$.time') AS INTEGER) time
FROM [insight.event]
where name = 'progress'
