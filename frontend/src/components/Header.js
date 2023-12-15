import React from 'react';
import tdlogo from './tdlogo.svg';
import './Header.css';

const Header = () => (
  <header >
    <img src={tdlogo} alt="TD Ameritrade" />
    <div>
      <select name="languages" >
        <option value="en">English</option>
      </select>
    </div>
  </header>
);

export default Header;