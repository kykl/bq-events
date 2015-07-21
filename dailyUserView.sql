-- dailyUserView
select
    a.dt dt, a.appId appId, a.d0UserId d0UserId,
    a.d1UserId d1UserId, a.d2UserId d2UserId, a.d3UserId d3UserId, a.d7UserId d7UserId, a.d14UserId d14UserId, a.d30UserId d30UserId,
    a.d0_6UserId d0_6UserId,
    a.d0_29UserId d0_29UserId,
    a.d4_7UserId d4_7UserId,
    a.d8_14UserId d8_14UserId,
    a.d15_30UserId d15_30UserId,
    a.d30PlusUserId d30PlusUserId,
    if(acquiredDt is not null, 'Yes', 'No') newUser,
    FORMAT_UTC_USEC(a.dt) dtTimestamp,
    n.acquisitionChannel acquisitionChannel,
    n.platform platform,
    n.language language,
    n.segment segment,
    n.age age,
    n.gender gender,
    n.country country
from (
  select
      l.dt dt,
      l.appId appId,
      l.userId d0UserId,
      if (r.dt = date(date_add(l.dt, 1, 'DAY')), l.userId, null) d1UserId,
      if (r.dt = date(date_add(l.dt, 2, 'DAY')), l.userId, null) d2UserId,
      if (r.dt = date(date_add(l.dt, 3, 'DAY')), l.userId, null) d3UserId,
      if (r.dt = date(date_add(l.dt, 7, 'DAY')), l.userId, null) d7UserId,
      if (r.dt = date(date_add(l.dt, 14, 'DAY')), l.userId, null) d14UserId,
      if (r.dt = date(date_add(l.dt, 30, 'DAY')), l.userId, null) d30UserId,
      if (r.dt >= l.dt and r.dt <= date(date_add(l.dt, 6, 'DAY')), l.userId, null) d0_6UserId,
      if (r.dt >= l.dt and r.dt <= date(date_add(l.dt, 29, 'DAY')), l.userId, null) d0_29UserId,
      if (r.dt >= date(date_add(l.dt, 4, 'DAY')) and r.dt <= date(date_add(l.dt, 7, 'DAY')), l.userId, null) d4_7UserId,
      if (r.dt >= date(date_add(l.dt, 8, 'DAY')) and r.dt <= date(date_add(l.dt, 14, 'DAY')), l.userId, null) d8_14UserId,
      if (r.dt >= date(date_add(l.dt, 15, 'DAY')) and r.dt <= date(date_add(l.dt, 30, 'DAY')), l.userId, null) d15_30UserId,
      if (r.dt > date(date_add(l.dt, 30, 'DAY')), l.userId, null) d30PlusUserId
  from [insight.dailyUserByAppView] l
  join [insight.dailyUserByAppView] r
  on l.userId = r.userId and l.appId = r.appId
) a,
left join each (
    select
      userId, appId, date(acquiredAt) acquiredDt, acquisitionChannel,
      platform, language, segment, age, gender, country
    from [insight.userView]
) n
on (a.dt = n.acquiredDt and a.appId = n.appId and a.d0UserId = n.userId)
