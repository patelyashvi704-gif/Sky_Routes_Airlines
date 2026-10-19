-- 1. Top 10 most frequent routes based on number of flights
SELECT 
    RouteCode, 
    COUNT(FlightID) AS TotalFlights
FROM AirlineRoutesData
GROUP BY RouteCode
ORDER BY TotalFlights DESC
LIMIT 10;

-- 2. Average revenue, cost, and profit per route
SELECT 
    RouteCode,
    ROUND(AVG(Revenue), 2) AS AvgRevenue,
    ROUND(AVG(OperationalCost), 2) AS AvgCost,
    ROUND(AVG(Revenue - OperationalCost), 2) AS AvgProfit
FROM AirlineRoutesData
GROUP BY RouteCode;

-- 3. Identify underperforming routes where average profit is negative
SELECT 
    RouteCode,
    ROUND(AVG(Revenue - OperationalCost), 2) AS AvgProfit
FROM AirlineRoutesData
GROUP BY RouteCode
HAVING AvgProfit < 0
ORDER BY AvgProfit ASC;

-- 4. Calculate seat occupancy % for each route
SELECT 
    RouteCode,
    ROUND((SUM(SeatsSold) * 100.0) / SUM(SeatsAvailable), 2) AS OccupancyPercentage
FROM AirlineRoutesData
GROUP BY RouteCode;

-- 5. Extract monthly trend of profit per route
SELECT 
    RouteCode,
    SUBSTR(FlightDate, 1, 7) AS FlightMonth,
    ROUND(SUM(Revenue - OperationalCost), 2) AS TotalMonthlyProfit
FROM AirlineRoutesData
GROUP BY RouteCode, FlightMonth;

-- 6. Compare profitability of domestic vs international routes
SELECT 
    CASE 
        WHEN Origin IN ('BOM', 'DEL', 'BLR', 'MAA', 'CCU') 
         AND Destination IN ('BOM', 'DEL', 'BLR', 'MAA', 'CCU') THEN 'Domestic'
        ELSE 'International'
    END AS RouteType,
    ROUND(AVG(Revenue - OperationalCost), 2) AS AvgProfit,
    ROUND(SUM(Revenue - OperationalCost), 2) AS TotalProfit
FROM AirlineRoutesData
GROUP BY RouteType;

-- 7. Rank routes based on revenue per minute of flight duration
SELECT 
    RouteCode,
    ROUND(SUM(Revenue) / SUM(FlightDurationMins), 2) AS RevenuePerMinute,
    DENSE_RANK() OVER (ORDER BY SUM(Revenue) / SUM(FlightDurationMins) DESC) AS RevenueRank
FROM AirlineRoutesData
GROUP BY RouteCode;