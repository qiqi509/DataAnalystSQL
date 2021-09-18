
SELECT Property.Name, CAST(Property.Bedroom AS varchar(10)) + ' Besdrooms' + ', '  + CAST(property.Bathroom AS varchar (10)) + ' Bathrooms'  AS Propertydetails,
pr.Amount AS Rentalpayment,ad.Number+ad.Street AS Propertyaddress,pe.Amount AS Expense,pe.Date, p.FirstName AS CurrentOwner
FROM [dbo].[Property]
JOIN PropertyRentalPayment pr ON Property.Id = pr.PropertyId
JOIN PropertyExpense pe ON Property.Id = pe.PropertyId
JOIN OwnerProperty op ON Property.Id = op.PropertyId
JOIN Person p ON p.Id = op.OwnerId
JOIN Address ad ON Property.AddressId = ad.AddressId
WHERE Property.Name = 'property A'
