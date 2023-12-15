import React, { useState } from 'react';
import './CreateUserForm.css'; // Import the CSS file here
import axios from 'axios';

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
  
    axios.post('http://localhost:3000/signup', userData)
      .then(response => {
        console.log('User created:', response.data);
        // Handle success (e.g., redirecting to a login page or displaying a success message)
      })
      .catch(error => {
        console.error('Error creating user:', error);
        // Handle error (e.g., displaying error messages to the user)
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
