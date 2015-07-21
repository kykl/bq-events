SELECT *
FROM (
  SELECT
    id,
    CASE
      WHEN stepNumber = 1 THEN 'Level 1'
      WHEN stepNumber = 2 THEN 'Level 2'
      WHEN stepNumber = 3 THEN 'Level 3'
      WHEN stepNumber = 4 THEN 'Level 4'
      WHEN stepNumber = 5 THEN 'Level 5'
      WHEN stepNumber = 6 THEN 'Level 6'
      WHEN stepNumber = 7 THEN 'Level 7'
      WHEN stepNumber = 8 THEN 'Level 8'
      WHEN stepNumber = 9 THEN 'Level 9'
      WHEN stepNumber = 10 THEN 'Level 10'
      WHEN stepNumber = 11 THEN 'Level 11'
      WHEN stepNumber = 12 THEN 'Level 12'
      WHEN stepNumber = 13 THEN 'Level 13'
      WHEN stepNumber = 14 THEN 'Level 14'
      WHEN stepNumber = 15 THEN 'Level 15'
      WHEN stepNumber = 16 THEN 'Level 16'
      WHEN stepNumber = 17 THEN 'Level 17'
      WHEN stepNumber = 18 THEN 'Level 18'
      WHEN stepNumber = 19 THEN 'Level 19'
      WHEN stepNumber = 20 THEN 'Level 20'
      WHEN stepNumber = 21 THEN 'Level 21'
      WHEN stepNumber = 22 THEN 'Level 22'
      WHEN stepNumber = 23 THEN 'Level 23'
      WHEN stepNumber = 24 THEN 'Level 24'
      WHEN stepNumber = 25 THEN 'Level 25'
      WHEN stepNumber = 26 THEN 'Level 26'
      WHEN stepNumber = 27 THEN 'Level 27'
      WHEN stepNumber = 28 THEN 'Level 28'
      WHEN stepNumber = 29 THEN 'Level 29'
      WHEN stepNumber = 30 THEN 'Level 30'
      WHEN stepNumber = 31 THEN 'Level 31'
      WHEN stepNumber = 32 THEN 'Level 32'
      WHEN stepNumber = 33 THEN 'Level 33'
      WHEN stepNumber = 34 THEN 'Level 34'
      WHEN stepNumber = 35 THEN 'Level 35'
      WHEN stepNumber = 36 THEN 'Level 36'
      WHEN stepNumber = 37 THEN 'Level 37'
      WHEN stepNumber = 38 THEN 'Level 38'
      WHEN stepNumber = 39 THEN 'Level 39'
      WHEN stepNumber = 40 THEN 'Level 40'
      WHEN stepNumber = 41 THEN 'Level 41'
      WHEN stepNumber = 42 THEN 'Level 42'
      WHEN stepNumber = 43 THEN 'Level 43'
      WHEN stepNumber = 44 THEN 'Level 44'
      WHEN stepNumber = 45 THEN 'Level 45'
      WHEN stepNumber = 46 THEN 'Level 46'
      WHEN stepNumber = 47 THEN 'Level 47'
      WHEN stepNumber = 48 THEN 'Level 48'
      WHEN stepNumber = 49 THEN 'Level 49'
      WHEN stepNumber = 50 THEN 'Level 50'
      WHEN stepNumber = 51 THEN 'Level 51'
      WHEN stepNumber = 52 THEN 'Level 52'
      WHEN stepNumber = 53 THEN 'Level 53'
      WHEN stepNumber = 54 THEN 'Level 54'
      WHEN stepNumber = 55 THEN 'Level 55'
      WHEN stepNumber = 56 THEN 'Level 56'
      WHEN stepNumber = 57 THEN 'Level 57'
      WHEN stepNumber = 58 THEN 'Level 58'
      WHEN stepNumber = 59 THEN 'Level 59'
      WHEN stepNumber = 60 THEN 'Level 60'
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
