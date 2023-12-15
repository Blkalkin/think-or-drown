import React, { useState, useEffect } from 'react';
import axios from 'axios';
import TopBar from './TopBar';
import './Dashboard.css';

const Dashboard = () => {
  const [portfolio, setPortfolio] = useState({ stocks: [] });
  const [marketStocks, setMarketStocks] = useState([]);
  const [selectedBuyQuantity, setSelectedBuyQuantity] = useState({});
  const [selectedSellQuantity, setSelectedSellQuantity] = useState({});

  useEffect(() => {
    axios.defaults.withCredentials = true;

    axios.get('/portfolios/1')
      .then(response => setPortfolio(response.data))
      .catch(error => console.error('Error fetching portfolio data', error));

    axios.get('/market_stocks')
      .then(response => setMarketStocks(response.data))
      .catch(error => console.error('Error fetching market stocks data', error));
  }, []);

  const handleBuy = (tickerSymbol) => {
    const quantity = selectedBuyQuantity[tickerSymbol];
    if (quantity > 0) {
      axios.post(`/portfolios/1/stocks/buy`, {
        ticker_symbol: tickerSymbol,
        quantity: quantity
      })
      .then(response => {
        setPortfolio(prevPortfolio => ({
          ...prevPortfolio,
          stocks: [...prevPortfolio.stocks, response.data.stock],
          current_cash: response.data.current_cash
        }));
        // Reset the selected quantity after buying
        setSelectedBuyQuantity(prevQuantities => ({
          ...prevQuantities,
          [tickerSymbol]: ''
        }));
      })
      .catch(error => console.error('Error buying stock', error));
    }
  };

  const handleSell = (stockId) => {
    const quantity = selectedSellQuantity[stockId];
    if (quantity > 0) {
      axios.delete(`/portfolios/1/stocks/${stockId}/sell`, {
        data: { quantity: quantity }
      })
      .then(response => {
        setPortfolio(prevPortfolio => ({
          ...prevPortfolio,
          stocks: prevPortfolio.stocks.map(stock =>
            stock.id === stockId ? { ...stock, quantity: stock.quantity - quantity } : stock
          ).filter(stock => stock.quantity > 0),
          current_cash: response.data.current_cash
        }));
        // Reset the selected quantity after selling
        setSelectedSellQuantity(prevQuantities => ({
          ...prevQuantities,
          [stockId]: ''
        }));
      })
      .catch(error => console.error('Error selling stock', error));
    }
  };

  return (
    <div>
      <TopBar />
      <div className="dashboard-container">
        <section className="account-summary">
          <h2>Account Summary</h2>
          <div>Account Value: ${portfolio.total_value}</div>
          <div>Buying Power: ${portfolio.current_cash}</div>
        </section>

        <section className="market-stocks">
          <h2>Market Stocks</h2>
          <ul>
            {marketStocks.map(stock => (
              <li key={stock.id}>
                {stock.name} (${stock.current_price})
                <input
                  type="number"
                  value={selectedBuyQuantity[stock.ticker_symbol] || ''}
                  onChange={(e) => setSelectedBuyQuantity({
                    ...selectedBuyQuantity,
                    [stock.ticker_symbol]: e.target.value
                  })}
                  placeholder="Quantity"
                />
                <button onClick={() => handleBuy(stock.ticker_symbol)}>Buy</button>
              </li>
            ))}
          </ul>
        </section>

        <section className="individual-positions">
          <h2>Individual Positions</h2>
          <table>
            <thead>
              <tr>
                <th>Position</th>
                <th>Qty</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              {portfolio.stocks.map(stock => (
                <tr key={stock.id}>
                  <td>{stock.name}</td>
                  <td>{stock.quantity}</td>
                  <td>
                    <input
                      type="number"
                      value={selectedSellQuantity[stock.id] || ''}
                      onChange={(e) => setSelectedSellQuantity({
                        ...selectedSellQuantity,
                        [stock.id]: e.target.value
                      })}
                      placeholder="Quantity"
                    />
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
