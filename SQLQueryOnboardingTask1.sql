

--Onboarding Task 1

SELECT p.Id, p.name, pf.CurrentHomeValue, pf.yield AS Yield,
SUM(CASE
	WHEN rp.FrequencyType = 3 THEN rp.Amount * (
		DATEDIFF(MONTH, tp.StartDate, tp.EndDate) -
		(DATEPART(dd,tp.StartDate) - 1) / DATEDIFF(DAY, tp.StartDate, DATEADD(MONTH, 1, tp.StartDate)) +
		(DATEPART(dd,tp.EndDate) * 1) / DATEDIFF(DAY, tp.EndDate, DATEADD(MONTH, 1, tp.EndDate)))
	WHEN rp.FrequencyType = 1 THEN rp.Amount * DATEDIFF(week, tp.StartDate, tp.EndDate) 
	WHEN rp.FrequencyType = 2 THEN rp.Amount * (DATEDIFF(week, tp.StartDate, tp.EndDate)) / 2
END) AS [TotalPayment], 
COUNT(js.Status) AS JobAvailable, per.FirstName, per.LastName, tp.StartDate, tp.EndDate

FROM [dbo].[Property] p
JOIN OwnerProperty op ON p.id = op.PropertyId and op.OwnerId = 1426
JOIN PropertyFinance pf ON op.PropertyId = pf.PropertyId
JOIN PropertyRentalPayment rp ON p.Id = rp.PropertyId
JOIN TenantProperty tp ON p.Id = tp.PropertyId
JOIN TenantPaymentFrequencies tf ON rp.FrequencyType = tf.Id
JOIN Person per ON per.Id = op.OwnerId
LEFT JOIN job j ON p.id = j.PropertyId AND (j.JobStartDate > tp.StartDate AND j.JobEndDate < tp.EndDate)
LEFT JOIN JobStatus js ON j.JobStatusId = js.id AND js.Status = 'Open'

WHERE p.IsActive=1
GROUP BY p.Id, p.name, pf.CurrentHomeValue, pf.Yield, tp.StartDate, tp.EndDate, per.FirstName, per.LastName




