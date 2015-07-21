-- sessionView
SELECT
   FORMAT_UTC_USEC(i.createdAt) createdAt,
   FORMAT_UTC_USEC(i.collectedAt) collectedAt,
   FORMAT_UTC_USEC(date(i.createdAt)) dtTimestamp,
   i.userId userId,
   i.appId appId,
   FORMAT_UTC_USEC(i.sessionStarted) sessionStarted,
   FORMAT_UTC_USEC(i.sessionEnded) sessionEnded,
   i.sessionLength sessionLength,
   i.sessionId sessionId,
   if(date(u.acquiredAt) = date(i.createdAt) , 'Yes', 'No') newUser,
   u.acquisitionChannel acquisitionChannel
FROM (
   SELECT createdAt, collectedAt, userId, appId, name, sessionId,
     CAST(JSON_EXTRACT_SCALAR(json, '$.timestampStarted') AS TIMESTAMP) sessionStarted,
     CAST(JSON_EXTRACT_SCALAR(json, '$.timestampEnded') AS TIMESTAMP) sessionEnded,
     CAST(JSON_EXTRACT_SCALAR(json, '$.engagementLength') AS INTEGER) sessionLength,
   FROM [insight.event] where name = 'engagement'
) i
LEFT JOIN EACH (SELECT userId uid, appId aid, acquiredAt, acquisitionChannel FROM [insight.userView]) u
ON i.userId = u.uid AND i.appId = u.aid
