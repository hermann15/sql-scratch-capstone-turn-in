1. 

select *
from subscriptions
limit 100;


2.

select min(subscription_start)
from subscriptions;
 
select max(subscription_start)
from subscriptions;


3.

WITH months AS
(SELECT
  '2017-01-01' as first_day,
  '2017-01-31' as last_day
UNION
 Select
  '2017-02-01' as first_day,
  '2017-02-28' as last_day
Union
 Select
  '2017-03-01' as first_day,
  '2017-03-31' as last_day
)
select *
from months;


4. 

WITH months AS
(SELECT
  '2017-01-01' as first_day,
  '2017-01-31' as last_day
UNION
 Select
  '2017-02-01' as first_day,
  '2017-02-28' as last_day
Union
 Select
  '2017-03-01' as first_day,
  '2017-03-31' as last_day
),
cross_join AS
(SELECT *
FROM subscriptions
cross join months
)
select *
from cross_join;


5.

WITH months AS
(SELECT
  '2017-01-01' as first_day,
  '2017-01-31' as last_day
UNION
 Select
  '2017-02-01' as first_day,
  '2017-02-28' as last_day
Union
 Select
  '2017-03-01' as first_day,
  '2017-03-31' as last_day
),
cross_join AS
(SELECT *
FROM subscriptions
cross join months
),
status AS
(SELECT id, first_day as month,
CASE
  WHEN (segment = 87
  )
  		AND (subscription_start < first_day)
    AND (
      subscription_end > first_day
      OR subscription_end IS NULL
    ) THEN 1
  ELSE 0
END as is_active_87,
CASE 
	WHEN (segment = 30
  )
  		AND (subscription_start < first_day)
    AND (
      subscription_end > first_day
      OR subscription_end IS NULL
    ) THEN 1
  ELSE 0
END as is_active_30
FROM cross_join)
select *
from status;


6.

WITH months AS
(SELECT
  '2017-01-01' as first_day,
  '2017-01-31' as last_day
UNION
 Select
  '2017-02-01' as first_day,
  '2017-02-28' as last_day
Union
 Select
  '2017-03-01' as first_day,
  '2017-03-31' as last_day
),
cross_join AS
(SELECT *
FROM subscriptions
cross join months
),
status AS
(SELECT id, first_day as month,
CASE
  WHEN (segment = 87
  )
  		AND (subscription_start < first_day)
    AND (
      subscription_end > first_day
      OR subscription_end IS NULL
    ) THEN 1
  ELSE 0
END as is_active_87,
CASE
 WHEN (segment = 87) AND
  (subscription_end BETWEEN first_day AND last_day) THEN 1
  ELSE 0
END as is_canceled_87,
CASE 
	WHEN (segment = 30
  )
  		AND (subscription_start < first_day)
    AND (
      subscription_end > first_day
      OR subscription_end IS NULL
    ) THEN 1
  ELSE 0
END as is_active_30,
CASE
 WHEN (segment = 30) AND
  (subscription_end BETWEEN first_day AND last_day) THEN 1
  ELSE 0
END as is_canceled_30
FROM cross_join)
select *
from status;


7.

WITH months AS
(SELECT
  '2017-01-01' as first_day,
  '2017-01-31' as last_day
UNION
 Select
  '2017-02-01' as first_day,
  '2017-02-28' as last_day
Union
 Select
  '2017-03-01' as first_day,
  '2017-03-31' as last_day
),
cross_join AS
(SELECT *
FROM subscriptions
cross join months
),
status AS
(SELECT id, first_day as month,
CASE
  WHEN (segment = 87
  )
  		AND (subscription_start < first_day)
    AND (
      subscription_end > first_day
      OR subscription_end IS NULL
    ) THEN 1
  ELSE 0
END as is_active_87,
CASE
 WHEN (segment = 87) AND
  (subscription_end BETWEEN first_day AND last_day) THEN 1
  ELSE 0
END as is_canceled_87,
CASE 
	WHEN (segment = 30
  )
  		AND (subscription_start < first_day)
    AND (
      subscription_end > first_day
      OR subscription_end IS NULL
    ) THEN 1
  ELSE 0
END as is_active_30,
CASE
 WHEN (segment = 30) AND
  (subscription_end BETWEEN first_day AND last_day) THEN 1
  ELSE 0
END as is_canceled_30
From cross_join),
status_aggregate as (
select month, sum(is_active_87) as 'active_87', sum(is_active_30) as 'active_30', sum(is_canceled_87) as 'canceled_87', sum(is_canceled_30) as 'canceled_30'
from status
group by month)
select *
from status_aggregate;


8.

WITH months AS
(SELECT
  '2017-01-01' as first_day,
  '2017-01-31' as last_day
UNION
 Select
  '2017-02-01' as first_day,
  '2017-02-28' as last_day
Union
 Select
  '2017-03-01' as first_day,
  '2017-03-31' as last_day
),
cross_join AS
(SELECT *
FROM subscriptions
cross join months
),
status AS
(SELECT id, first_day as month,
CASE
  WHEN (segment = 87
  )
  		AND (subscription_start < first_day)
    AND (
      subscription_end > first_day
      OR subscription_end IS NULL
    ) THEN 1
  ELSE 0
END as is_active_87,
CASE
 WHEN (segment = 87) AND
  (subscription_end BETWEEN first_day AND last_day) THEN 1
  ELSE 0
END as is_canceled_87,
CASE 
	WHEN (segment = 30
  )
  		AND (subscription_start < first_day)
    AND (
      subscription_end > first_day
      OR subscription_end IS NULL
    ) THEN 1
  ELSE 0
END as is_active_30,
CASE
 WHEN (segment = 30) AND
  (subscription_end BETWEEN first_day AND last_day) THEN 1
  ELSE 0
END as is_canceled_30
From cross_join),
status_aggregate as (
select month, sum(is_active_87) as 'active_87', sum(is_active_30) as 'active_30', sum(is_canceled_87) as 'canceled_87', sum(is_canceled_30) as 'canceled_30'
from status
group by month)
select month,
 1.0 * canceled_30 / active_30 AS churn_rate_30,
 1.0 * canceled_87 / active_87 AS churn_rate_87 
from status_aggregate;