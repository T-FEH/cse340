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

export {getAllProjects, getProjectsByOrganizationId, getUpcomingProjects, getProjectDetails}
