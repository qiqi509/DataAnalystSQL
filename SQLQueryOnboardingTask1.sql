

--Onboarding Task 1

SELECT op.PropertyId, op.OwnerId,  p.name, pf.CurrentHomeValue, pf.yield AS Yield, 
	tp.PaymentFrequencyId, trt.Name AS PaymentFrequency, tp.PaymentAmount,
	SUM (CASE
		WHEN rp.FrequencyType = 3 THEN rp.Amount * DATEDIFF(month,tp.StartDate, tp.EndDate +1)
		WHEN rp.FrequencyType = 1 THEN rp.Amount * DATEDIFF(week, tp.StartDate, tp.EndDate) 
		WHEN rp.FrequencyType = 2 THEN rp.Amount * (DATEDIFF(week, tp.StartDate, tp.EndDate)) /2
		ELSE NULL
	END) AS [TotalPayment], 
	per.FirstName, per.LastName, tp.StartDate, tp.EndDate

FROM [dbo].[Property] p
	INNER JOIN OwnerProperty op ON p.id = op.PropertyId
	INNER JOIN PropertyFinance pf ON op.PropertyId = pf.PropertyId
	INNER JOIN PropertyRentalPayment rp ON p.Id = rp.PropertyId
	INNER JOIN TenantProperty tp ON p.Id = tp.PropertyId 
	INNER JOIN TenantPaymentFrequencies tf ON rp.FrequencyType = tf.Id
	INNER JOIN Tenant t on t.Id = tp.TenantId
	INNER JOIN Person per ON per.Id = tp.TenantId
	INNER JOIN TargetRentType trt ON trt.Id = tp.PaymentFrequencyId
	
WHERE op.OwnerId = 1426 AND p.IsActive=1

GROUP BY p.Id, p.name, pf.CurrentHomeValue, op.PropertyId, op.OwnerId,
tp.PaymentFrequencyId, trt.Name,tp.PaymentAmount, pf.Yield, tp.StartDate, tp.EndDate, per.FirstName, per.LastName






