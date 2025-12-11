import React, { useState, useEffect } from 'react';
import axios from 'axios';

const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8001';

const IndexPage = () => {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await axios.get(`${API_URL}/health`);
        setData(response.data);
      } catch (error) {
        console.error("Error fetching data:", error);
        setData({ status: 'error', message: 'Could not connect to API Gateway' });
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  return (
    <div style={{ padding: '20px', fontFamily: 'Arial, sans-serif' }}>
      <h1>Sahool Platform Frontend</h1>
      <p>Status: {loading ? 'Loading...' : data.status}</p>
      <p>Message: {data ? data.message || data.service : 'N/A'}</p>
      <p>API URL: {API_URL}</p>
      <p>This is the corrected v6.8.1 final build.</p>
      <p>Next steps: Integrate with auth-service, geo-service, etc.</p>
    </div>
  );
};

export default IndexPage;
