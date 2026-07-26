import db from './db.js'

const getAllProjects = async() => {
    const query = `
        SELECT service_project_id, name, description
      FROM public.service_project;
    `;

    const result = await db.query(query);

    return result.rows;
}

const getProjectsByOrganizationId = async (organizationId) => {
    const query = `
        SELECT
          service_project_id,
          organization_id,
          name,
          description
      FROM service_project
      WHERE organization_id = $1
      ORDER BY name;
    `;

    const queryParams = [organizationId];
    const result = await db.query(query, queryParams);

    return result.rows;
}

const getUpcomingProjects = async (number_of_projects) => {
    const query = `
        SELECT
          sp.service_project_id AS project_id,
          sp.name AS title,
          sp.description,
          sp.date,
          sp.location,
          sp.organization_id,
          o.name AS organization_name
      FROM service_project sp
      JOIN organization o ON sp.organization_id = o.organization_id
      WHERE sp.date >= CURRENT_DATE
      ORDER BY sp.date ASC
      LIMIT $1;
    `;

    const queryParams = [number_of_projects];
    const result = await db.query(query, queryParams);

    return result.rows;
}

const getProjectDetails = async (id) => {
    const query = `
        SELECT
          sp.service_project_id AS project_id,
          sp.name AS title,
          sp.description,
          sp.date,
          sp.location,
          sp.organization_id,
          o.name AS organization_name
      FROM service_project sp
      JOIN organization o ON sp.organization_id = o.organization_id
      WHERE sp.service_project_id = $1;
    `;

    const queryParams = [id];
    const result = await db.query(query, queryParams);

    // Return the first row of the result set, or null if no rows are found
    return result.rows.length > 0 ? result.rows[0] : null;
}

const getProjectsByCategoryId = async (categoryId) => {
    const query = `
        SELECT
          sp.service_project_id,
          sp.name,
          sp.description
      FROM service_project sp
      JOIN project_category pc ON sp.service_project_id = pc.service_project_id
      WHERE pc.category_id = $1
      ORDER BY sp.name;
    `;

    const queryParams = [categoryId];
    const result = await db.query(query, queryParams);

    return result.rows;
}

/**
 * Creates a new service project in the database.
 * @param {string} title - The title of the service project.
 * @param {string} description - A description of the service project.
 * @param {string} location - The location of the service project.
 * @param {string} date - The date of the service project.
 * @param {string} organizationId - The id of the sponsoring organization.
 * @returns {string} The id of the newly created service project record.
 */
const createProject = async (title, description, location, date, organizationId) => {
    const query = `
      INSERT INTO service_project (organization_id, name, description, date, location)
      VALUES ($1, $2, $3, $4, $5)
      RETURNING service_project_id
    `;

    const queryParams = [organizationId, title, description, date, location];
    const result = await db.query(query, queryParams);

    if (result.rows.length === 0) {
        throw new Error('Failed to create service project');
    }

    if (process.env.ENABLE_SQL_LOGGING === 'true') {
        console.log('Created new service project with ID:', result.rows[0].service_project_id);
    }

    return result.rows[0].service_project_id;
};

/**
 * Updates an existing service project in the database.
 * @param {string} id - The id of the service project to update.
 * @param {string} title - The title of the service project.
 * @param {string} description - A description of the service project.
 * @param {string} location - The location of the service project.
 * @param {string} date - The date of the service project.
 * @param {string} organizationId - The id of the sponsoring organization.
 */
const updateProject = async (id, title, description, location, date, organizationId) => {
    const query = `
      UPDATE service_project
      SET organization_id = $2, name = $3, description = $4, date = $5, location = $6
      WHERE service_project_id = $1
      RETURNING service_project_id
    `;

    const queryParams = [id, organizationId, title, description, date, location];
    const result = await db.query(query, queryParams);

    if (result.rows.length === 0) {
        throw new Error('Failed to update service project');
    }

    if (process.env.ENABLE_SQL_LOGGING === 'true') {
        console.log('Updated service project with ID:', id);
    }
};

export {getAllProjects, getProjectsByOrganizationId, getUpcomingProjects, getProjectDetails, getProjectsByCategoryId, createProject, updateProject}
