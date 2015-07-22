SELECT *
FROM (TABLE_QUERY(insight,'table_id = "event_stream" OR REGEXP_MATCH(table_id, r"^event_.*_[\d]{8}_[\d]{6}")'))

