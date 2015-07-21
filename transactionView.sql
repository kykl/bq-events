-- transactionView
SELECT
  date(createdAt) dt, createdAt, collectedAt, userId, appId,
  JSON_EXTRACT_SCALAR(json, '$.transactionName') transactionName,
  JSON_EXTRACT_SCALAR(json, '$.realCurrencyType') realCurrencyType,
  CAST(JSON_EXTRACT_SCALAR(json, '$.realCurrencyAmount') AS INTEGER) realCurrencyAmount,
FROM [insight.event]
where name = 'transaction' and JSON_EXTRACT_SCALAR(json, '$.transactionVector') = 'SPENT'
