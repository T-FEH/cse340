-- Create the organization table
CREATE TABLE organization (
    organization_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    logo_filename VARCHAR(255) NOT NULL
);

-- Insert sample organizations
INSERT INTO organization (name, description, contact_email, logo_filename)
VALUES
    ('BrightFuture Builders', 'A nonprofit focused on improving community infrastructure through sustainable construction projects.', 'info@brightfuturebuilders.org', 'brightfuture-logo.png'),
    ('GreenHarvest Growers', 'An urban farming collective promoting food sustainability and education in local neighborhoods.', 'contact@greenharvest.org', 'greenharvest-logo.png'),
    ('UnityServe Volunteers', 'A volunteer coordination group supporting local charities and service initiatives.', 'hello@unityserve.org', 'unityserve-logo.png');

-- Create the service_project table
CREATE TABLE service_project (
    service_project_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL
);

-- Insert sample service projects
INSERT INTO service_project (name, description)
VALUES
    ('Park Cleanup', 'Join us to clean up local parks and make them beautiful!'),
    ('Food Drive', 'Help collect and distribute food to those in need.'),
    ('Community Tutoring', 'Volunteer to tutor students in various subjects.');

-- Create the category table
CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
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
    service_project_id INTEGER NOT NULL REFERENCES service_project(service_project_id) ON DELETE CASCADE,
    category_id INTEGER NOT NULL REFERENCES category(category_id) ON DELETE CASCADE,
    PRIMARY KEY (service_project_id, category_id)
);

-- Associate each service project with one or more categories
INSERT INTO project_category (service_project_id, category_id)
VALUES
    ((SELECT service_project_id FROM service_project WHERE name = 'Park Cleanup'), (SELECT category_id FROM category WHERE name = 'Environmental')),
    ((SELECT service_project_id FROM service_project WHERE name = 'Park Cleanup'), (SELECT category_id FROM category WHERE name = 'Community Service')),
    ((SELECT service_project_id FROM service_project WHERE name = 'Food Drive'), (SELECT category_id FROM category WHERE name = 'Community Service')),
    ((SELECT service_project_id FROM service_project WHERE name = 'Food Drive'), (SELECT category_id FROM category WHERE name = 'Health and Wellness')),
    ((SELECT service_project_id FROM service_project WHERE name = 'Community Tutoring'), (SELECT category_id FROM category WHERE name = 'Educational'));
