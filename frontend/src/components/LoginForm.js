import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom'; 
import './LoginForm.css'; // Import the separate CSS file
import Header from './Header';

const LoginForm = () => {
  const [loginId, setLoginId] = useState('');
  const [password, setPassword] = useState(''); 
  const navigate = useNavigate(); // Create the navigate function

  const handleLogin = async (event) => {
    event.preventDefault(); 

    try {
      const response = await axios.post('http://localhost:3000/login', {
          username: loginId, 
          password: password,
      });

      // If login is successful, redirect to the landing page
      navigate('/dashboard'); // Replace '/dashboard' with the path to your landing page
      
      console.log(response.data);

    } catch (error) {
      console.error('Login error:', error);
      // Handle login error (e.g., show message to user)
    }
  };

  const handleCreateUser = () => {
    navigate('/create-user'); // Navigate to the create user page
  };

  return (
    <div>
    <Header/>
    <div className="login-container">
      <form onSubmit={handleLogin} className="login-form">
        <div className="form-group">
          <label htmlFor="loginId">Login ID</label>
          <input 
            id="loginId" 
            type="text" 
            value={loginId} 
            onChange={(e) => setLoginId(e.target.value)} 
          />
          <label htmlFor="password">Password</label>
          <input 
            id="password" 
            type="password" 
            value={password} 
            onChange={(e) => setPassword(e.target.value)} 
          />
          <div className="login-utilities">
            <label>
              <input type="checkbox" /> Remember Login ID
            </label>
            <a href="#" className="forgot-id-link">Forgot Login ID?</a>
          </div>
        </div>
        <button type="submit" className="continue-button">Continue</button>
        <button type="button" className="create-user-button" onClick={handleCreateUser} >Create User</button>
      </form>
    </div>
    </div>
  );
};

export default LoginForm;
