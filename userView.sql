-- userView
select
  i.userId userId, i.appId appId, i.platform platform,
  i.language language, i.segment segment, i.age age, i.gender gender, i.city city,
  i.country country, i.channel channel, TIMESTAMP(i.acquiredAt) acquiredAt, TIMESTAMP(date(i.acquiredAt)) acquiredDate,
  a.acquisitionChannel acquisitionChannel
from
(
    select userId, appId,
        first(t.platform) platform,
        first(language) language,
        first(segment) segment,
        first(age) age,
        first(gender) gender,
        first(t.city) city,
        first(t.country) country,
        first(channel) channel,
        min(createdAt) acquiredAt
    from (
        select
            userId,
            appId,
            createdAt,
            platform,
            language,
            cast(null as string) segment,
            cast(null as INTEGER) age,
            cast(null as string) gender,
            if (name = 'location', JSON_EXTRACT_SCALAR(json, '$.city'), null) city,
            if (name = 'location', JSON_EXTRACT_SCALAR(json, '$.country'), null) country,
            cast(null as string) channel,
            collectedAt
        from [insight.event]
    ) t
    group by userId, appId
) i
left join each (
    select userId uid, appId aid, acquisitionChannel FROM [insight.attributionView]
    group by 1, 2, 3
) a
on i.userId = a.uid and i.appId = a.aid
