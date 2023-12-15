import React from 'react';
import axios from 'axios';
import './TopBar.css'; // Make sure to create this CSS file
import tdlogo from './tdlogo.svg';
import { useNavigate } from 'react-router-dom';

const TopBar = () => {
  const navigate = useNavigate(); 

  const handleLogout = async () => {
    try {
      const response = await axios.post('/logout');
      console.log(response.data);
      
      // Navigate to login or home page after successful logout
      navigate('/'); 

    } catch (error) {
      console.error('Logout error:', error);
    }
  };
  return (
    <div className="top-bar">
      <div className="logo-container">
        <img src={tdlogo} alt="Logo" className="logo" />
      </div>
      <div className="status-container">
        <span className="status-indicator connected">Connected</span>
        <span className="status-time">9:49:12 until open</span>
      </div>
      <div className="top-bar-links">
        <a href="/education">Education</a>
        <a href="/notifications">Notifications</a>
        <a href="/feedback">Feedback</a>
        <a href="/support">Support</a>
        <a href="/settings">Settings</a>
        <a onClick={handleLogout}>Log Out</a>
      </div>
    </div>
  );
};

export default TopBar;
