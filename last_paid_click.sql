with tab as (
	select
		s.visitor_id,
		max(s.visit_date) as max_visit_date,
		count(s.visitor_id),
		l.lead_id,
		l.created_at,
		l.amount,
		l.closing_reason,
		l.status_id 
	from sessions s 
	left join leads l on s.visitor_id = l.visitor_id 
	where medium in ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg')
		and (s.visit_date < l.created_at or l.created_at is null)
	group by
		s.visitor_id,
		l.lead_id,
		l.created_at,
		l.amount,
		l.closing_reason,
		l.status_id  
), tab2 as (
	select
		s.visitor_id,
		s.visit_date,
		"source"as utm_source,
		medium as utm_medium,
		campaign as utm_campaign,
		tab.lead_id,
		tab.created_at,
		tab.amount,
		tab.closing_reason,
		tab.status_id
	from sessions s
	inner join tab on s.visitor_id = tab.visitor_id
	where visit_date = tab.max_visit_date
	group by
		s.visitor_id,
		s.visit_date,
		tab.max_visit_date,
		"source",
		medium,
		campaign,
		tab.lead_id,
		tab.created_at,
		tab.amount,
		tab.closing_reason,
		tab.status_id
	order by
		s.visit_date,
		"source",
		medium,
		campaign
)
select * from tab2
