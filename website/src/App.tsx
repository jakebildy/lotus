import React from 'react';
import './App.css';
import { Route, Routes } from 'react-router-dom';
import { useLocation } from 'react-router-dom';
import ReactGA from "react-ga4";

import { AdminStatsPage } from './admin/dashboard/AdminStatsPage';

// const UA = "UA-217661993-1";
const MEASUREMENT_ID = "G-44DV5KNM1E";

try {
  ReactGA.initialize(MEASUREMENT_ID, { testMode: false });
  console.log("initilized GA: G-300104300");
}
catch (error) {
  console.log("Failed to initilized GA");
  console.log(error);
}

function App() {
  let location = useLocation();
  React.useEffect(() => {
    console.log("path: " + location.pathname);
    ReactGA.send({ hitType: "pageview", page: location.pathname });
  }, [location]);

  return (
    <Routes>
      <Route path="/*" element={<AdminStatsPage />} />
    </Routes>
  );
}

export default App;
