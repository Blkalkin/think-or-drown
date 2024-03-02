import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './Dashboard.css'

const Dashboard = () => {
  const [ticker, setTicker] = useState('');
  const [currentPrice, setCurrentPrice] = useState(null);
  const [quantity, setQuantity] = useState(0);
  const [tradeType, setTradeType] = useState('buy'); // or 'sell'
  const [portfolios, setPortfolios] = useState([]); // State for storing portfolio data
  const [account, setAccount] = useState([])
  const [additionalCash, setAdditionalCash] = useState(10000); 

  function constructQuery(tickerSymbol) {
    const apiKey = '2G0EFUgJp5XxRAa2unpWyJ3oqqnKrJHa';
    const now = new Date();
    const marketOpenTime = new Date(now);
    const marketCloseTime = new Date(now);
  
    // Set market open and close times (9:30 AM and 4:00 PM in ET)
    marketOpenTime.setUTCHours(13, 30); // 9:30 AM ET in UTC
    marketCloseTime.setUTCHours(20); // 4:00 PM ET in UTC
  
    // Check if current time is within market hours
    const isMarketOpen = now >= marketOpenTime && now <= marketCloseTime && now.getDay() >= 1 && now.getDay() <= 5;
  
    // Format the dates as 'YYYY-MM-DD'
    const formattedNow = now.toISOString().split('T')[0];
    
    let from, to;
    if (isMarketOpen) {
      const fifteenMinutesAgo = new Date(now.getTime() - 15 * 60000);
      from = fifteenMinutesAgo.toISOString().split('T')[0];
      to = formattedNow;
    } else {
      // Set to the previous day initially
      now.setDate(now.getDate() - 1);
  
      // If today is Sunday, go back to Friday
      if (now.getDay() === 0) {
        now.setDate(now.getDate() - 2);
      }
      // If today is Saturday, go back to Friday
      else if (now.getDay() === 6) {
        now.setDate(now.getDate() - 1);
      }
  
      // If it's before market opening on a weekday, go back one more day
      if (now.getDay() !== 0 && now.getDay() !== 6 && now < marketOpenTime) {
        now.setDate(now.getDate() - 1);
      }
  
      // Adjust for weekends by going back to the last Friday, if necessary
      if (now.getDay() === 0) {
        now.setDate(now.getDate() - 2);
      } else if (now.getDay() === 6) {
        now.setDate(now.getDate() - 1);
      }
  
      from = now.toISOString().split('T')[0];
      to = from;
    }
  
    // Construct the Polygon.io API endpoint URL
    const url = `https://api.polygon.io/v2/aggs/ticker/${tickerSymbol}/range/1/minute/${from}/${to}?apiKey=${apiKey}`;
  
    return url;
  }
  
  

  const fetchCurrentPrice = async () => {
    try {
      const url = constructQuery(ticker); // Use the constructQuery function to get the URL
      const response = await axios.get(url);
      const data = response.data;
      console.log(response);
      // Assuming the latest price is the closing price of the last available aggregate
      const lastPrice = data.results?.[data.results.length - 1]?.c;
      setCurrentPrice(lastPrice);
    } catch (error) {
      console.error('Error fetching current price', error);
      // Handle errors (e.g., show an error message)
    }
  };
  
  

  const handleTrade = async () => {
    const userId = '1'; // Replace with the actual user's ID
  
    // Construct the trade data
    const tradeData = {
      portfolio: {
        stock_ticker: ticker, // The state variable holding the ticker symbol
        stock_name: 'STOCK_NAME', // You will need to get this from somewhere
        bought_price: currentPrice, // The state variable holding the current price
        bought_quantity: tradeType === 'sell' ? -Math.abs(Number(quantity)) : Number(quantity), // Use negative quantity for selling
      },
    };
  
    // The endpoint for managing transactions (both buy and sell)
    const apiUrl = `/users/${userId}/manage_portfolio_transaction`;
  
    try {
      const response = await axios.post(apiUrl, tradeData, {
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': `Bearer ${authToken}`, // Include if using token-based auth
        },
      });
  
      // Handle the response
      if (response.status === 200 || response.status === 201 || response.status === 204) {
        console.log('Trade successful:', response.data);
      } else {
        console.error('Trade failed:', response.data);
      }
    } catch (error) {
      console.error('Error executing trade', error);
    }
  };
  

  const fetchPortfolioData = async () => {
    const userId = '1'; // Replace with the actual user's ID
    try {
      const response = await axios.get(`/users/${userId}/portfolio_data`);
      setPortfolios(response.data); // Update the state with the fetched portfolio data
    } catch (error) {
      console.error('Error fetching portfolio data', error);
      // Handle errors (e.g., show an error message)
    }
  };


  const fetchAccountData = async () => {
    const userId = '1'; // Replace with the actual user's ID
    try {
      const response = await axios.get(`/users/${userId}/get_user_info`);
      setAccount(response.data); // Update the state with the fetched portfolio data
    } catch (error) {
      console.error('Error fetching portfolio data', error);
      // Handle errors (e.g., show an error message)
    }
  };

  const updateCash = async () => {
    const userId = '1'; // Replace with the actual user's ID
    try {
      const apiUrl = `/users/${userId}/update_current_cash`;
      const response = await axios.post(apiUrl, { current_cash: additionalCash });
      // Handle the response
      console.log('Cash updated:', response.data);
      // You might want to fetch updated user data here
    } catch (error) {
      console.error('Error updating cash', error);
      // Handle errors (e.g., show an error message)
    }
  };

  useEffect(() => {
    fetchPortfolioData();
  }, []);

  return (
    <div className="dashboard">
   <div className="account-summary">
      <h2>Account Summary</h2>
      <div className="account-detail">
        <p className="account-label">Current Cash:</p>
        <p className="account-value">{account.account_cash}</p>
      </div>
      <div className="account-detail">
        <p className="account-label">Current Stock Value:</p>
        <p className="account-value">{account.account_stock_value}</p>
      </div>
      <div className="account-detail">
        <p className="account-label">Total Value:</p>
        <p className="account-value">{account.account_total_value}</p>
      </div>
      <button className="refresh-button" onClick={fetchAccountData}>Refresh Account</button>
    </div>
    
    <div className="positions">
      <h2>Positions</h2>
      <div className="add-cash">
        <select value={additionalCash} onChange={(e) => setAdditionalCash(Number(e.target.value))}>
          <option value={10000}>$10,000</option>
          <option value={20000}>$20,000</option>
          <option value={30000}>$30,000</option>
        </select>
        <button className="add-cash-button" onClick={updateCash}>Add Cash</button>
      </div>
      
      <button className="refresh-button" onClick={fetchPortfolioData}>Refresh Portfolios</button>
      
      {portfolios.map((portfolio, index) => (
        <div key={index} className="portfolio-item">
          <p>Ticker: {portfolio.stock_ticker}</p>
          <p>Name: {portfolio.stock_name}</p>
          <p>Quantity: {portfolio.bought_quantity}</p>
          <p>Bought Price: {portfolio.bought_price}</p>
        </div>
      ))}
    </div>
    
    <div className="trading-interface">
      <input 
        type="text" 
        value={ticker} 
        onChange={(e) => setTicker(e.target.value)} 
        placeholder="Enter ticker symbol" 
        className="ticker-input"
      />
      <button className="fetch-price-button" onClick={fetchCurrentPrice}>Get Current Price</button>
      <div className="current-price">Current Price: {currentPrice ? `$${currentPrice}` : 'N/A'}</div>
      <input 
        type="number" 
        value={quantity} 
        onChange={(e) => setQuantity(e.target.value)} 
        placeholder="Quantity" 
        className="quantity-input"
      />
      <select 
        value={tradeType} 
        onChange={(e) => setTradeType(e.target.value)} 
        className="trade-type-select"
      >
        <option value="buy">Buy</option>
        <option value="sell">Sell</option>
      </select>
      <button className="execute-trade-button" onClick={handleTrade}>Execute Trade</button>
    </div>
  </div>
  );
};

export default Dashboard;
