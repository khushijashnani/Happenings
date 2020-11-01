
import React from "react";
// nodejs library that concatenates classes
import classNames from "classnames";
import { CgDarkMode } from 'react-icons/cg'
// reactstrap components
import {
  Button,
  Collapse,
  DropdownToggle,
  DropdownMenu,
  DropdownItem,
  UncontrolledDropdown,
  Input,
  InputGroup,
  NavbarBrand,
  Navbar,
  NavLink,
  Nav,
  Container,
  Modal
} from "reactstrap";
import store from "../../Store";
import LoginPage from "pages/LoginPage";
import { Link } from "react-router-dom";

class AdminNavbar extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      collapseOpen: false,
      modalSearch: false,
      color: "navbar-transparent",
      mode: 'light',
      backgroundColor: "blue",
      name: '',
      image: '',
    };
    store.subscribe(() => {
      this.setState({ ...this.state, name: store.getState().user_details.name, image: store.getState().user_details.image })

    })
  }

  activateMode = mode => {
    console.log(this.state.mode)
    if (this.state.mode === 'dark') {
      this.setState({ ...this.state, mode: 'light', backgroundColor: 'blue' })
      document.body.classList.add("white-content");

    }
    else {
      this.setState({ ...this.state, mode: 'dark', backgroundColor: 'primary' })
      document.body.classList.remove("white-content");
    }
    switch (mode) {
      case "light":
        document.body.classList.add("white-content");
        break;
      default:
        document.body.classList.remove("white-content");
        break;
    }
  };
  componentDidMount() {
    window.addEventListener("resize", this.updateColor);
  }
  componentWillUnmount() {
    window.removeEventListener("resize", this.updateColor);
  }
  // function that adds color white/transparent to the navbar on resize (this is for the collapse)
  updateColor = () => {
    if (window.innerWidth < 993 && this.state.collapseOpen) {
      this.setState({
        color: "bg-white"
      });
    } else {
      this.setState({
        color: "navbar-transparent"
      });
    }
  };
  // this function opens and closes the collapse on small devices
  toggleCollapse = () => {
    if (this.state.collapseOpen) {
      this.setState({
        color: "navbar-transparent"
      });
    } else {
      this.setState({
        color: "bg-white"
      });
    }
    this.setState({
      collapseOpen: !this.state.collapseOpen
    });
  };
  // this function is to open the Search modal
  toggleModalSearch = () => {
    this.setState({
      modalSearch: !this.state.modalSearch
    });
  };
  render() {
    return (
      <>
        <Navbar
          className={classNames("navbar-absolute", this.state.color)}
          expand="lg"
        >
          <Container fluid>
            <div className="navbar-wrapper">
              <div
                className={classNames("navbar-toggle d-inline", {
                  toggled: this.props.sidebarOpened
                })}
              >
                <button
                  className="navbar-toggler"
                  type="button"
                  onClick={this.props.toggleSidebar}
                >
                  <span className="navbar-toggler-bar bar1" />
                  <span className="navbar-toggler-bar bar2" />
                  <span className="navbar-toggler-bar bar3" />
                </button>
              </div>
              <NavbarBrand style={{ color: 'white', fontSize: '1.25rem' }} onClick={e => e.preventDefault()}>
                {this.props.brandText}
              </NavbarBrand>
              {/* <div className='navbar-sticky' style={{ color: 'white', fontSize: '1.25rem', position: 'static' }} onClick={e => e.preventDefault()}>
                {this.props.brandText}
              </div> */}
            </div>
            <button
              aria-expanded={false}
              aria-label="Toggle navigation"
              className="navbar-toggler"
              data-target="#navigation"
              data-toggle="collapse"
              id="navigation"
              type="button"
              onClick={this.toggleCollapse}
            >
              <span className="navbar-toggler-bar navbar-kebab" />
              <span className="navbar-toggler-bar navbar-kebab" />
              <span className="navbar-toggler-bar navbar-kebab" />
            </button>
            <Collapse navbar isOpen={this.state.collapseOpen}>
              <Nav className="ml-auto" navbar>
                {/* <InputGroup className="search-bar"> */}
                {/* <Button
                  color="link"

                  onClick={() => {
                    this.activateMode(this.state.mode)

                  }}
                > */}
                {/* <i className="tim-icons icon-zoom-split" /> */}
                {/* <CgDarkMode size='1.75em' color={this.state.mode === 'light' ? 'white' : 'black'} />
                  <span className="d-lg-none d-md-block">Toggler</span>
                </Button> */}
                {/* </InputGroup> */}

                <UncontrolledDropdown nav>
                  <DropdownToggle
                    caret
                    color="default"
                    data-toggle="dropdown"
                    nav
                    onClick={e => e.preventDefault()}
                  >
                    <div className="photo">
                      <img alt="..." src={this.state.image} />
                      {/* <span style={{ fontSize: '1.25rem' }}>
                        <b>{this.state.name[0]}</b>
                      </span> */}
                    </div>
                    <b className="caret d-none d-lg-block d-xl-block" />
                    <p className="d-lg-none">Log out</p>
                  </DropdownToggle>
                  <DropdownMenu className="dropdown-navbar" right tag="ul">
                    {/* <NavLink tag="li">
                      <DropdownItem className="nav-item">Profile</DropdownItem>
                    </NavLink>
                    <NavLink tag="li">
                      <DropdownItem className="nav-item">Settings</DropdownItem>
                    </NavLink>
                    <DropdownItem divider tag="li" /> */}
                    <Link to='/login' onClick={() => {
                      sessionStorage.removeItem('Authorization');
                      sessionStorage.removeItem('organisationid');
                    }}>
                      <DropdownItem className="nav-item">Log out</DropdownItem>
                    </Link>
                  </DropdownMenu>
                </UncontrolledDropdown>
                <li className="separator d-lg-none" />
              </Nav>
            </Collapse>
          </Container>
        </Navbar>
        <Modal
          modalClassName="modal-search"
          isOpen={this.state.modalSearch}
          toggle={this.toggleModalSearch}
        >
          <div className="modal-header">
            <Input id="inlineFormInputGroup" placeholder="SEARCH" type="text" />
            <button
              aria-label="Close"
              className="close"
              data-dismiss="modal"
              type="button"
              onClick={this.toggleModalSearch}
            >
              <i className="tim-icons icon-simple-remove" />
            </button>
          </div>
        </Modal>
      </>
    );
  }
}

export default AdminNavbar;
