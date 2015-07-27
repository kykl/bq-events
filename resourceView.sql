-- resourceView
-- { "flow":"in", "itemType":"missionReward", "itemId":"152", "amount":2"resourceCurrency":"imperium" }
SELECT
  a.flow flow,
  a.itemType itemType,
  a.itemId itemId,
  a.amount amount,
  a.resourceCurrency resourceCurrency,
  a.dt dt, a.ts ts,a.userId userId, a.appId appId,
  if(u.acquiredAt is not null, 'Yes', 'No') newUser,
  u.platform platform, u.language language, u.segment segment, u.age age,
  u.gender gender, u.city city, u.country country, u.channel channel, u.acquiredAt acquiredAt,
  u.acquiredDate acquiredDate, u.acquisitionChannel acquisitionChannel
FROM (
  SELECT
    timestamp(date(createdAt)) dt, createdAt ts, userId, appId,
    JSON_EXTRACT_SCALAR(json, '$.flow') flow,
    JSON_EXTRACT_SCALAR(json, '$.itemType') itemType,
    JSON_EXTRACT_SCALAR(json, '$.itemId') itemId,
    CAST(JSON_EXTRACT_SCALAR(json, '$.amount') AS INTEGER) amount,
    JSON_EXTRACT_SCALAR(json, '$.resourceCurrency') resourceCurrency
  FROM [insight.event]
  where name = 'resource'
) a
left join each [insight.userView] u
on (a.dt = u.acquiredDate and a.appId = u.appId and a.userId = u.userId)
