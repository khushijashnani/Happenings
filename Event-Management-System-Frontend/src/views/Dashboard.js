
import React from "react";
// nodejs library that concatenates classes

// react plugin used to create charts
import { Line, Bar, Doughnut } from "react-chartjs-2";
import { FaUsers } from 'react-icons/fa'
import { BiDoughnutChart } from 'react-icons/bi'
import { BsGraphUp, } from 'react-icons/bs'
import { GoGraph, } from 'react-icons/go'
import { VscGraph, } from 'react-icons/vsc'
import store from '../Store'
// reactstrap components
import {

  Card,
  CardHeader,
  CardBody,
  CardTitle,
  Row,
  Col,
} from "reactstrap";

// core components


class Dashboard extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      bigChartData: "data1",
      noOfEvents: store.getState().noOfEvents,
      attendees: store.getState().attendees,
      revenue: store.getState().revenue,
      reviews: store.getState().reviews,
      pieData: {
        labels: store.getState().pieData.labels,
        datasets: [
          {
            backgroundColor: [
              'rgba(82,98,255,0.75)',
              'rgba(46,198,255,0.75)',
              'rgba(123,201,82,0.75)',
              'rgba(255,171,67,0.75)',
              'rgba(252,91,57,0.75)',
              'rgba(139,135,130,0.75)',
            ],
            label: "My First dataset",
            fill: true,
            // backgroundColor: gradientStroke,
            borderColor: "#ffffff",
            borderWidth: 0.5,
            borderDash: [],
            borderDashOffset: 0.0,
            pointBackgroundColor: "#1f8ef1",
            pointBorderColor: "rgba(255,255,255,0)",
            pointHoverBackgroundColor: "#1f8ef1",
            pointBorderWidth: 20,
            pointHoverRadius: 4,
            pointHoverBorderWidth: 15,
            pointRadius: 4,

            data: store.getState().pieData.data
          }
        ]
      },
      lineData: {
        labels: store.getState().lineData.labels,
        options: {
          maintainAspectRatio: false,
          legend: {
            display: false
          },
          tooltips: {
            backgroundColor: "#f5f5f5",
            titleFontColor: "#333",
            bodyFontColor: "#666",
            bodySpacing: 4,
            xPadding: 12,
            mode: "nearest",
            intersect: 0,
            position: "nearest"
          },
          responsive: true,
          scales: {
            yAxes: [
              {
                barPercentage: 1.6,
                gridLines: {
                  drawBorder: false,
                  color: "rgba(29,140,248,0.0)",
                  zeroLineColor: "transparent"
                },
                ticks: {
                  suggestedMin: 0,
                  // suggestedMax: Math.max(...store.getState().lineData.data),
                  padding: 20,
                  fontColor: "#9a9a9a"
                }
              }
            ],
            xAxes: [
              {
                barPercentage: 1.6,
                gridLines: {
                  drawBorder: false,
                  color: "rgba(29,140,248,0.1)",
                  zeroLineColor: "transparent"
                },
                ticks: {
                  padding: 20,
                  fontColor: "#9a9a9a"
                }
              }
            ]
          }
        },
        datasets: [
          {
            label: "Attendees",
            fill: true,
            // backgroundColor: '#984367',
            borderColor: "#1f8ef1",
            borderWidth: 2,
            borderDash: [],
            borderDashOffset: 0.0,
            pointBackgroundColor: "#1f8ef1",
            pointBorderColor: "rgba(255,255,255,0)",
            pointHoverBackgroundColor: "#1f8ef1",
            pointBorderWidth: 20,
            pointHoverRadius: 4,
            pointHoverBorderWidth: 15,
            pointRadius: 4,
            data: store.getState().lineData.data,
          }
        ],

      },
      reviewData: {
        labels: store.getState().reviewData.labels,
        options: {
          maintainAspectRatio: false,
          legend: {
            display: false
          },
          tooltips: {
            backgroundColor: "#f5f5f5",
            titleFontColor: "#333",
            bodyFontColor: "#666",
            bodySpacing: 4,
            xPadding: 12,
            mode: "nearest",
            intersect: 0,
            position: "nearest"
          },
          responsive: true,
          scales: {
            yAxes: [
              {
                gridLines: {
                  drawBorder: false,
                  color: "rgba(225,78,202,0.1)",
                  zeroLineColor: "transparent"
                },
                ticks: {
                  suggestedMin: 0,
                  // suggestedMax: Math.max(...store.getState().reviewData.data),
                  padding: 20,
                  fontColor: "#9e9e9e"
                }
              }
            ],
            xAxes: [
              {
                gridLines: {
                  drawBorder: false,
                  color: "rgba(225,78,202,0.1)",
                  zeroLineColor: "transparent"
                },
                ticks: {
                  padding: 20,
                  fontColor: "#9e9e9e"
                }
              }
            ]
          }
        },
        datasets: [
          {
            label: "Positive",
            fill: true,
            backgroundColor: 'rgba(82,98,255,0.75)',
            // hoverBackgroundColor: gradientStroke,
            borderColor: "#d048b6",
            borderWidth: 0,
            borderDash: [],
            borderDashOffset: 0.0,
            data: store.getState().reviewData.positive
          },
          {
            label: "Negative",
            fill: true,
            backgroundColor: 'rgba(252,91,57,0.75)',
            borderColor: "#1f8ef1",
            borderWidth: 0,
            borderDash: [],
            borderDashOffset: 0.0,
            pointBackgroundColor: "#1f8ef1",
            pointBorderColor: "rgba(255,255,255,0)",
            pointHoverBackgroundColor: "#1f8ef1",
            pointBorderWidth: 20,
            pointHoverRadius: 4,
            pointHoverBorderWidth: 15,
            pointRadius: 4,
            data: store.getState().reviewData.negative
          }
        ]

      },
      catData: {
        labels: store.getState().catData.labels,
        options: {
          maintainAspectRatio: false,
          legend: {
            display: false
          },
          tooltips: {
            backgroundColor: "#f5f5f5",
            titleFontColor: "#333",
            bodyFontColor: "#666",
            bodySpacing: 4,
            xPadding: 12,
            mode: "nearest",
            intersect: 0,
            position: "nearest"
          },
          responsive: true,
          scales: {
            yAxes: [
              {
                gridLines: {
                  drawBorder: false,
                  color: "rgba(225,78,202,0.1)",
                  zeroLineColor: "transparent"
                },
                ticks: {
                  suggestedMin: 0,
                  // suggestedMax: Math.max(...store.getState().catData.data),
                  padding: 20,
                  fontColor: "#9e9e9e"
                }
              }
            ],
            xAxes: [
              {
                gridLines: {
                  drawBorder: false,
                  color: "rgba(225,78,202,0.1)",
                  zeroLineColor: "transparent"
                },
                ticks: {
                  padding: 20,
                  fontColor: "#9e9e9e"
                }
              }
            ]
          }
        },
        datasets: [
          {
            label: "Category",
            fill: true,
            backgroundColor: 'rgba(82,98,255,0.75)',
            // hoverBackgroundColor: gradientStroke,
            borderColor: "#d048b6",
            borderWidth: 0,
            borderDash: [],
            borderDashOffset: 0.0,
            data: store.getState().catData.data
          },
        ]
      }
    };
    store.subscribe(() => {
      this.setState({
        ...this.state,
        noOfEvents: store.getState().noOfEvents,
        attendees: store.getState().attendees,
        revenue: store.getState().revenue,
        reviews: store.getState().reviews,
        pieData: {
          labels: store.getState().pieData.labels,
          datasets: [
            {
              backgroundColor: [
                'rgba(82,98,255,0.75)',
                'rgba(46,198,255,0.75)',
                'rgba(123,201,82,0.75)',
                'rgba(255,171,67,0.75)',
                'rgba(252,91,57,0.75)',
                'rgba(139,135,130,0.75)',
              ],
              label: "",
              fill: true,
              // backgroundColor: gradientStroke,
              borderColor: "#ffffff",
              borderWidth: 1,
              borderDash: [],
              borderDashOffset: 0.0,
              pointBackgroundColor: "#1f8ef1",
              pointBorderColor: "rgba(255,255,255,0)",
              pointHoverBackgroundColor: "#1f8ef1",
              pointBorderWidth: 20,
              pointHoverRadius: 4,
              pointHoverBorderWidth: 15,
              pointRadius: 4,

              data: store.getState().pieData.data
            }
          ]
        },
        lineData: {
          labels: store.getState().lineData.labels,
          options: {
            maintainAspectRatio: false,
            legend: {
              display: false
            },
            tooltips: {
              backgroundColor: "#f5f5f5",
              titleFontColor: "#333",
              bodyFontColor: "#666",
              bodySpacing: 4,
              xPadding: 12,
              mode: "nearest",
              intersect: 0,
              position: "nearest"
            },
            responsive: true,
            scales: {
              yAxes: [
                {
                  barPercentage: 1.6,
                  gridLines: {
                    drawBorder: false,
                    color: "rgba(29,140,248,0.0)",
                    zeroLineColor: "transparent"
                  },
                  ticks: {
                    suggestedMin: 0,
                    suggestedMax: Math.max(...store.getState().lineData.data),
                    padding: 20,
                    fontColor: "#9a9a9a"
                  }
                }
              ],
              xAxes: [
                {
                  barPercentage: 1.6,
                  gridLines: {
                    drawBorder: false,
                    color: "rgba(29,140,248,0.1)",
                    zeroLineColor: "transparent"
                  },
                  ticks: {
                    padding: 20,
                    fontColor: "#9a9a9a"
                  }
                }
              ]
            }
          },
          datasets: [
            {
              label: "",
              fill: true,
              // backgroundColor: gradientStroke,
              borderColor: "#1f8ef1",
              borderWidth: 2,
              borderDash: [],
              borderDashOffset: 0.0,
              pointBackgroundColor: "#1f8ef1",
              pointBorderColor: "rgba(255,255,255,0)",
              pointHoverBackgroundColor: "#1f8ef1",
              pointBorderWidth: 20,
              pointHoverRadius: 4,
              pointHoverBorderWidth: 15,
              pointRadius: 4,
              data: store.getState().lineData.data,
            }
          ]
        },
        reviewData: {
          labels: store.getState().reviewData.labels,
          options: {
            maintainAspectRatio: false,
            legend: {
              display: false
            },
            tooltips: {
              backgroundColor: "#f5f5f5",
              titleFontColor: "#333",
              bodyFontColor: "#666",
              bodySpacing: 4,
              xPadding: 12,
              mode: "nearest",
              intersect: 0,
              position: "nearest"
            },
            responsive: true,
            scales: {
              yAxes: [
                {
                  gridLines: {
                    drawBorder: false,
                    color: "rgba(225,78,202,0.1)",
                    zeroLineColor: "transparent"
                  },
                  ticks: {
                    suggestedMin: 0,
                    suggestedMax: Math.max(...store.getState().reviewData.positive),
                    padding: 20,
                    fontColor: "#9e9e9e"
                  }
                }
              ],
              xAxes: [
                {
                  gridLines: {
                    drawBorder: false,
                    color: "rgba(225,78,202,0.1)",
                    zeroLineColor: "transparent"
                  },
                  ticks: {
                    padding: 20,
                    fontColor: "#9e9e9e"
                  }
                }
              ]
            }
          },
          datasets: [
            {
              label: "Positive",
              fill: true,
              backgroundColor: 'rgba(82,98,255,0.75)',
              // hoverBackgroundColor: gradientStroke,
              borderColor: "#d048b6",
              borderWidth: 0,
              borderDash: [],
              borderDashOffset: 0.0,
              data: store.getState().reviewData.positive
            },
            {
              label: "Negative",
              fill: true,
              backgroundColor: 'rgba(252,91,57,0.75)',
              borderColor: "#1f8ef1",
              borderWidth: 0,
              borderDash: [],
              borderDashOffset: 0.0,
              pointBackgroundColor: "#1f8ef1",
              pointBorderColor: "rgba(255,255,255,0)",
              pointHoverBackgroundColor: "#1f8ef1",
              pointBorderWidth: 20,
              pointHoverRadius: 4,
              pointHoverBorderWidth: 15,
              pointRadius: 4,
              data: store.getState().reviewData.negative
            }
          ]

        },
        catData: {
          labels: store.getState().catData.labels,
          options: {
            maintainAspectRatio: false,
            legend: {
              display: false
            },
            tooltips: {
              backgroundColor: "#f5f5f5",
              titleFontColor: "#333",
              bodyFontColor: "#666",
              bodySpacing: 4,
              xPadding: 12,
              mode: "nearest",
              intersect: 0,
              position: "nearest"
            },
            responsive: true,
            scales: {
              yAxes: [
                {
                  gridLines: {
                    drawBorder: false,
                    color: "rgba(225,78,202,0.1)",
                    zeroLineColor: "transparent"
                  },
                  ticks: {
                    suggestedMin: 0,
                    suggestedMax: Math.max(...store.getState().catData.data),
                    padding: 20,
                    fontColor: "#9e9e9e"
                  }
                }
              ],
              xAxes: [
                {
                  gridLines: {
                    drawBorder: false,
                    color: "rgba(225,78,202,0.1)",
                    zeroLineColor: "transparent"
                  },
                  ticks: {
                    padding: 20,
                    fontColor: "#9e9e9e"
                  }
                }
              ]
            }
          },
          datasets: [
            {
              label: "Category",
              fill: true,
              backgroundColor: 'rgba(82,98,255,0.75)',
              // hoverBackgroundColor: gradientStroke,
              borderColor: "#d048b6",
              borderWidth: 0,
              borderDash: [],
              borderDashOffset: 0.0,
              data: store.getState().catData.data
            },
          ]
        }
      })
    })
  }
  setBgChartData = name => {
    this.setState({
      bigChartData: name
    });
  };
  render() {

    return (
      <>
        <div className="content">
          <Row>
            <Col lg="3">
              <Card className="card-chart">
                <CardHeader>
                  <h5 className="card-category">Events</h5>
                  <CardTitle tag="h3">
                    <i className="tim-icons icon-calendar-60 text-info" />{" "}
                    {this.state.noOfEvents}
                  </CardTitle>
                </CardHeader>
              </Card>
            </Col>
            <Col lg="3">
              <Card className="card-chart">
                <CardHeader>
                  <h5 className="card-category">Attendees</h5>
                  <CardTitle tag="h3">
                    {/* <i className="tim-icons icon-delivery-fast text-primary" />*/}
                    <FaUsers size='1.25rem' className='mb-1 text-primary' />{" "}
                    {this.state.attendees}
                  </CardTitle>
                </CardHeader>

              </Card>
            </Col>
            <Col lg="3">
              <Card className="card-chart">
                <CardHeader>
                  <h5 className="card-category">Revenue</h5>
                  <CardTitle tag="h3">
                    <i className="tim-icons icon-coins text-success" /> {this.state.revenue}
                  </CardTitle>
                </CardHeader>

              </Card>
            </Col>
            <Col lg="3">
              <Card className="card-chart">
                <CardHeader>
                  <h5 className="card-category">Reviews</h5>
                  <CardTitle tag="h3">
                    <i className="tim-icons icon-chat-33 text-warning" /> {this.state.reviews}
                  </CardTitle>
                </CardHeader>

              </Card>
            </Col>
          </Row>
          <Row>
            <Col xs="12">
              <Card className="card-chart" >
                <CardHeader>
                  <Row>
                    <Col className="text-left" sm="6">
                      <h5 className="card-category">Popularity Analysis</h5>
                      <CardTitle tag="h2"><BsGraphUp className='mb-1 text-info' size='1.3rem' />{" "}Attendees vs. Events</CardTitle>
                    </Col>

                  </Row>
                </CardHeader>
                <CardBody>
                  <div className="chart-area">
                    <Line
                      data={this.state.lineData}
                      options={this.state.lineData.options}
                    />


                  </div>
                </CardBody>
              </Card>
            </Col>
          </Row>
          <Row>
            <Col lg="4">
              <Card className="card-chart" style={{ height: '22rem' }}>
                <CardHeader>
                  <h5 className="card-category">Review Analysis</h5>
                  <CardTitle tag="h3">
                    <VscGraph className='text-danger' />{" "}
                    Reviews vs. Events
                  </CardTitle>
                </CardHeader>
                <CardBody>
                  <div className="chart-area">
                    {/* <Line
                      data={chartExample2.data}
                      options={chartExample2.options}
                    /> */}
                    <Bar
                      data={this.state.reviewData}
                      options={this.state.reviewData.options}
                    />
                  </div>
                </CardBody>
              </Card>
            </Col>
            <Col lg="4">
              <Card className="card-chart" style={{ height: '22rem' }}>
                <CardHeader>
                  <h5 className="card-category">Categorical Analysis</h5>
                  <CardTitle tag="h3">
                    <GoGraph className='text-primary' />{" "}
                    Attendees vs. Categories
                  </CardTitle>
                </CardHeader>
                <CardBody>
                  <div className="chart-area">
                    <Bar
                      data={this.state.catData}
                      options={this.state.reviewData.options}
                    />

                  </div>
                </CardBody>
              </Card>
            </Col>
            <Col lg="4">
              <Card className="card-chart" style={{ height: '22rem' }}>
                <CardHeader>
                  <h5 className="card-category">Event Analysis</h5>
                  <CardTitle tag="h3">
                    <BiDoughnutChart className='text-success' /> Events vs. Categories
                  </CardTitle>
                </CardHeader>
                <CardBody>
                  <div className="chart-area">

                    <Doughnut
                      data={this.state.pieData}
                      options={{ responsive: true, }}
                      legend={{
                        display: true,
                        position: 'left',
                        fullWidth: true,
                        reverse: false,
                        labels: {
                          fontColor: 'rgb(255, 255, 255)',
                        }

                      }}
                    />
                  </div>
                </CardBody>
              </Card>
            </Col>
          </Row>


        </div>
      </>
    );
  }
}

export default Dashboard;
