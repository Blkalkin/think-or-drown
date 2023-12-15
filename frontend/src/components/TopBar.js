import React from 'react';
import './TopBar.css'; // Make sure to create this CSS file
import tdlogo from './tdlogo.svg';

const TopBar = () => {
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
        <a href="/logout">Log Out</a>
      </div>
    </div>
  );
};

export default TopBar;
