select team_id, team_name, COALESCE(sum(num_points), 0) as num_points
from
(select team_id, team_name, sum(m.host_goals) as num_points from
teams
left join(
select host_team,
case 
  when host_goals > guest_goals then 3
  when host_goals = guest_goals then 1
  else 0
 end as host_goals
 from matches) m on team_id=m.host_team
 group by team_id, team_name
 UNION
 select team_id, team_name, sum(m.guest_goals) as num_points from
teams
left join(
select guest_team,
 case 
  when guest_goals > host_goals then 3
  when guest_goals = host_goals then 1
  else 0
 end as guest_goals
 from matches) m on team_id=m.guest_team
 group by team_id, team_name
) as res
 group by team_id, team_name
 order by num_points desc, team_id asc
