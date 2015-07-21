SELECT *
FROM (
  SELECT
    id,
    CASE
    WHEN stepNumber = 1 THEN 'Exclusive 60% Sale Viewed'
    WHEN stepNumber = 12 THEN 'Buy Button Clicked'
    WHEN stepNumber = 60 THEN '3000 Diamonds Bought'
      ELSE NULL
    END AS name,
    createdAt,
    collectedAt,
    userId,
    sessionId,
    platform,
    language,
    appId,
    json
  FROM (
    SELECT id, name, createdAt, collectedAt, userId, sessionId, platform, language, appId, json,
      cast(JSON_EXTRACT_SCALAR(json, '$.analyticsSequence') as integer) stepNumber
    FROM [insight.event]
    WHERE name = 'ftueCheckpoint'
  )
)
WHERE name IS NOT NULL
