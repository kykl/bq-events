-- dailyUserByAppView
select date(createdAt) dt, userId, appId
from [insight.event]
where createdAt is not null and userId is not null
group by dt, appId, userId;
