SELECT
  CASE
    WHEN numOfEvents= 1 AND numOfEvents <=  10 THEN '01-10'
    WHEN numOfEvents= 2 AND numOfEvents <=  20 THEN '11-20'
    WHEN numOfEvents= 3 AND numOfEvents <=  30 THEN '21-30'
    WHEN numOfEvents= 4 AND numOfEvents <=  40 THEN '31-40'
    WHEN numOfEvents= 5 AND numOfEvents <=  50 THEN '41-50'
    WHEN numOfEvents= 6 AND numOfEvents <=  60 THEN '51-60'
    WHEN numOfEvents= 7 AND numOfEvents <=  70 THEN '61-70'
    WHEN numOfEvents= 8 AND numOfEvents <=  80 THEN '71-80'
    WHEN numOfEvents= 9 AND numOfEvents <=  90 THEN '81-90'
    WHEN numOfEvents=10 AND numOfEvents <= 100 THEN '91-100'
    ELSE '100 and more'
  END numOfEventsBucket,
  *
FROM (
  SELECT
    ROW_NUMBER() OVER (PARTITION BY sessionKey ORDER BY createdAt) rowNumber,
    COUNT(*) OVER (PARTITION BY sessionKey ORDER BY createdAt) numOfEvents,
    sessionKey,
    id,
    name,
    createdAt,
    collectedAt,
    userId,
    sessionId,
    platform,
    language,
    appId
  FROM (
    SELECT
      DATE(e.createdAt) dt,
      HASH(CONCAT(e.sessionId, e.appId, '|', e.userId, '|', DATE(e.createdAt))) sessionKey,
      e.id id,
      e.name name,
      e.createdAt createdAt,
      e.collectedAt collectedAt,
      e.userId userId,
      e.sessionId sessionId,
      e.platform platform,
      e.language language,
      e.appId appId
    FROM [insight.event] e
    LEFT JOIN [insight.sessionView] s
    ON (e.appId = s.appId AND e.userId = s.userId AND e.sessionId = s.sessionId)
    WHERE e.name <> 'engagement' AND s.userId IS NOT NULL AND s.appId IS NOT NULL
    ) t
) f
WHERE rowNumber = 1
