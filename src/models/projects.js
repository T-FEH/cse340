import db from './db.js'

const getAllProjects = async() => {
    const query = `
        SELECT service_project_id, name, description
      FROM public.service_project;
    `;

    const result = await db.query(query);

    return result.rows;
}

export {getAllProjects}
