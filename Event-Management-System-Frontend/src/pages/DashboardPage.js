
import React from "react";
import { Route, Switch, Redirect } from "react-router-dom";
import PerfectScrollbar from "perfect-scrollbar";

import AdminNavbar from "components/Navbars/AdminNavbar.js";
import Footer from "components/Footer/Footer.js";
import Sidebar from "components/Sidebar/Sidebar.js";
import FixedPlugin from "components/FixedPlugin/FixedPlugin.js";

import routes from "routes.js";
import store from '../Store'
import logo from "assets/img/react-logo.png";
import Dashboard from "views/Dashboard";
import UserProfile from "views/UserProfile";
import axios from 'axios'
import eventContext from "context/eventContext";

var ps;

class DashboardPage extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            backgroundColor: "primary",
            loading: false,
            events: [],
            sidebarOpened:
                document.documentElement.className.indexOf("nav-open") !== -1
        };
        store.subscribe(() => {
            this.setState({
                events: store.getState().events,

            })
        })
    }
    componentDidMount() {

        if (navigator.platform.indexOf("Win") > -1) {
            document.documentElement.className += " perfect-scrollbar-on";
            document.documentElement.classList.remove("perfect-scrollbar-off");
            ps = new PerfectScrollbar(this.refs.mainPanel, { suppressScrollX: true });
            let tables = document.querySelectorAll(".table-responsive");
            for (let i = 0; i < tables.length; i++) {
                ps = new PerfectScrollbar(tables[i]);
            }
        }
    }
    componentWillUnmount() {
        if (navigator.platform.indexOf("Win") > -1) {
            ps.destroy();
            document.documentElement.className += " perfect-scrollbar-off";
            document.documentElement.classList.remove("perfect-scrollbar-on");
        }
    }
    componentDidUpdate(e) {
        if (e.history.action === "PUSH") {
            if (navigator.platform.indexOf("Win") > -1) {
                let tables = document.querySelectorAll(".table-responsive");
                for (let i = 0; i < tables.length; i++) {
                    ps = new PerfectScrollbar(tables[i]);
                }
            }
            document.documentElement.scrollTop = 0;
            document.scrollingElement.scrollTop = 0;
            this.refs.mainPanel.scrollTop = 0;
        }
    }
    // this function opens and closes the sidebar on small devices
    toggleSidebar = () => {
        document.documentElement.classList.toggle("nav-open");
        this.setState({ sidebarOpened: !this.state.sidebarOpened });
    };

    handleBgClick = color => {
        this.setState({ backgroundColor: color });
    };

    render() {
        console.log(store.getState().noOfEvents)
        return (
            <>
                <div className="wrapper">

                    <div
                        className="main-panel"
                        ref="mainPanel"
                        data={this.state.backgroundColor}
                    >
                        <Dashboard />

                        <Footer fluid />

                    </div>
                </div>

            </>
        );
    }
}

export default DashboardPage;
