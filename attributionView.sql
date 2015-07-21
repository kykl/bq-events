-- attributionView
SELECT *
FROM (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY userId ORDER BY createdAt) rowNumber
    FROM (
        SELECT
          userId, appId, createdAt,
          JSON_EXTRACT_SCALAR(json, '$.acquisitionChannel') acquisitionChannel,
          JSON_EXTRACT_SCALAR(json, '$.adjAttrActivityKind') attrActivityKind,
          JSON_EXTRACT_SCALAR(json, '$.adjAttrAdgroup') attrAdgroup,
          JSON_EXTRACT_SCALAR(json, '$.adjAttrCampaign') attrCampaign,
          JSON_EXTRACT_SCALAR(json, '$.adjAttrCreative') attrCreative,
          JSON_EXTRACT_SCALAR(json, '$.adjAttrNetwork') attrNetwork,
          JSON_EXTRACT_SCALAR(json, '$.adjAttrTrackerName') attrTrackerName,
          JSON_EXTRACT_SCALAR(json, '$.adjAttrTrackerToken') attrTrackerToken,
        FROM [insight.event] where name = 'adjustAttribution'
    ) a
    WHERE attrActivityKind = 'SESSION' AND attrNetwork <> 'Organic'
)
WHERE rowNumber = 1
