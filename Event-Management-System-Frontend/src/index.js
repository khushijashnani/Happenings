
import React from "react";
import ReactDOM from "react-dom";
import { createBrowserHistory } from "history";
import { Router, Route, Switch, Redirect } from "react-router-dom";

import AdminLayout from "layouts/Admin/Admin.js";
import RTLLayout from "layouts/RTL/RTL.js";

import "assets/scss/black-dashboard-react.scss";
import "assets/demo/demo.css";
import "assets/css/nucleo-icons.css";
import LoginPage from "pages/LoginPage";
import DashboardPage from "pages/DashboardPage";
import UserProfile from "views/UserProfile";
import UserProfilePage from "pages/UserProfilePage";
import { Provider } from 'react-redux';
import store from './Store';
import ManageEvents from "pages/ManageEvents";
import MainPage from "pages/MainPage";


const hist = createBrowserHistory();

ReactDOM.render(
  <Provider store={store}>

    <Router history={hist}>

      <Switch>
        <Route path='/login' component={LoginPage} />
        <Route path='/admin' component={MainPage} />
        {/* <Route path='/userprofile' component={MainPage} />
        <Route path='/events' component={MainPage} /> */}


        <Redirect from="/" to="/login" />
      </Switch>
    </Router>
  </Provider>,
  document.getElementById("root")
);
