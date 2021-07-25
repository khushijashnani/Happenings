
import React from "react";
import store from '../Store'
// reactstrap components
import {
  Button,
  Card,
  CardHeader,
  CardBody,
  CardFooter,
  CardText,
  FormGroup,
  Form,
  Input,
  Row,
  Col
} from "reactstrap";
import axios from "axios";

class UserProfile extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      address: store.getState().user_details ? store.getState().user_details.address : '',
      details: store.getState().user_details ? store.getState().user_details.details : '',
      email_id: store.getState().user_details ? store.getState().user_details.email_id : '',
      image: store.getState().user_details ? store.getState().user_details.image : '',
      name: store.getState().user_details ? store.getState().user_details.name : '',
      password: store.getState().user_details ? store.getState().user_details.password : '',
      phone: store.getState().user_details ? store.getState().user_details.phone : '',
      subscription: store.getState().user_details ? store.getState().user_details.subscription : '',
      username: store.getState().user_details ? store.getState().user_details.username : '',
      loading: false
    }
    store.subscribe(() => {
      this.setState({
        address: store.getState().user_details.address,
        details: store.getState().user_details.details,
        email_id: store.getState().user_details.email_id,
        image: store.getState().user_details.image,
        name: store.getState().user_details.name,
        password: store.getState().user_details.password,
        phone: store.getState().user_details.phone,
        subscription: store.getState().user_details.subscription,
        username: store.getState().user_details.username,

      })
    })
  }
  activateMode = mode => {
    switch (mode) {
      case "light":
        document.body.classList.add("white-content");
        break;
      default:
        document.body.classList.remove("white-content");
        break;
    }
  };
  handleChange = (e) => {
    this.setState({ ...this.state, loading: false, [e.target.name]: e.target.value })

  }
  async updateDetails() {
    this.setState({ ...this.state, loading: true })
    const res = await axios.put(`https://rpk-happenings.herokuapp.com/ORGANISATION/${sessionStorage.getItem(
      'organisationid'
    )}`, {
      address: this.state.address,
      details: this.state.details,
      email_id: this.state.email_id,
      image: this.state.image,
      name: this.state.name,
      password: this.state.password,
      phone: this.state.phone,
      subscription: this.state.subscription,
      username: this.state.username

    },
      { headers: { Authorization: sessionStorage.getItem('Authorization') } }
    )
      .then((res) => {
        console.log(res);

      });
  }

  render() {
    return (
      <>
        <div className="content">
          <Row>
            <Col md="8">
              <Card>
                <CardHeader>
                  <h5 className="title">Edit Profile</h5>
                </CardHeader>
                <CardBody>
                  <Form>
                    <Row>
                      <Col md="6">
                        {/* pr-md-1 */}
                        <FormGroup>
                          <label>Organistaion Name</label>
                          <Input
                            placeholder="Organistaion Name"
                            type="text"
                            value={this.state.name}
                            name='name'
                            onChange={this.handleChange}
                          />
                        </FormGroup>
                      </Col>
                      <Col md="6">
                        {/* px-md-1 */}
                        <FormGroup>
                          <label>Username</label>
                          <Input
                            value={this.state.username}
                            name='username'
                            onChange={this.handleChange}

                            placeholder="Username"
                            type="text"
                          />
                        </FormGroup>
                      </Col>

                    </Row>
                    <Row>
                      <Col md="4">
                        {/* pl-md-1 */}
                        <FormGroup>
                          <label htmlFor="exampleInputEmail1">
                            Email address
                          </label>
                          <Input placeholder="mike@email.com" type="email" value={this.state.email_id}
                            name='email_id'
                            onChange={this.handleChange} />
                        </FormGroup>
                      </Col>
                      <Col md="4">
                        {/* pl-md-1 */}
                        <FormGroup>
                          <label htmlFor="exampleInputEmail1">
                            Password
                          </label>
                          <Input type="text" placeholder="Password" value={this.state.password}
                            name='password'
                            onChange={this.handleChange} />
                        </FormGroup>
                      </Col>
                      <Col md="4">
                        {/* pl-md-1 */}
                        <FormGroup>
                          <label htmlFor="exampleInputEmail1">
                            Phone
                          </label>
                          <Input placeholder="Phone Number" type="text" value={this.state.phone}
                            name='phone'
                            onChange={this.handleChange} />
                        </FormGroup>
                      </Col>
                    </Row>
                    <Row>
                      <Col md="12">
                        <FormGroup>
                          <label>Address</label>
                          <Input
                            value={this.state.address}
                            name='address'

                            onChange={this.handleChange}

                            placeholder="Organisation Address"
                            type="text"
                          />
                        </FormGroup>
                      </Col>
                    </Row>

                    <Row>
                      <Col md="12">
                        <FormGroup>
                          <label>Description</label>
                          <Input
                            cols="80"
                            value={this.state.details}
                            name='details'
                            onChange={this.handleChange}

                            placeholder="Anything about the organisation goes here"
                            rows="8"
                            type="textarea"
                          />
                        </FormGroup>
                      </Col>
                    </Row>
                  </Form>
                </CardBody>
                <CardFooter>
                  <Button className="btn-fill" disabled={this.state.loading} color="primary" type="submit" onClick={(e) => {
                    e.preventDefault()
                    this.updateDetails()
                  }}>
                    {this.state.loading ? 'Saved' : 'Save'}
                  </Button>
                  {/* <Button className="btn-fill" color="primary" type="submit" onClick={() => this.activateMode("dark")}>
                    Save
                  </Button> */}
                </CardFooter>
              </Card>
            </Col>
            <Col md="4">
              <Card className="card-user">
                <CardBody>
                  <CardText />
                  <div className="author">
                    <div className="block block-one" />
                    <div className="block block-two" />
                    <div className="block block-three" />
                    <div className="block block-four" />
                    <a href={this.state.image} >
                      <img
                        alt="..."
                        className="avatar"
                        src={this.state.image}
                      />
                      <h5 className="title">{this.state.name}</h5>
                    </a>

                  </div>
                  <div className="card-description">
                    {this.state.details}
                  </div>
                </CardBody>
                {/* <CardFooter>
                  <div className="button-container">
                    <Button className="btn-icon btn-round" color="facebook">
                      <i className="fab fa-facebook" />
                    </Button>
                    <Button className="btn-icon btn-round" color="twitter">
                      <i className="fab fa-twitter" />
                    </Button>
                    <Button className="btn-icon btn-round" color="google">
                      <i className="fab fa-google-plus" />
                    </Button>
                  </div>
                </CardFooter> */}
              </Card>
            </Col>
          </Row>
        </div>
      </>
    );
  }
}

export default UserProfile;
