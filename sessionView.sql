-- sessionView
SELECT
   FORMAT_UTC_USEC(a.createdAt) createdAt,
   FORMAT_UTC_USEC(a.collectedAt) collectedAt,
   a.userId userId,
   a.appId appId,
   FORMAT_UTC_USEC(a.sessionStarted) sessionStarted,
   FORMAT_UTC_USEC(a.sessionEnded) sessionEnded,
   a.sessionLength sessionLength,
   a.sessionId sessionId,
   a.dt dt,
   FORMAT_UTC_USEC(a.dt) dtTimestamp,
   if(acquiredDt is not null, 'Yes', 'No') newUser,
   n.acquisitionChannel acquisitionChannel,
   n.platform platform,
   n.language language,
   n.segment segment,
   n.age age,
   n.gender gender,
   n.country country
FROM (
   SELECT date(createdAt) dt, createdAt, collectedAt, userId, appId, name, sessionId,
     CAST(JSON_EXTRACT_SCALAR(json, '$.start') AS TIMESTAMP) sessionStarted,
     CAST(JSON_EXTRACT_SCALAR(json, '$.end') AS TIMESTAMP) sessionEnded,
     CAST(JSON_EXTRACT_SCALAR(json, '$.length') AS INTEGER) sessionLength,
   FROM [insight.event] where name = 'session'
) a
left join each (
    select
      userId, appId, date(acquiredAt) acquiredDt, acquisitionChannel,
      platform, language, segment, age, gender, country
    from [insight.userView]
) n
on (a.dt = n.acquiredDt and a.appId = n.appId and a.userId = n.userId)
