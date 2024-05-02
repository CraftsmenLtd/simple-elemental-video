import './App.css';
import Home from './screens/home';
import { BrowserRouter, Routes, Route } from "react-router-dom";

function App() {
  document.title = 'Web Player';
  return (
    <div className="App">
      <BrowserRouter>
        <Routes>
          <Route>
            <Route index element={<Home />} />
          </Route>
        </Routes>
      </BrowserRouter>
    </div >

  );
}

export default App;
