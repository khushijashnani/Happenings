
/*eslint-disable*/
import React, { useContext } from "react";
import { NavLink, Link } from "react-router-dom";
// nodejs library to set properties for components
import { PropTypes } from "prop-types";
import axios from 'axios'
// javascript plugin used to create scrollbars on windows
import PerfectScrollbar from "perfect-scrollbar";
import { connect } from "react-redux";
// reactstrap components
import { Nav, NavLink as ReactstrapNavLink } from "reactstrap";
import eventContext from "context/eventContext";
import AdminNavbar from "components/Navbars/AdminNavbar";

var ps;


class Sidebar extends React.Component {
  constructor(props) {
    super(props);
    this.activeRoute.bind(this);
  }
  // verifies if routeName is the one active (in browser input)
  activeRoute(routeName) {
    return this.props.location.pathname.indexOf(routeName) > -1 ? "active" : "";
  }
  async componentDidMount() {
    if (navigator.platform.indexOf("Win") > -1) {
      ps = new PerfectScrollbar(this.refs.sidebar, {
        suppressScrollX: true,
        suppressScrollY: false
      });
    }

    // this.setState({ ...this.state, loading: true });
    // const res = await axios
    //   .get(
    //     `https://cors-anywhere.herokuapp.com/https://rpk-happenings.herokuapp.com/ORGANISATION/${sessionStorage.getItem(
    //       'organisationid'
    //     )}`,
    //     { headers: { Authorization: sessionStorage.getItem('Authorization') } }
    //   )
    //   .then((res) => {
    //     console.log(res);
    //     // this.assignData(res);
    //     var dispatch = this.props.dispatch;
    //     dispatch({
    //       type: "GET_DATA",
    //       payload: res.data
    //     });
    //   });
  }
  componentWillUnmount() {
    if (navigator.platform.indexOf("Win") > -1) {
      ps.destroy();
    }
  }
  linkOnClick = () => {
    document.documentElement.classList.remove("nav-open");
  };
  render() {
    const { bgColor, routes, rtlActive, logo } = this.props;
    let logoImg = null;
    let logoText = null;
    if (logo !== undefined) {
      if (logo.outterLink !== undefined) {
        logoImg = (
          <a
            href={logo.outterLink}
            className="simple-text logo-mini"
            target="_blank"
            onClick={this.props.toggleSidebar}
          >
            <div className="logo-img">
              <img src={logo.imgSrc} alt="react-logo" />
            </div>
          </a>
        );
        logoText = (
          <a
            href={logo.outterLink}
            className="simple-text logo-normal"
            target="_blank"
            onClick={this.props.toggleSidebar}
          >
            {logo.text}
          </a>
        );
      } else {
        logoImg = (
          <Link
            to={logo.innerLink}
            className="simple-text logo-mini"
            onClick={this.props.toggleSidebar}
          >
            <div className="logo-img">
              <img src={logo.imgSrc} alt="react-logo" />
            </div>
          </Link>
        );
        logoText = (
          <Link
            to={logo.innerLink}
            className="simple-text logo-normal"
            onClick={this.props.toggleSidebar}
          >
            {logo.text}
          </Link>
        );
      }
    }
    return (<>
      <AdminNavbar {...this.props}
        brandText={'Happenings'}
        toggleSidebar={this.toggleSidebar}
      />
      <div className="sidebar" data='blue'>
        <div className="sidebar-wrapper" ref="sidebar">
          {logoImg !== null || logoText !== null ? (
            <div className="logo">
              {logoImg}
              {logoText}
            </div>
          ) : null}
          <Nav>
            {routes.map((prop, key) => {
              if (prop.redirect) return null;
              return (
                <li
                  className={
                    this.activeRoute(prop.path) +
                    (prop.pro ? " active-pro" : "")
                  }
                  key={key}
                >
                  <NavLink
                    to={prop.layout + prop.path}
                    className="nav-link"
                    activeClassName="active"
                    onClick={this.props.toggleSidebar}
                  >
                    <i className={prop.icon} />
                    <p>{rtlActive ? prop.rtlName : prop.name}</p>
                  </NavLink>
                </li>
              );
            })}

          </Nav>
        </div>
      </div>
    </>
    );
  }
}

Sidebar.defaultProps = {
  rtlActive: false,
  bgColor: "primary",
  routes: [{}]
};

Sidebar.propTypes = {
  // if true, then instead of the routes[i].name, routes[i].rtlName will be rendered
  // insde the links of this component
  rtlActive: PropTypes.bool,
  bgColor: PropTypes.oneOf(["primary", "blue", "green"]),
  routes: PropTypes.arrayOf(PropTypes.object),
  logo: PropTypes.shape({
    // innerLink is for links that will direct the user within the app
    // it will be rendered as <Link to="...">...</Link> tag
    innerLink: PropTypes.string,
    // outterLink is for links that will direct the user outside the app
    // it will be rendered as simple <a href="...">...</a> tag
    outterLink: PropTypes.string,
    // the text of the logo
    text: PropTypes.node,
    // the image src of the logo
    imgSrc: PropTypes.string
  })
};
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
export default (Sidebar);

// export default Sidebar;