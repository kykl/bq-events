-- transactionView
SELECT
  date(createdAt) dt, createdAt, collectedAt, userId, appId,
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
