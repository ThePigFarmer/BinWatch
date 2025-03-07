SELECT id, weight, timestamp
FROM bin_weights
WHERE timestamp IN (
    SELECT MAX(timestamp)
    FROM bin_weights
    GROUP BY id
);
