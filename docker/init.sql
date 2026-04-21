-- Init SQL for Tonthep Duy Bao CRM
-- Creates roles, branches, and admin users
-- Password for all accounts: admin123

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create unaccent function (for Vietnamese search)
CREATE OR REPLACE FUNCTION unaccent(text)
RETURNS text AS $$
BEGIN
    RETURN lower(translate($1,
        'ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÝÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýýÿþ',
        'AAAAAAACEEEEIIIIDNOOOOOUUUUYYYYBaaaaaaaceeeeiiiidnooooouuuuyyyb'));
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Insert roles
INSERT INTO ttdb_role (id, name) VALUES 
    ('ADMIN', 'Quản trị viên'),
    ('MANAGER', 'Quản lý'),
    ('STAFF', 'Nhân viên')
ON CONFLICT (id) DO NOTHING;

-- Insert default branch (HQ)
INSERT INTO ttdb_branch (id, name, address, phone, manager, status, created_at, updated_at, map_embed_url, map_url, zalo)
VALUES 
    (1, 'Trụ sở chính', '123 Đường ABC, Quận XYZ, TP.HCM', '0123456789', 'ADMIN', 'ACTIVE', '20240421120000', '20240421120000', NULL, NULL, NULL)
ON CONFLICT (id) DO NOTHING;

-- Insert 3 admin users (password: admin123 -> MD5)
-- MD5 hash of "admin123" = 482c01101a19cb8e92949c2122e054c2
INSERT INTO ttdb_user (id, username, password, full_name, email, phone, address, status, role_id, branch_id, created_at, updated_at, created_by, updated_by, deleted, avatar)
VALUES
    (1, 'admin', '0192023a7bbd73250516f069df18b500', 'Admin 1', 'admin1@cty.com', '0123456789', '123 ABC, Ho Chi Minh', 'ACTIVE', 'ADMIN', 1, '20240421120000', '20240421120000', NULL, NULL, false, NULL),
    (2, 'admin2', '0192023a7bbd73250516f069df18b500', 'Admin 2', 'admin2@cty.com', '0123456790', '456 DEF, Ho Chi Minh', 'ACTIVE', 'ADMIN', 1, '20240421120000', '20240421120000', NULL, NULL, false, NULL),
    (3, 'manager', '0192023a7bbd73250516f069df18b500', 'Manager', 'manager@cty.com', '0123456791', '789 GHI, Ho Chi Minh', 'ACTIVE', 'ADMIN', 1, '20240421120000', '20240421120000', NULL, NULL, false, NULL)
ON CONFLICT (id) DO NOTHING;