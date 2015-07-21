select
  a.endDt dt, a.appId appId,
  a.d0UserId dayUser,
  a.d0_6UserId weekUser,
  a.l.d0_29UserId monthUser,
  if(acquiredDt is not null, 'Yes', 'No') newUser,
  FORMAT_UTC_USEC(a.endDt) dtTimestamp,
  n.acquisitionChannel acquisitionChannel,
  n.platform platform,
  n.language language,
  n.segment segment,
  n.age age,
  n.gender gender,
  n.country country
from (
   select
    r.startDt startDt, r.endDt endDt,
    if (l.dt = r.endDt, userId, null) d0UserId,
    if (l.dt >= date(date_add(r.endDt, -6, 'DAY')), userId, null) d0_6UserId,
    userId d0_29UserId,
    r.appId appId
   from
   (
     select date(createdAt) endDt, date(date_add(createdAt, -29, 'DAY')) startDt, appId
     from insight.event
     where createdAt is not null
     group by startDt, endDt, appId
   ) r
   cross join
   (
     select userId, date(createdAt) dt, appId from insight.event where userId is not null
   ) l
   where l.dt >= r.startDt and l.dt <= r.endDt and l.appId = r.appId
) a
left join each (
    select
      userId, appId, date(acquiredAt) acquiredDt, acquisitionChannel,
      platform, language, segment, age, gender, country
    from [insight.userView]
) n
on (a.endDt = n.acquiredDt and a.appId = n.appId and a.d0UserId = n.userId)
