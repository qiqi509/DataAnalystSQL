

--Onboarding Task 1

SELECT p.name, pf.CurrentHomeValue, pf.yield AS Yield, 
	tp.PaymentFrequencyId, trt.Name AS PaymentFrequency, tp.PaymentAmount,
	SUM(CASE
		WHEN rp.FrequencyType = 3 THEN rp.Amount * (
			DATEDIFF(MONTH, tp.StartDate, tp.EndDate) -
			(DATEPART(dd,tp.StartDate) - 1) / DATEDIFF(DAY, tp.StartDate, DATEADD(MONTH, 1, tp.StartDate)) +
			(DATEPART(dd,tp.EndDate) * 1) / DATEDIFF(DAY, tp.EndDate, DATEADD(MONTH, 1, tp.EndDate)))
		WHEN rp.FrequencyType = 1 THEN rp.Amount * DATEDIFF(week, tp.StartDate, tp.EndDate) 
		WHEN rp.FrequencyType = 2 THEN rp.Amount * (DATEDIFF(week, tp.StartDate, tp.EndDate)) / 2
	END) AS [TotalPayment], 
	COUNT(js.Status) AS JobAvailable,
	per.FirstName, per.LastName, tp.StartDate, tp.EndDate

FROM [dbo].[Property] p
	JOIN OwnerProperty op ON p.id = op.PropertyId
	JOIN PropertyFinance pf ON op.PropertyId = pf.PropertyId
	JOIN PropertyRentalPayment rp ON p.Id = rp.PropertyId
	JOIN TenantProperty tp ON p.Id = tp.PropertyId 
	JOIN TenantPaymentFrequencies tf ON rp.FrequencyType = tf.Id
	JOIN Tenant t on t.Id = tp.TenantId
	JOIN Person per ON per.Id = tp.TenantId
	JOIN TargetRentType trt ON trt.Id = tp.PaymentFrequencyId
	LEFT JOIN job j ON p.id = j.PropertyId AND (j.JobStartDate > tp.StartDate AND j.JobEndDate < tp.EndDate)
	LEFT JOIN JobMedia jm ON J.Id = jm.PropertyId AND jm.IsActive = 1
	LEFT JOIN JobStatus js ON j.JobStatusId = js.id AND js.Status = 'Open' 

WHERE op.OwnerId = 1426 AND p.IsActive=1

GROUP BY p.Id, p.name, pf.CurrentHomeValue, 
	tp.PaymentFrequencyId, trt.Name,tp.PaymentAmount, pf.Yield, 
	tp.StartDate, tp.EndDate, per.FirstName, per.LastName
