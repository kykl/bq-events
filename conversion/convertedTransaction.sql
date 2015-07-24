SELECT
  id, "transaction" name, createdAt, collectedAt, userId, sessionId, platform, language, game.key appId,
  '{ "type":"buy", "itemType":"CoinPack", "itemId":"' + replace(JSON_EXTRACT_SCALAR(event.json, '$.transactionName'), 'buy:', '') + '", "amount":' + JSON_EXTRACT_SCALAR(event.json, '$.realCurrencyAmount') + ', "currency":"' + JSON_EXTRACT_SCALAR(event.json, '$.realCurrencyType')  + '" }' as json
FROM [superpower.insightView]
where event.action = 'transaction' and
JSON_EXTRACT_SCALAR(event.json, '$.transactionVector') = 'SPENT'
