import React, { useState } from 'react';
import axios from 'axios';

const LoginForm = () => {
  const [loginId, setLoginId] = useState('');
  const [password, setPassword] = useState(''); 

 
  const handleLogin = async (event) => {
    event.preventDefault(); 

    try {
      const response = await axios.post('http://localhost:8000/users/sign_in', {
        user: {
          email: loginId, 
          password: password,
        },
      });

      console.log(response.data);

    } catch (error) {
      console.error('Login error:', error);
    }
  };

  return (
    <div style={{flexGrow: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center'}}>
      <form onSubmit={handleLogin} style={{width: '320px'}}>
        <div style={{marginBottom: '1rem'}}>
          <label htmlFor="loginId" style={{display: 'block', marginBottom: '0.5rem'}}>Login ID</label>
          <input 
            id="loginId" 
            type="text" 
            value={loginId} 
            onChange={(e) => setLoginId(e.target.value)} 
            style={{width: '100%', padding: '10px', marginBottom: '0.5rem'}}
          />
          <label htmlFor="password" style={{display: 'block', marginBottom: '0.5rem'}}>Password</label>
          <input 
            id="password" 
            type="password" 
            value={password} 
            onChange={(e) => setPassword(e.target.value)} 
            style={{width: '100%', padding: '10px', marginBottom: '0.5rem'}}
          />
          <div style={{display: 'flex', alignItems: 'center', justifyContent: 'space-between'}}>
            <label>
              <input type="checkbox" /> Remember Login ID
            </label>
            <a href="#" style={{color: '#4b9cd3'}}>Forgot Login ID?</a>
          </div>
        </div>
        <button type="submit" style={{width: '100%', padding: '10px', backgroundColor: '#007aff', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer'}}>Continue</button>
      </form>
    </div>
  );
};

export default LoginForm;
