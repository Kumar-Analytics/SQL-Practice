--5)
Select top 10000 a.advertiser_id,
max(distinct a.impressions) as MaxImpressionRanges,
Sum(b.total_creatives) as CreativeTotal, 
SUM(b.spend_usd) as Total_SpendUSD, 
SUM(cast(b.total_creatives as float))/Sum(cast(b.spend_usd as float))*100 as CreativePercentage 
From creative_stats a
join advertiser_stats1 b
on a.advertiser_id = b.advertiser_id
    where b.regions = 'US'
    and b.spend_usd <> 0 
group by a.advertiser_id
order by 1;

--6)
Select top 10000 a.advertiser_id,
max(distinct a.impressions) as MaxImpressionRanges,
Sum(b.total_creatives) as CreativeTotal, 
SUM(b.Foreign_Spend) as Total_Spend, 
SUM(cast(b.total_creatives as float))/Sum(cast(b.Foreign_Spend as float))*100 as CreativePercentage 
From creative_stats a
join advertiser_stats1 b
on a.advertiser_id = b.advertiser_id
    where b.regions <> 'US'
    and b.Foreign_Spend <> 0 
group by a.advertiser_id
order by 1;

--7)
select top 10000 a.advertiser_id, 
b.advertiser_name, 
a.ad_type, a.impressions,
a.date_range_start, 
a.spend_range_max_usd,
Sum(a.spend_range_max_usd) OVER 
    (partition by a.advertiser_id order by a.advertiser_name rows 
        between unbounded preceding and current row) 
    as Spend_by_Ad,
b.regions, b.public_ids_list
from creative_stats a 
join advertiser_stats1 b 
on a.advertiser_id = b.advertiser_id
where b.regions = 'US'
order by a.advertiser_id, Spend_By_Ad;

--8)
select top 10000 a.advertiser_id, 
b.advertiser_name, 
a.ad_type, a.impressions, 
a.date_range_start,
b.regions, 
b.Foreign_Spend
from creative_stats a 
join advertiser_stats1 b 
on a.advertiser_id = b.advertiser_id
where b.regions <> 'US'
order by a.advertiser_id