# Chinook Database Schema Documentation

**Analysis Date:** October 25, 2025  
**Analyst:** Pro-roxstar99  
**Database:** Chinook v1.4.5  
**MySQL Version:** 8.0.35

---

## Executive Summary

The Chinook database is a **digital music store database** containing 11 tables with comprehensive transactional and catalog data. The database models a complete e-commerce system for digital music sales, including customer management, product catalog, sales transactions, and employee tracking.

**Database Statistics:**
- **Total Tables:** 11
- **Total Records:** ~15,000+ across all tables
- **Database Size:** ~1.5 MB
- **Date Range:** Multi-year transaction history (2009-2013)
- **Geographic Coverage:** 24+ countries

---

## Table Inventory

### Row Counts by Table

| Table Name | Row Count | Category | Description |
|------------|-----------|----------|-------------|
| PlaylistTrack | 8,715 | Junction | Track-to-playlist mappings |
| Track | 3,503 | Product Catalog | Individual songs/music tracks |
| InvoiceLine | 2,240 | Transactions | Purchase line items |
| Invoice | 412 | Transactions | Customer purchase orders |
| Album | 347 | Product Catalog | Music albums |
| Artist | 275 | Product Catalog | Music artists/bands |
| Customer | 59 | Business Entity | Store customers |
| Genre | 25 | Reference Data | Music genres |
| Playlist | 18 | Feature | Curated music collections |
| Employee | 8 | Business Entity | Sales representatives |
| MediaType | 5 | Reference Data | File format types |

---

## Database Schema Overview

### Core Business Entities

#### 1. **Customer** (59 records)
- **Purpose:** Store customer information and contact details
- **Primary Key:** CustomerId (Auto-increment)
- **Key Columns:** FirstName, LastName, Email, Country, Phone, SupportRepId
- **Relationships:** 
  - → Invoice (1:Many) - Customers place multiple orders
  - → Employee (Many:1) - Assigned support representative

#### 2. **Employee** (8 records)
- **Purpose:** Sales representatives and support staff
- **Primary Key:** EmployeeId (Auto-increment)
- **Key Columns:** FirstName, LastName, Title, ReportsTo, HireDate
- **Relationships:**
  - → Customer (1:Many) - Employees support multiple customers
  - Self-referencing hierarchy (ReportsTo)

#### 3. **Invoice** (412 records)
- **Purpose:** Customer purchase transactions
- **Primary Key:** InvoiceId (Auto-increment)
- **Key Columns:** CustomerId, InvoiceDate, BillingCountry, Total
- **Relationships:**
  - → Customer (Many:1) - Each invoice belongs to one customer
  - → InvoiceLine (1:Many) - Each invoice has multiple line items

#### 4. **InvoiceLine** (2,240 records)
- **Purpose:** Individual line items for each purchase
- **Primary Key:** InvoiceLineId (Auto-increment)
- **Key Columns:** InvoiceId, TrackId, UnitPrice, Quantity
- **Relationships:**
  - → Invoice (Many:1) - Line items belong to one invoice
  - → Track (Many:1) - Each line item is one track

---

### Product Catalog

#### 5. **Artist** (275 records)
- **Purpose:** Music artists and bands
- **Primary Key:** ArtistId (Auto-increment)
- **Key Columns:** Name
- **Relationships:** → Album (1:Many)

#### 6. **Album** (347 records)
- **Purpose:** Music albums
- **Primary Key:** AlbumId (Auto-increment)
- **Key Columns:** Title, ArtistId
- **Relationships:** 
  - → Artist (Many:1)
  - → Track (1:Many)

#### 7. **Track** (3,503 records)
- **Purpose:** Individual songs/tracks available for purchase
- **Primary Key:** TrackId (Auto-increment)
- **Key Columns:** Name, AlbumId, GenreId, MediaTypeId, Milliseconds, Bytes, UnitPrice
- **Relationships:**
  - → Album (Many:1)
  - → Genre (Many:1)
  - → MediaType (Many:1)
  - → InvoiceLine (1:Many)
  - → PlaylistTrack (Many:Many via junction)

---

### Reference & Lookup Tables

#### 8. **Genre** (25 records)
- **Purpose:** Music genre classifications
- **Primary Key:** GenreId
- **Examples:** Rock, Jazz, Metal, Alternative, Classical, etc.

#### 9. **MediaType** (5 records)
- **Purpose:** Audio file format types
- **Primary Key:** MediaTypeId
- **Examples:** MPEG audio, AAC audio, Protected AAC, Purchased AAC

---

### Feature Tables

#### 10. **Playlist** (18 records)
- **Purpose:** Curated music collections
- **Primary Key:** PlaylistId
- **Relationships:** → PlaylistTrack (1:Many)

#### 11. **PlaylistTrack** (8,715 records)
- **Purpose:** Junction table for Many-to-Many relationship between Playlists and Tracks
- **Primary Key:** Composite (PlaylistId, TrackId)
- **Relationships:**
  - → Playlist (Many:1)
  - → Track (Many:1)

---

## Entity Relationship Diagram (ERD)

### Key Relationships
```
Customer (1) ────< Invoice (M)
    |
    └──< Employee (Support Rep)

Invoice (1) ────< InvoiceLine (M) >──── Track (1)

Artist (1) ────< Album (M) ────< Track (M)

Track (M) >──── Genre (1)
Track (M) >──── MediaType (1)

Playlist (M) ────< PlaylistTrack >──── Track (M)
```

### Foreign Key Relationships Summary

**Total Foreign Keys:** 10

| Child Table | Child Column | Parent Table | Parent Column | Relationship |
|-------------|--------------|--------------|---------------|--------------|
| Album | ArtistId | Artist | ArtistId | Many-to-One |
| Customer | SupportRepId | Employee | EmployeeId | Many-to-One |
| Employee | ReportsTo | Employee | EmployeeId | Self-referencing |
| Invoice | CustomerId | Customer | CustomerId | Many-to-One |
| InvoiceLine | InvoiceId | Invoice | InvoiceId | Many-to-One |
| InvoiceLine | TrackId | Track | TrackId | Many-to-One |
| PlaylistTrack | PlaylistId | Playlist | PlaylistId | Many-to-Many |
| PlaylistTrack | TrackId | Track | TrackId | Many-to-Many |
| Track | AlbumId | Album | AlbumId | Many-to-One |
| Track | GenreId | Genre | GenreId | Many-to-One |
| Track | MediaTypeId | MediaType | MediaTypeId | Many-to-One |

---

## Data Quality Assessment

### Referential Integrity Checks

✅ **All foreign key relationships are valid** - No orphaned records found:
- Invoices without valid CustomerId: **0**
- InvoiceLines without valid InvoiceId: **0**
- Tracks without valid AlbumId: **0**

### Data Completeness

- **No NULL issues** in critical fields (CustomerId, InvoiceId, TrackId)
- All transactions have valid references
- Employee hierarchy is properly maintained

---

## Key Insights for Analysis

### 1. **Customer Base**
- 59 customers across 24+ countries
- Each customer can have multiple invoices
- Customers are assigned to support representatives

### 2. **Product Catalog**
- 3,503 tracks available for purchase
- 275 unique artists
- 347 albums
- 25 different genres

### 3. **Transaction Volume**
- 412 invoices (orders)
- 2,240 line items purchased
- Average ~5.4 items per invoice

### 4. **Employee Structure**
- 8 employees with hierarchical reporting structure
- Employees serve as customer support representatives

---

## Analytical Opportunities

Based on this schema, we can perform:

1. **Revenue Analysis**
   - Total revenue, trends over time
   - Revenue by country, genre, artist
   
2. **Customer Segmentation**
   - RFM analysis (Recency, Frequency, Monetary)
   - Customer lifetime value
   - Geographic distribution
   
3. **Product Performance**
   - Top-selling tracks, albums, artists
   - Genre popularity analysis
   - Price optimization opportunities
   
4. **Sales Team Analysis**
   - Employee performance metrics
   - Customer satisfaction by support rep
   
5. **Cohort Analysis**
   - Customer retention over time
   - Purchase behavior patterns

---

## Technical Notes

- **Auto-increment PKs:** All tables use auto-increment primary keys
- **Data Types:** Appropriate use of INT, VARCHAR, DECIMAL, DATETIME
- **Indexing:** Primary keys and foreign keys are properly indexed
- **Normalization:** Database is well-normalized (3NF)
- **No NULLs:** Critical foreign keys are NOT NULL (enforced integrity)

---

## Next Steps

1. ✅ Schema analysis complete
2. 🔄 Proceed to Story 1.2: Data Profiling & Quality Assessment
3. 🔄 Proceed to Story 1.3: Create Analytical Base Views

---

**Documentation Status:** ✅ Complete  
**Last Updated:** October 25, 2025
