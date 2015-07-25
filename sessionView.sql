-- sessionView
SELECT
  a.sessionStarted sessionStarted,
  a.sessionEnded sessionEnded,
  a.sessionLength sessionLength,
  a.sessionId sessionId,
  a.dt dt, a.ts ts,a.userId userId, a.appId appId,
  if(u.acquiredAt is not null, 'Yes', 'No') newUser,
  u.platform platform, u.language language, u.segment segment, u.age age,
  u.gender gender, u.city city, u.country country, u.channel channel, u.acquiredAt acquiredAt,
  u.acquiredDate acquiredDate, u.acquisitionChannel acquisitionChannel
FROM (
  SELECT timestamp(date(createdAt)) dt, createdAt ts, userId, appId, name, sessionId,
    CAST(JSON_EXTRACT_SCALAR(json, '$.start') AS TIMESTAMP) sessionStarted,
    CAST(JSON_EXTRACT_SCALAR(json, '$.end') AS TIMESTAMP) sessionEnded,
    CAST(JSON_EXTRACT_SCALAR(json, '$.length') AS INTEGER) sessionLength,
  FROM [insight.event] where name = 'session'
) a
left join each [insight.userView] u
on (a.dt = u.acquiredDate and a.appId = u.appId and a.userId = u.userId)
