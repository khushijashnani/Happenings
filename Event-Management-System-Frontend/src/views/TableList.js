
import React from "react";
import store from '../Store'
// reactstrap components
import {
  Card,
  CardHeader,
  CardBody,
  CardTitle,
  Table,
  Row,
  Col, Button, CardFooter, CardText, Input, FormGroup
} from "reactstrap";
import axios from "axios";
class Tables extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      events: store.getState().events,
      eventMap: store.getState().eventMap,
      eventIndex: 0,
    }
    store.subscribe(() => {
      this.setState({
        events: store.getState().events,
        eventMap: store.getState().eventMap
      })
    })
  }

  render() {
    console.log(this.state.events)
    return (
      <>
        <div className="content">
          <Row>
            <Col md="4">
              <Card>
                <CardHeader>
                  <CardTitle className='font-weight-bold' tag="h4">Events</CardTitle>
                </CardHeader>
                <CardBody>
                  <Table className="tablesorter" responsive>
                    <thead className="text-primary">
                      <tr>

                        <th>Name</th>
                        <th>Category</th>

                      </tr>
                    </thead>
                    <tbody>
                      {this.state.events.map((event) => (

                        <tr key={event.id} onClick={() => this.setState({ ...this.state, eventIndex: this.state.eventMap[event.id] })}>

                          <td>{event.title}</td>
                          <td>{event.category}</td>
                        </tr>

                      ))}

                    </tbody>
                  </Table>
                </CardBody>
              </Card>
            </Col>
            <Col md="8">
              <Card className="card-user">
                <CardBody>
                  <CardText />
                  <div className="author">
                    <div className="block block-one" />
                    <div className="block block-two" />
                    <div className="block block-three" />
                    <div className="block block-four" />
                    {/* <a href={this.state.image} > */}
                    <img
                      alt="..."
                      className="avatar"
                      src={this.state.events[this.state.eventIndex] ? this.state.events[this.state.eventIndex].image : '...'}
                    />
                    <h5 className="h3">{this.state.events[this.state.eventIndex] ? this.state.events[this.state.eventIndex].title : ''}</h5>
                    {/* </a> */}

                  </div>

                  <FormGroup>
                    <Row>
                      <Col md='6' className='offset-md-3' >
                        <label>Description</label>
                        <Input
                          cols="80"
                          value={this.state.events[this.state.eventIndex] ? this.state.events[this.state.eventIndex].description : ''}
                          name='details'


                          placeholder="Anything about the event goes here"
                          rows="8"
                          type="textarea"
                        />
                      </Col>
                    </Row>
                  </FormGroup>
                  <FormGroup>
                    <Row>
                      <Col md='6' className='offset-md-3' >
                        <label>Location</label>
                        <Input
                          placeholder="Location"
                          type="text"

                          value={this.state.events[this.state.eventIndex] ? this.state.events[this.state.eventIndex].location : ''}
                          // value={this.state.name}
                          name='name'
                        // onChange={this.handleChange}
                        />
                      </Col>
                    </Row>
                  </FormGroup>
                  <FormGroup>
                    <Row>
                      <Col md='2' className='offset-md-3' >
                        <label>Entry Amount</label>
                        <Input
                          placeholder="Entry Amount"
                          type="text"

                          value={this.state.events[this.state.eventIndex] ? this.state.events[this.state.eventIndex].entry_amount : ''}
                          // value={this.state.name}
                          name='name'
                        // onChange={this.handleChange}
                        />
                      </Col>
                      <Col md='2'>
                        <label>Current Count</label>
                        <Input
                          placeholder="23/9/2020"
                          type="text"

                          value={this.state.events[this.state.eventIndex] ? this.state.events[this.state.eventIndex].current_count : ''}
                          // value={this.state.name}
                          name='name'
                        // onChange={this.handleChange}
                        />
                      </Col>
                      <Col md='2'>
                        <label>Max Count</label>
                        <Input
                          placeholder="24/9/2020"
                          type="text"

                          value={this.state.events[this.state.eventIndex] ? this.state.events[this.state.eventIndex].max_count : ''}
                          // value={this.state.name}
                          name='name'
                        // onChange={this.handleChange}
                        />
                      </Col>
                    </Row>
                  </FormGroup>
                  <FormGroup>
                    <Row>
                      <Col md='3' className='offset-md-3'>
                        <label>Start Date:</label>
                        <Input
                          placeholder="23/9/2020"
                          type="text"

                          value={this.state.events[this.state.eventIndex] ? this.state.events[this.state.eventIndex].start_date : ''}
                          // value={this.state.name}
                          name='name'
                        // onChange={this.handleChange}
                        />
                      </Col>
                      <Col md='3'>
                        <label>End Date:</label>
                        <Input
                          placeholder="24/9/2020"
                          type="text"

                          value={this.state.events[this.state.eventIndex] ? this.state.events[this.state.eventIndex].end_date : ''}
                          // value={this.state.name}
                          name='name'
                        // onChange={this.handleChange}
                        />
                      </Col>
                    </Row>
                  </FormGroup>
                  <FormGroup>
                    <Row>
                      <Col md='3' className='offset-md-3' >
                        <label>Speciality</label>
                        <Input
                          placeholder="Speciality"
                          type="text"

                          // value={this.state.name}
                          value={this.state.events[this.state.eventIndex] ? this.state.events[this.state.eventIndex].speciality : ''}
                          name='name'
                        // onChange={this.handleChange}
                        />
                      </Col>
                      <Col md='3' >
                        <label>Category</label>
                        <Input
                          placeholder="Category"
                          type="text"

                          value={this.state.events[this.state.eventIndex] ? this.state.events[this.state.eventIndex].category : ''}
                          // value={this.state.name}
                          name='name'
                        // onChange={this.handleChange}
                        />
                      </Col>
                    </Row>
                  </FormGroup>
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

export default Tables;
