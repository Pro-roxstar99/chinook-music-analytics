-- ============================================
-- STORY 1.1: SCHEMA ANALYSIS & EXPLORATION
-- Epic: Foundation & Exploration
-- Author: Pro-roxstar99
-- Date: 2025-10-25
-- GitHub Issue: #1
-- Purpose: Comprehensive analysis of Chinook database schema
-- ============================================

USE Chinook;

-- ============================================
-- TASK 1: DATABASE OVERVIEW
-- ============================================

SELECT 
    'DATABASE OVERVIEW' as analysis_section,
    DATABASE() as database_name,
    VERSION() as mysql_version,
    NOW() as analysis_timestamp;

SELECT 
    'Total Tables' as metric,
    COUNT(*) as value
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'Chinook';


-- ============================================
-- TASK 2: TABLE INVENTORY WITH METADATA
-- ============================================

SELECT 
    TABLE_NAME as table_name,
    TABLE_ROWS as estimated_rows,
    ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2) as size_mb,
    ROUND(DATA_LENGTH / 1024 / 1024, 2) as data_mb,
    ROUND(INDEX_LENGTH / 1024 / 1024, 2) as index_mb
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'Chinook'
ORDER BY TABLE_ROWS DESC;


-- ============================================
-- TASK 3: EXACT ROW COUNTS
-- ============================================

SELECT 'Album' as table_name, COUNT(*) as row_count FROM Album
UNION ALL SELECT 'Artist', COUNT(*) FROM Artist
UNION ALL SELECT 'Customer', COUNT(*) FROM Customer
UNION ALL SELECT 'Employee', COUNT(*) FROM Employee
UNION ALL SELECT 'Genre', COUNT(*) FROM Genre
UNION ALL SELECT 'Invoice', COUNT(*) FROM Invoice
UNION ALL SELECT 'InvoiceLine', COUNT(*) FROM InvoiceLine
UNION ALL SELECT 'MediaType', COUNT(*) FROM MediaType
UNION ALL SELECT 'Playlist', COUNT(*) FROM Playlist
UNION ALL SELECT 'PlaylistTrack', COUNT(*) FROM PlaylistTrack
UNION ALL SELECT 'Track', COUNT(*) FROM Track
ORDER BY row_count DESC;


-- ============================================
-- TASK 4: DETAILED COLUMN INFORMATION
-- ============================================

SELECT 
    TABLE_NAME as table_name,
    COLUMN_NAME as column_name,
    DATA_TYPE as data_type,
    IS_NULLABLE as nullable,
    COLUMN_KEY as key_type,
    EXTRA as extra_info
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'Chinook'
ORDER BY TABLE_NAME, ORDINAL_POSITION;


-- ============================================
-- TASK 5: PRIMARY KEY ANALYSIS
-- ============================================

SELECT 
    TABLE_NAME as table_name,
    COLUMN_NAME as primary_key_column
FROM information_schema.KEY_COLUMN_USAGE
WHERE 
    TABLE_SCHEMA = 'Chinook'
    AND CONSTRAINT_NAME = 'PRIMARY'
ORDER BY TABLE_NAME;


-- ============================================
-- TASK 6: FOREIGN KEY RELATIONSHIPS
-- ============================================

SELECT 
    CONSTRAINT_NAME as fk_constraint,
    TABLE_NAME as child_table,
    COLUMN_NAME as child_column,
    REFERENCED_TABLE_NAME as parent_table,
    REFERENCED_COLUMN_NAME as parent_column
FROM information_schema.KEY_COLUMN_USAGE
WHERE 
    TABLE_SCHEMA = 'Chinook'
    AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME, COLUMN_NAME;


-- ============================================
-- TASK 7: SAMPLE DATA EXPLORATION
-- ============================================

-- Customer samples
SELECT * FROM Customer LIMIT 3;

-- Invoice samples
SELECT * FROM Invoice LIMIT 3;

-- Track samples with full context
SELECT 
    t.TrackId,
    t.Name as TrackName,
    a.Title as AlbumTitle,
    ar.Name as ArtistName,
    g.Name as Genre,
    t.UnitPrice
FROM Track t
JOIN Album a ON t.AlbumId = a.AlbumId
JOIN Artist ar ON a.ArtistId = ar.ArtistId
JOIN Genre g ON t.GenreId = g.GenreId
LIMIT 5;


-- ============================================
-- TASK 8: DATA QUALITY CHECKS
-- ============================================

-- Check for orphaned invoice records
SELECT 
    'Invoices without valid CustomerId' as check_name,
    COUNT(*) as issue_count
FROM Invoice i
LEFT JOIN Customer c ON i.CustomerId = c.CustomerId
WHERE c.CustomerId IS NULL;

-- Check for orphaned invoice lines
SELECT 
    'InvoiceLines without valid InvoiceId' as check_name,
    COUNT(*) as issue_count
FROM InvoiceLine il
LEFT JOIN Invoice i ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceId IS NULL;


-- ============================================
-- END OF SCHEMA ANALYSIS
-- ============================================

SELECT 
    'Schema Analysis Complete' as status,
    NOW() as completed_at;
```

6. **Scroll down** to "Commit new file"

7. **Commit message:** `feat(epic1): Add schema analysis SQL for Story 1.1`

8. **Extended description:**
```
- Comprehensive schema exploration queries
- Table metadata and relationships analysis
- Sample data extraction
- Data quality checks

Closes #1
