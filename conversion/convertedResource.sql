
-- flow:in/out
-- resourceCurrency: currencyType
-- amount: currencyAmount
-- itemId: receivedItems
-- itemType: act

SELECT * FROM
(
  SELECT
    id, "resource" name, createdAt, collectedAt, userId, sessionId, platform, language, game.key appId,
    '{ "flow":"in", ' +
    '"itemType":"' + JSON_EXTRACT_SCALAR(event.json, '$.action') + '", ' +
    '"itemId":"' + JSON_EXTRACT_SCALAR(event.json, '$.actionDataId') + '", ' +
    '"amount":' + CAST(JSON_EXTRACT_SCALAR(event.json, '$.currencyAmount') AS INTEGER) +
    '"resourceCurrency":"' + JSON_EXTRACT_SCALAR(event.json, '$.currencyType') + '" }'
    as json
  FROM [superpower.insightView] where event.category = 'log' and event.action = 'receiveBehavior'
) r,
(
  SELECT
    id, "resource" name, createdAt, collectedAt, userId, sessionId, platform, language, game.key appId,
    '{ "flow":"out", ' +
    '"itemType":"' + JSON_EXTRACT_SCALAR(event.json, '$.action') + '", ' +
    '"itemId":"' + JSON_EXTRACT_SCALAR(event.json, '$.receivedItems') + '", ' +
    '"amount":' + CAST(JSON_EXTRACT_SCALAR(event.json, '$.currencyAmount') AS INTEGER) +
    '"resourceCurrency":"' + JSON_EXTRACT_SCALAR(event.json, '$.currencyType') + '" }'
    as json
  FROM [superpower.insightView] where event.category = 'log' and event.action = 'spendBehavior'
) s
