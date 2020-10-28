
import React from "react";
// used for making the prop types of this component
import PropTypes from "prop-types";

// reactstrap components
import { Container, Row, Nav, NavItem, NavLink } from "reactstrap";
import { FaGithub } from "react-icons/fa";

class Footer extends React.Component {
  render() {
    return (
      <footer className="footer">
        <Container fluid>

          <div className="copyright">
            <Nav>
              <NavItem>
                <FaGithub size='2em' />
              </NavItem>
              <NavItem>
                <NavLink
                  href='https://github.com/rishikaul22'
                  rel='noopener noreferrer'
                  target='_blank'
                >
                  Rishi Kaul
                </NavLink>
              </NavItem>

              <NavItem>
                <NavLink
                  href='https://github.com/khushijashnani'
                  rel='noopener noreferrer'
                  target='_blank'
                >
                  Khushi Jashnani
                </NavLink>
              </NavItem>

              <NavItem>
                <NavLink
                  href='https://github.com/priyavmehta'
                  rel='noopener noreferrer'
                  target='_blank'
                >
                  Priyav Mehta
                </NavLink>
              </NavItem>
            </Nav>
          </div>
        </Container>
      </footer>
    );
  }
}

export default Footer;
