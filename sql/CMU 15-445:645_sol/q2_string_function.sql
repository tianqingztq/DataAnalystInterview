--  Get all unique ShipNames from the Order table that contain a hyphen

--  Detail: In addition, get all the characters preceding the (first) hyphen
--  Return ship names alphabetically. Your first row should look like this
--  Bottom-Dollar Markets|Bottom

SELECT DISTINCT ShipName, substr(ShipName, 0, instr(ShipName, '-')) as PreHyphen
FROM 'Order'
WHERE ShipName LIKE '%-%'
ORDER BY ShipName ASC;

-- Answer: 
-- Bottom-Dollar Markets|Bottom
-- Chop-suey Chinese|Chop
-- GROSELLA-Restaurante|GROSELLA
-- HILARION-Abastos|HILARION
-- Hungry Owl All-Night Grocers|Hungry Owl All
-- LILA-Supermercado|LILA
-- LINO-Delicateses|LINO
-- QUICK-Stop|QUICK
-- Save-a-lot Markets|Save
