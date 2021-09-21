
SELECT DISTINCT op.id, property.id AS 'Property Id', property.Name, 
	property.Bedroom, property.Bathroom,pe.Description AS expense,
	ad.Number, ad.Street,
	 pe.Amount, tpf.Code AS PaymentFrequency,
	FORMAT(pe.Date, 'dd MMM yyyy') as Date, p.FirstName AS CurrentOwner

 FROM OwnerProperty op
	JOIN Property property ON property.Id = op.PropertyId
	JOIN Person p ON p.Id = op.OwnerId
	JOIN PropertyExpense pe ON pe.PropertyId = property.Id
	JOIN TenantProperty tp ON tp.PropertyId = property.Id
	JOIN TenantPaymentFrequencies tpf ON tpf.Id = tp.PaymentFrequencyId
	JOIN Address ad ON ad.AddressId = property.AddressId

WHERE property.Name = 'Property A'