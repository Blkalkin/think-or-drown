import React from 'react';
import tdlogo from './tdlogo.svg';

const Header = () => (
  <header style={{display: 'flex', justifyContent: 'space-between', padding: '1rem'}}>
    <img src={tdlogo} alt="TD Ameritrade" style={{ height: '50px' }} />
    <div>
      <select name="languages" style={{background: 'none', border: 'none', color: 'white'}}>
        <option value="en">English</option>
      </select>
    </div>
  </header>
);

export default Header;