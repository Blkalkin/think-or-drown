import React, { useState, useEffect } from 'react';
import axios from 'axios';
import TopBar from './TopBar';
import './Dashboard.css';

const Dashboard = () => {
  const [portfolio, setPortfolio] = useState(null);
  const [marketStocks, setMarketStocks] = useState([]);

  useEffect(() => {
    // Set withCredentials to true for axios to send cookies with requests
    axios.defaults.withCredentials = true;

    // Fetch portfolio data
    axios.get('http://localhost:3000/portfolios/1')
      .then(response => {
        setPortfolio(response.data);
      })
      .catch(error => {
        console.error('Error fetching portfolio data', error);
      });

    // Fetch market stocks data
    axios.get('http://localhost:3000/market_stocks')
      .then(response => {
        setMarketStocks(response.data);
      })
      .catch(error => {
        console.error('Error fetching market stocks data', error);
      });
  }, []);

  const handleBuy = (tickerSymbol, quantity) => {
    axios.post(`http://localhost:3000/portfolios/1/stocks/buy`, {
      ticker_symbol: tickerSymbol,
      quantity: quantity
    }).then(response => {
      // Update the portfolio data after buying
      setPortfolio(prevPortfolio => ({
        ...prevPortfolio,
        stocks: [...prevPortfolio.stocks, response.data]
      }));
    }).catch(error => {
      console.error('Error buying stock', error);
    });
  };

  const handleSell = (stockId, quantity) => {
    axios.delete(`http://localhost:3000/portfolios/1/stocks/${stockId}/sell`, {
      data: { quantity: quantity }
    }).then(response => {
      // Update the portfolio data after selling
      setPortfolio(prevPortfolio => ({
        ...prevPortfolio,
        stocks: prevPortfolio.stocks.filter(stock => stock.id !== stockId || stock.quantity > quantity)
      }));
    }).catch(error => {
      console.error('Error selling stock', error);
    });
  };

  return (
    <div>
      <TopBar />
      <div className="dashboard-container">
        <section className="account-summary">
          <h2>Account Summary</h2>
          <div>Account Value: ${portfolio?.total_value}</div>
          <div>Buying Power: ${portfolio?.current_cash}</div>
        </section>

        <section className="market-stocks">
          <h2>Market Stocks</h2>
          <ul>
            {marketStocks.map(stock => (
              <li key={stock.id}>
                {stock.name} (${stock.current_price})
                <button onClick={() => handleBuy(stock.id)}>Buy</button>
              </li>
            ))}
          </ul>
        </section>

        <section className="individual-positions">
          <h2>Individual Positions</h2>
          <table>
            <thead>
              {/* ... table headers ... */}
            </thead>
            <tbody>
              {portfolio?.stocks.map(stock => (
                <tr key={stock.id}>
                  <td>{stock.name}</td>
                  {/* ... other stock details ... */}
                  <td>
                    <button onClick={() => handleSell(stock.id)}>Sell</button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </section>
      </div>
    </div>
  );
};

export default Dashboard;

