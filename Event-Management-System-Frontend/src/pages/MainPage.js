import Sidebar from 'components/Sidebar/Sidebar'

import routes from 'routes'

import React, { Component } from 'react'
import { Route, Switch } from 'react-router-dom'
import axios from 'axios'
import { connect } from 'react-redux'


class MainPage extends Component {
    async componentDidMount() {
        const res = await axios
            .get(
                `https://rpk-happenings.herokuapp.com/ORGANISATION/${sessionStorage.getItem(
                    'organisationid'
                )}`,
                { headers: { Authorization: sessionStorage.getItem('Authorization') } }
            )
            .then((res) => {
                console.log(res);
                // this.assignData(res);
                var dispatch = this.props.dispatch;
                dispatch({
                    type: "GET_DATA",
                    payload: res.data
                });
            });
    }
    getRoutes = routes => {
        return routes.map((prop, key) => {
            if (prop.layout === "/admin") {
                return (
                    <Route
                        path={prop.layout + prop.path}
                        component={prop.component}
                        key={key}
                    />
                );
            } else {
                return null;
            }
        });
    };
    render() {
        return (
            <div className="wrapper">
                <div>
                    <Sidebar
                        {...this.props}
                        routes={routes}
                    />
                    <Switch>
                        {this.getRoutes(routes)}
                    </Switch>
                </div>
            </div>
        )
    }
}
const mapStateToProps = (state, ownProps) => {
    return {
        events: state.events,
        userDetails: state.user_details,
        loading: state.loading,
        eventMap: state.eventMap,
        pieData: state.pie_data,
        lineData: state.lineGraph,
        reviewData: state.reviewGraph,
        catData: state.catGraph,
        noOfEvents: state.noOfEvents,
        attendees: state.attendees,
        revenue: state.revenue,
        reviews: state.reviews
    };
};
export default connect(mapStateToProps)(MainPage)