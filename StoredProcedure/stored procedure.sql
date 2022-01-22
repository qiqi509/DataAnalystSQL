CREATE PROCEDURE [dbo].[spGeoDistance]
(
@subCity varchar(50),
@distance INT
)
AS
	BEGIN
		SET NOCOUNT ON 
		DECLARE @subGeo GEOGRAPHY, @subLat DECIMAL(9, 6), @subLong DECIMAL(9, 6);

		SELECT @subLat = [Lat],
				@subLong = [Lon]
		FROM [dbo].[DimGeography](NOLOCK)
		WHERE [Suburb] + '/' [City] = @subCity;

		SET @subGeo = geography::Point(@subLat, @subLong, 4326);

		SELECT [StopName],
				[Mode],
				ROUND((@subGeo.STDistance(geography::Point([StopLat], [StopLon], 4326)) / 1000), 2) AS [Distance (km)]
		FROM [dbo].[DimTransport](NOLOCK)
		WHERE(@subGeo.STDistance(geography::Point([StopLat], [StopLon], 4326)) / 1000) <= @distance
		ORDER BY [Distance (km)];
	END;
GO

