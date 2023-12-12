import React from 'react';
import Header from './components/Header';
import LoginForm from './components/LoginForm';
import Footer from './components/Footer';
import './App.css';

function App() {
  return (
    <div className="App">
      <Header />
      <LoginForm />
      <Footer />
    </div>
  );
}

export default App;