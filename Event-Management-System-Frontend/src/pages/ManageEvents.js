
import React from "react";
import { Route, Switch, Redirect } from "react-router-dom";
import PerfectScrollbar from "perfect-scrollbar";

import AdminNavbar from "components/Navbars/AdminNavbar.js";
import Footer from "components/Footer/Footer.js";
import Sidebar from "components/Sidebar/Sidebar.js";
import FixedPlugin from "components/FixedPlugin/FixedPlugin.js";

import routes from "routes.js";

import logo from "assets/img/react-logo.png";
import Dashboard from "views/Dashboard";
import TableList from "views/TableList";
import { Button, ButtonGroup, Card, CardBody, CardHeader, CardTitle, Col, DropdownItem, DropdownMenu, DropdownToggle, FormGroup, Input, Label, Row, Table, UncontrolledDropdown, UncontrolledTooltip } from "reactstrap";
import { Line } from "react-chartjs-2";

var ps;

class ManageEvents extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            backgroundColor: "blue",
            sidebarOpened:
                document.documentElement.className.indexOf("nav-open") !== -1
        };
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
        return (
            <>
                <div className="wrapper">
                    {/* <Sidebar
                        {...this.props}
                        routes={routes}
                        bgColor={this.state.backgroundColor}

                        toggleSidebar={this.toggleSidebar}
                    /> */}
                    <div
                        className="main-panel"
                        ref="mainPanel"
                        data={this.state.backgroundColor}
                    >

                        <Switch>
                            {/* {this.getRoutes(routes)} */}
                            {/* <Route path='/dashboard' component={DashboardPage} /> */}
                            {/* <Route path='/userprofile' component={UserProfile} /> */}
                            {/* <Redirect from="*" to="/admin/dashboard" /> */}
                            {/* <UserProfile /> */}
                            <TableList />
                        </Switch>
                        {// we don't want the Footer to be rendered on map page
                            this.props.location.pathname.indexOf("maps") !== -1 ? null : (
                                <Footer fluid />
                            )}
                    </div>
                </div>
                {/* <FixedPlugin
                    bgColor={this.state.backgroundColor}
                    handleBgClick={this.handleBgClick}
                /> */}
            </>
        );
    }
}

export default ManageEvents;
