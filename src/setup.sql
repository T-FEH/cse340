-- Create the organization table
CREATE TABLE organization (
    organization_id SERIAL,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    logo_filename VARCHAR(255) NOT NULL,
    CONSTRAINT organization_pkey PRIMARY KEY (organization_id)
);

-- Insert sample organizations
INSERT INTO organization (name, description, contact_email, logo_filename)
VALUES
    ('BrightFuture Builders', 'A nonprofit focused on improving community infrastructure through sustainable construction projects.', 'info@brightfuturebuilders.org', 'brightfuture-logo.png'),
    ('GreenHarvest Growers', 'An urban farming collective promoting food sustainability and education in local neighborhoods.', 'contact@greenharvest.org', 'greenharvest-logo.png'),
    ('UnityServe Volunteers', 'A volunteer coordination group supporting local charities and service initiatives.', 'hello@unityserve.org', 'unityserve-logo.png');

-- Create the service_project table
CREATE TABLE service_project (
    service_project_id SERIAL,
    organization_id INTEGER NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    date DATE NOT NULL,
    location VARCHAR(255) NOT NULL,
    CONSTRAINT service_project_pkey PRIMARY KEY (service_project_id),
    CONSTRAINT service_project_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES organization(organization_id)
);

-- Insert sample service projects, each associated with its sponsoring organization
-- Dates are a mix of past and future so upcoming-project filtering can be tested
INSERT INTO service_project (organization_id, name, description, date, location)
VALUES
    ((SELECT organization_id FROM organization WHERE name = 'BrightFuture Builders'), 'Park Cleanup', 'Join us to clean up local parks and make them beautiful!', '2026-08-01', 'Riverside Park'),
    ((SELECT organization_id FROM organization WHERE name = 'GreenHarvest Growers'), 'Food Drive', 'Help collect and distribute food to those in need.', '2026-08-15', 'Downtown Community Center'),
    ((SELECT organization_id FROM organization WHERE name = 'UnityServe Volunteers'), 'Community Tutoring', 'Volunteer to tutor students in various subjects.', '2026-09-01', 'Lincoln Elementary School'),
    ((SELECT organization_id FROM organization WHERE name = 'UnityServe Volunteers'), 'Winter Coat Drive', 'Collected warm coats for families in need during the winter months.', '2026-06-01', 'Downtown Community Center'),
    ((SELECT organization_id FROM organization WHERE name = 'BrightFuture Builders'), 'Trail Restoration', 'Help restore and maintain local hiking trails for public use.', '2026-08-20', 'Maple Ridge Trail'),
    ((SELECT organization_id FROM organization WHERE name = 'GreenHarvest Growers'), 'Community Health Fair', 'Free health screenings and wellness resources for the community.', '2026-09-10', 'Town Square'),
    ((SELECT organization_id FROM organization WHERE name = 'BrightFuture Builders'), 'Beach Cleanup Day', 'Join us to clear litter and debris from the local beach.', '2026-09-20', 'Sunset Beach'),
    ((SELECT organization_id FROM organization WHERE name = 'BrightFuture Builders'), 'Playground Renovation', 'Help renovate and rebuild the playground equipment at Willow Creek Park for local families.', '2026-10-05', 'Willow Creek Park'),
    ((SELECT organization_id FROM organization WHERE name = 'BrightFuture Builders'), 'Bridge Repair Initiative', 'Assist with repairs and safety upgrades to the historic Old Mill pedestrian bridge.', '2026-10-15', 'Old Mill Bridge'),
    ((SELECT organization_id FROM organization WHERE name = 'GreenHarvest Growers'), 'Community Garden Planting', 'Plant vegetables and herbs in the community garden to support local food banks.', '2026-09-25', 'Elm Street Garden'),
    ((SELECT organization_id FROM organization WHERE name = 'GreenHarvest Growers'), 'Farmers Market Support', 'Help set up and run the weekly farmers market booth promoting local produce.', '2026-10-01', 'Downtown Market Square'),
    ((SELECT organization_id FROM organization WHERE name = 'GreenHarvest Growers'), 'Composting Workshop', 'Learn and teach sustainable composting techniques for home gardens.', '2026-10-08', 'GreenHarvest Farm'),
    ((SELECT organization_id FROM organization WHERE name = 'UnityServe Volunteers'), 'Senior Center Visits', 'Spend time with residents at the senior center through games and conversation.', '2026-09-18', 'Sunrise Senior Center'),
    ((SELECT organization_id FROM organization WHERE name = 'UnityServe Volunteers'), 'Clothing Donation Drive', 'Collect and sort donated clothing for distribution to families in need.', '2026-09-22', 'UnityServe HQ'),
    ((SELECT organization_id FROM organization WHERE name = 'UnityServe Volunteers'), 'Youth Mentorship Program', 'Mentor young students through after-school academic and life-skills support.', '2026-10-12', 'Lincoln Elementary School');

-- Create the category table
CREATE TABLE category (
    category_id SERIAL,
    name VARCHAR(100) NOT NULL,
    CONSTRAINT category_pkey PRIMARY KEY (category_id),
    CONSTRAINT category_name_key UNIQUE (name)
);

-- Insert sample categories
INSERT INTO category (name)
VALUES
    ('Environmental'),
    ('Educational'),
    ('Community Service'),
    ('Health and Wellness');

-- Create the project_category join table to model the many-to-many
-- relationship between service_project and category
CREATE TABLE project_category (
    service_project_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    CONSTRAINT project_category_pkey PRIMARY KEY (service_project_id, category_id),
    CONSTRAINT project_category_service_project_id_fkey FOREIGN KEY (service_project_id) REFERENCES service_project(service_project_id) ON DELETE CASCADE,
    CONSTRAINT project_category_category_id_fkey FOREIGN KEY (category_id) REFERENCES category(category_id) ON DELETE CASCADE
);

-- Associate each service project with one or more categories
INSERT INTO project_category (service_project_id, category_id)
VALUES
    ((SELECT service_project_id FROM service_project WHERE name = 'Park Cleanup'), (SELECT category_id FROM category WHERE name = 'Environmental')),
    ((SELECT service_project_id FROM service_project WHERE name = 'Park Cleanup'), (SELECT category_id FROM category WHERE name = 'Community Service')),
    ((SELECT service_project_id FROM service_project WHERE name = 'Food Drive'), (SELECT category_id FROM category WHERE name = 'Community Service')),
    ((SELECT service_project_id FROM service_project WHERE name = 'Food Drive'), (SELECT category_id FROM category WHERE name = 'Health and Wellness')),
    ((SELECT service_project_id FROM service_project WHERE name = 'Community Tutoring'), (SELECT category_id FROM category WHERE name = 'Educational')),
    ((SELECT service_project_id FROM service_project WHERE name = 'Winter Coat Drive'), (SELECT category_id FROM category WHERE name = 'Community Service')),
    ((SELECT service_project_id FROM service_project WHERE name = 'Trail Restoration'), (SELECT category_id FROM category WHERE name = 'Environmental')),
    ((SELECT service_project_id FROM service_project WHERE name = 'Community Health Fair'), (SELECT category_id FROM category WHERE name = 'Health and Wellness')),
    ((SELECT service_project_id FROM service_project WHERE name = 'Beach Cleanup Day'), (SELECT category_id FROM category WHERE name = 'Environmental')),
    ((SELECT service_project_id FROM service_project WHERE name = 'Playground Renovation'), (SELECT category_id FROM category WHERE name = 'Community Service')),
    ((SELECT service_project_id FROM service_project WHERE name = 'Bridge Repair Initiative'), (SELECT category_id FROM category WHERE name = 'Community Service')),
    ((SELECT service_project_id FROM service_project WHERE name = 'Bridge Repair Initiative'), (SELECT category_id FROM category WHERE name = 'Environmental')),
    ((SELECT service_project_id FROM service_project WHERE name = 'Community Garden Planting'), (SELECT category_id FROM category WHERE name = 'Environmental')),
    ((SELECT service_project_id FROM service_project WHERE name = 'Farmers Market Support'), (SELECT category_id FROM category WHERE name = 'Community Service')),
    ((SELECT service_project_id FROM service_project WHERE name = 'Composting Workshop'), (SELECT category_id FROM category WHERE name = 'Environmental')),
    ((SELECT service_project_id FROM service_project WHERE name = 'Composting Workshop'), (SELECT category_id FROM category WHERE name = 'Educational')),
    ((SELECT service_project_id FROM service_project WHERE name = 'Senior Center Visits'), (SELECT category_id FROM category WHERE name = 'Community Service')),
    ((SELECT service_project_id FROM service_project WHERE name = 'Senior Center Visits'), (SELECT category_id FROM category WHERE name = 'Health and Wellness')),
    ((SELECT service_project_id FROM service_project WHERE name = 'Clothing Donation Drive'), (SELECT category_id FROM category WHERE name = 'Community Service')),
    ((SELECT service_project_id FROM service_project WHERE name = 'Youth Mentorship Program'), (SELECT category_id FROM category WHERE name = 'Educational'));
