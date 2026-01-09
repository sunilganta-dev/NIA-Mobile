import pkg from "pg";
const { Pool } = pkg;

const connectDB = async () => {
  const pool = new Pool({
    connectionString: process.env.POSTGRES_URL,
  });

  try {
    await pool.connect();
    console.log("PostgreSQL connected");
  } catch (err) {
    console.error(err);
  }
};

export default connectDB;
