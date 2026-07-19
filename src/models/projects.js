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

export {getAllProjects, getProjectsByOrganizationId}
