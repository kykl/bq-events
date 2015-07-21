select
  a.dt dt,
  a.appId appId,
  a.userId userId,
  a.createdAt createdAt,
  a.funnel funnel,
  a.step step,
  a.stepSequence stepSequence,
  a.prevStepSequence prevStepSequence,
  n.acquiredDt acquiredDt,
  n.acquisitionChannel acquisitionChannel,
  n.platform platform,
  n.language language,
  n.segment segment,
  n.age age,
  n.gender gender,
  n.country country
from
(
  select * from (
    select
      e.appId appId,
      e.userId userId,
      e.createdAt createdAt,
      f.funnel funnel,
      f.step step,
      f.sequence stepSequence,
      LAG(stepSequence, 1) OVER (PARTITION BY userId ORDER BY createdAt) prevStepSequence,
      date(e.createdAt) dt
    from [insight.eventFunnel] e
    join [insight.funnelConfig] f
    on (e.appId = f.appId and e.name = f.step)
  )
  where stepSequence >= 1
    and (stepSequence = prevStepSequence or prevStepSequence is null or prevStepSequence + 1 = stepSequence)
) a
left join each (
    select
      userId, appId, date(acquiredAt) acquiredDt, acquisitionChannel,
      platform, language, segment, age, gender, country
    from [insight.userView]
) n
on (a.dt = n.acquiredDt and a.appId = n.appId and a.userId = n.userId)
