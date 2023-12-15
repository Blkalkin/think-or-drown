import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Header from './components/Header';
import LoginForm from './components/LoginForm';
import CreateUserForm from './components/CreateUserForm'; // Import your CreateUserForm component
import Footer from './components/Footer';
import './App.css';
import Dashboard from './components/Dashboard';

function App() {
  return (
    <Router>
      <div className="App">
        {/* Define your routes within this component */}
        <Routes>
          <Route path="/" element={<LoginForm />} />
          <Route path="/create-user" element={<CreateUserForm />} />
          <Route path="/dashboard" element={<Dashboard />} /> {/* Your landing page route */}
          {/* Add more routes as needed */}
        </Routes>
        <Footer />
      </div>
    </Router>
  );
}

export default App;
