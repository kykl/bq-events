-- transactionView
SELECT
  a.transactionName transactionName,
  a.realCurrencyType realCurrencyType,
  a.realCurrencyAmount realCurrencyAmount,
  a.type type, a.itemType itemType, a.itemId itemId,
  a.dt dt, a.ts ts,a.userId userId, a.appId appId,
  if(u.acquiredAt is not null, 'Yes', 'No') newUser,
  u.platform platform, u.language language, u.segment segment, u.age age,
  u.gender gender, u.city city, u.country country, u.channel channel, u.acquiredAt acquiredAt,
  u.acquiredDate acquiredDate, u.acquisitionChannel acquisitionChannel
FROM (
  SELECT
    timestamp(date(createdAt)) dt, createdAt ts, userId, appId,
    JSON_EXTRACT_SCALAR(json, '$.type') + ':' +
      JSON_EXTRACT_SCALAR(json, '$.itemType') + ':' +
      JSON_EXTRACT_SCALAR(json, '$.itemId') as transactionName,
    JSON_EXTRACT_SCALAR(json, '$.currency') realCurrencyType,
    CAST(JSON_EXTRACT_SCALAR(json, '$.amount') AS INTEGER) realCurrencyAmount,
    JSON_EXTRACT_SCALAR(json, '$.type') type,
    JSON_EXTRACT_SCALAR(json, '$.itemType') itemType,
    JSON_EXTRACT_SCALAR(json, '$.itemId') itemId
  FROM [insight.event]
  where name = 'transaction'
) a
left join each [insight.userView] u
on (a.dt = u.acquiredDate and a.appId = u.appId and a.userId = u.userId)
