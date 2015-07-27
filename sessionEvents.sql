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
    ROW_NUMBER() OVER (PARTITION BY sessionKey ORDER BY ts) rowNumber,
    COUNT(*) OVER (PARTITION BY sessionKey ORDER BY ts) numOfEvents,
    sessionKey,
    dt, ts, userId, appId,
    newUser,platform, language, segment, age, gender, city, country, channel, acquiredAt, acquiredDate, acquisitionChannel
  FROM (
    SELECT
      HASH(CONCAT(e.sessionId, e.appId, '|', e.userId, '|', DATE(e.createdAt))) sessionKey,
      timestamp(date(e.createdAt)) dt, e.createdAt ts, e.userId userId, e.appId appId,
      if(s.acquiredAt is not null, 'Yes', 'No') newUser,
      s.platform platform, s.language language, s.segment segment, s.age age,
      s.gender gender, s.city city, s.country country, s.channel channel, s.acquiredAt acquiredAt,
      s.acquiredDate acquiredDate, s.acquisitionChannel acquisitionChannel
    FROM [insight.event] e
    LEFT JOIN [insight.sessionView] s
    ON (e.appId = s.appId AND e.userId = s.userId AND e.sessionId = s.sessionId)
    WHERE e.name <> 'engagement' AND s.userId IS NOT NULL AND s.appId IS NOT NULL
    ) t
) f
WHERE rowNumber = 1
