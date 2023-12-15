import React, { useState } from 'react';
import './CreateUserForm.css'; // Import the CSS file here
import axios from 'axios';
import { useNavigate } from 'react-router-dom';

const CreateUserForm = () => {
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const handleCreateUser = (event) => {
    event.preventDefault();
  
    const userData = {
      user: {
        username: username,
        email: email,
        password: password
      }
    };
  
    axios.post('/signup', userData)
      .then(response => {
        console.log('User created:', response.data);
        navigate('/dashboard');
      })
      
      .catch(error => {
        console.error('Error creating user:', error);
      });
  };

  return (
    <div className="create-user-container">
      <h1>Create User</h1>
      <form onSubmit={handleCreateUser} className="create-user-form">
        <label htmlFor="username">Username</label>
        <input
          id="username"
          type="text"
          value={username}
          onChange={(e) => setUsername(e.target.value)}
        />
        
        <label htmlFor="email">Email</label>
        <input
          id="email"
          type="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
        
        <label htmlFor="password">Password</label>
        <input
          id="password"
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />
        
        <button type="submit" className="create-user-button">Create User</button>
      </form>
    </div>
  );
};

export default CreateUserForm;
